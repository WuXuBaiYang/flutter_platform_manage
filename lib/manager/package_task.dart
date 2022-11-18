import 'dart:async';
import 'dart:io';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/utils/date.dart';
import 'package:flutter_platform_manage/utils/file.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';

/*
* 打包任务管理
* @author wuxubaiyang
* @Time 2022/11/17 14:47
*/
class PackageTaskManage extends BaseManage {
  static final PackageTaskManage _instance = PackageTaskManage._internal();

  factory PackageTaskManage() => _instance;

  PackageTaskManage._internal();

  // 任务列表
  final Map<int, Package> _taskQueue = {};

  // 打包队列
  final Map<int, ShellController> _packagingQueue = {};

  // 打包队列并发数量
  int _maxQueue = 1;

  // 同步等待信号灯
  bool _inProcess = false;

  @override
  Future<void> init() async {
    // 加载已有任务列表
    _taskQueue.addAll(dbManage
        .loadPackageTaskList()
        .asMap()
        .map((_, v) => MapEntry(v.id, v)));
  }

  // 更新打包队列最大并发数
  Future<bool> updateMaxQueue(int count) async {
    if (_inProcess) return false;
    if (count <= 0 || count > 3) return false;
    _maxQueue = count;
    // 打包队列变更之后，启动准备中的任务进入队列
    return _resumeTask();
  }

  // 添加任务到队列
  Future<bool> addTask(Package package) async {
    if (_inProcess) return false;
    // 设置打包状态并写入数据库添加到任务队列
    package.status = PackageStatus.prepare;
    final result = await dbManage.addPackage(package);
    if (result == null) return false;
    final id = package.id;
    _taskQueue[id] = package;
    return startTask(ids: [id]);
  }

  // 移除打包任务
  Future<bool> removeTask({List<int> ids = const []}) async {
    if (_inProcess) return false;
    if (ids.isEmpty) ids.addAll(_taskQueue.keys);
    // 停止全部任务并移除
    if (!await stopTask(ids: ids)) return false;
    final l = await dbManage.deletePackages(ids);
    if (l != ids.length) return false;
    _taskQueue.removeWhere((e, _) => ids.contains(e));
    return true;
  }

  // 恢复任务
  Future<bool> _resumeTask() async {
    if (_inProcess) return false;
    return startTask(
        ids: _taskQueue.values
            .where((e) => e.status == PackageStatus.prepare)
            .map((e) => e.id)
            .toList());
  }

  // 开始打包任务（不传id则启动全部任务）
  Future<bool> startTask({List<int> ids = const []}) async {
    if (_inProcess) return false;
    _inProcess = true;
    if (ids.isEmpty) ids.addAll(_taskQueue.keys);
    // 剔除准备中/打包中/停止中的任务
    ids.removeWhere((e) => const [
          PackageStatus.prepare,
          PackageStatus.packing,
          PackageStatus.stopping,
        ].contains(_taskQueue[e]?.status));
    // 判断打包队列中是否有空位
    var c = _maxQueue - _packagingQueue.length;
    if (c > 0) {
      // 存在空位则取出前n位进入打包任务
      final t = <int>[], e = <int>[];
      c = c > ids.length ? ids.length : c;
      for (var id in ids.sublist(0, c)) {
        // 开始打包任务,开始成功之后记录id统一更新状态
        final package = _taskQueue[id];
        if (package == null) {
          ids.remove(id);
          e.add(id);
        } else if (await _startPackage(package)) {
          ids.remove(id);
          t.add(id);
        }
      }
      // 更新添加成功的任务状态为打包中
      await dbManage.updatePackageStatus(t, PackageStatus.packing);
      // 更新添加失败的任务状态为打包失败
      await dbManage.updatePackageStatus(e, PackageStatus.fail);
    }
    // 剩下没有立即开始的任务状态更新为准备中
    await dbManage.updatePackageStatus(ids, PackageStatus.prepare);
    _inProcess = false;
    return true;
  }

  // 停止打包任务(不传id则停止所有任务)
  Future<bool> stopTask({List<int> ids = const []}) async {
    if (_inProcess) return false;
    _inProcess = true;
    if (ids.isEmpty) ids.addAll(_taskQueue.keys);
    // 剔除异常/停止中/已停止的任务
    ids.removeWhere((e) => const [
          PackageStatus.fail,
          PackageStatus.stopping,
          PackageStatus.stopped,
        ].contains(_taskQueue[e]?.status));
    // 判断是否有打包中的任务，存在则停止打包
    final t = _packagingQueue.keys.where((e) => ids.contains(e)).toList();
    await dbManage.updatePackageStatus(t, PackageStatus.stopping);
    for (var id in t) {
      final task = _packagingQueue.remove(id);
      if (task == null || (await task.kill() && ids.remove(id))) {
        continue;
      }
      _packagingQueue[id] = task;
    }
    await dbManage.updatePackageStatus(ids, PackageStatus.stopped);
    _inProcess = false;
    return _resumeTask();
  }

  // 添加打包任务至队列
  Future<bool> _startPackage(Package package) async {
    final pro = dbManage.loadProject(package.projectId);
    final env = dbManage.loadEnvironment(package.envId);
    if (pro == null || env == null) return false;
    final startTime = DateTime.now().millisecondsSinceEpoch;
    final c = ShellController();
    final logs = [], errors = [];
    c.addOutListener(logs.add);
    c.addErrOutListener(errors.add);
    ScriptHandle.buildApp(env.path, pro.path,
            platform: package.platform, controller: c)
        .then((v) => _completePackage(
            package
              ..logs.add(logs.join('/n'))
              ..errors.add(errors.join('/')),
            startTime,
            v))
        .catchError((e) => _packageFail(
            package
              ..logs.add(logs.join('/n'))
              ..errors.add(errors.join('/n')),
            e));
    _packagingQueue[package.id] = c;
    return true;
  }

  // 完成打包
  FutureOr _completePackage(Package package, int startTime, bool v) async {
    if (v) {
      final endTime = DateTime.now();
      final spentTime = endTime.millisecondsSinceEpoch - startTime;
      final dir = await FileTool.getDirPath(
          '${ProjectFilePath.packageOutput}/'
          '${package.projectId}/'
          '${package.platform.name}_${endTime.format(DatePattern.dateSign)}',
          root: FileDir.applicationDocuments);
      final pro = dbManage.loadProject(package.projectId);
      final old = File(
          '${pro?.path}/${ProjectFilePath.getPlatformOutput(package.platform)}');
      final outputPath = await old.copy('$dir/${old.name}');
      final size = await FileTool.getDirSize(outputPath.parent.path);
      package
        ..status = PackageStatus.completed
        ..completeTime = endTime
        ..timeSpent = spentTime
        ..outputPath = outputPath.path
        ..packageSize = size;
    } else {
      package.status = PackageStatus.fail;
    }
    await dbManage.addPackage(package);
    await _resumeTask();
  }

  // 打包异常处理
  FutureOr _packageFail(Package package, err) async {
    package.status = package.status == PackageStatus.stopping
        ? PackageStatus.stopped
        : PackageStatus.fail;
    await dbManage.addPackage(package);
    await _resumeTask();
  }
}

//单例调用
final packageTaskManage = PackageTaskManage();
