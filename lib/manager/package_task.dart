import 'dart:async';
import 'dart:io';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/manager/cache.dart';
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
  // 最大并发数缓存字段
  final String _maxQueueCacheKey = 'max_queue_cache_key';

  static final PackageTaskManage _instance = PackageTaskManage._internal();

  factory PackageTaskManage() => _instance;

  PackageTaskManage._internal();

  // // 任务列表
  // final Map<int, Package> _taskQueue = {};

  // 打包队列
  final Map<int, ShellController> _packagingQueue = {};

  // 打包队列并发数量
  int _maxQueue = 1;

  // 同步等待信号灯
  bool _inProcess = false;

  @override
  Future<void> init() async {
    // 获取最大并发数
    _maxQueue = cacheManage.getInt(_maxQueueCacheKey) ?? 1;
  }

  // 获取最大打包并发数
  int get maxQueue => _maxQueue;

  // 更新打包队列最大并发数
  Future<bool> updateMaxQueue(int count) async {
    if (_inProcess) return false;
    if (count <= 0 || count > 3) return false;
    if (!await cacheManage.setInt(
      _maxQueueCacheKey,
      count,
    )) return false;
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
    return startTask(ids: [package.id]);
  }

  // 移除打包任务
  Future<bool> removeTask({required List<int> ids}) async {
    if (ids.isEmpty) return true;
    if (_inProcess) return false;
    // 停止全部任务并移除
    if (!await stopTask(ids: ids)) return false;
    await dbManage.deletePackages(ids);
    return true;
  }

  // 恢复任务
  Future<bool> _resumeTask() async {
    if (_inProcess) return false;
    return startTask(
        ids: dbManage
            .loadPackageTaskList()
            .where((e) => e.status == PackageStatus.prepare)
            .map((e) => e.id)
            .toList());
  }

  // 开始打包任务
  Future<bool> startTask({required List<int> ids}) async {
    if (ids.isEmpty) return true;
    if (_inProcess) return false;
    // 剔除打包中/停止中的任务
    ids = dbManage.filterPackageIdsByStatus(ids, const [
      PackageStatus.prepare,
      PackageStatus.stopped,
      PackageStatus.fail,
    ]);
    if (ids.isEmpty) return true;
    _inProcess = true;
    // 判断打包队列中是否有空位
    var c = _maxQueue - _packagingQueue.length;
    if (c > 0) {
      // 存在空位则取出前n位进入打包任务
      final t = <int>[], e = <int>[];
      c = c > ids.length ? ids.length : c;
      for (var id in ids.sublist(0, c)) {
        // 开始打包任务,开始成功之后记录id统一更新状态
        final package = dbManage.loadPackage(id);
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

  // 停止打包任务
  Future<bool> stopTask({required List<int> ids}) async {
    if (ids.isEmpty) return true;
    if (_inProcess) return false;
    ids = dbManage.filterPackageIdsByStatus(ids, const [
      PackageStatus.prepare,
      PackageStatus.packing,
    ]);
    if (ids.isEmpty) return true;
    _inProcess = true;
    // 判断是否有打包中的任务，存在则停止打包
    final t = _packagingQueue.keys.where((e) => ids.contains(e)).toList();
    await dbManage.updatePackageStatus(t, PackageStatus.stopping);
    for (var id in t) {
      final task = _packagingQueue.remove(id);
      if (task == null) continue;
      if (!await task.kill()) {
        ids.remove(id);
        continue;
      }
      // 如果没杀死，则恢复状态为打包中
      await dbManage.updatePackageStatus([id], PackageStatus.packing);
      _packagingQueue[id] = task;
    }
    await dbManage.updatePackageStatus(ids, PackageStatus.stopped);
    _inProcess = false;
    return _resumeTask();
  }

  // 添加打包任务至队列
  Future<bool> _startPackage(Package package) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    final pro = dbManage.loadProject(package.projectId);
    final env = dbManage.loadEnvironment(package.envId);
    if (pro == null || env == null) return false;
    final c = ShellController();
    _packagingQueue[package.id] = c;
    // 开始打包任务（因为状态需要立即更新，所以此处的打包操作为异步处理）
    ScriptHandle.buildApp(
      env.path,
      pro.path,
      platform: package.platform,
      controller: c,
    ).then((v) {
      if (!v) return _packageFail(package.id, c);
      return _completePackage(package.id, c, startTime);
    }).catchError((_) async {
      if (!c.isKilled) return _packageFail(package.id, c);
    });
    return true;
  }

  // 完成打包
  Future<void> _completePackage(
      int id, ShellController c, int startTime) async {
    final package = dbManage.loadPackage(id);
    if (package == null) return;
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
    if (await c.hasOutput) package.logs.add(await c.outputLog);
    if (await c.hasOutputErr) package.logs.add(await c.outputErr);
    await dbManage.updatePackage(package
      ..status = PackageStatus.completed
      ..completeTime = endTime
      ..timeSpent = spentTime
      ..outputPath = outputPath.path
      ..packageSize = size);
    _packagingQueue.remove(package.id);
    await _resumeTask();
  }

  // 打包异常处理
  Future<void> _packageFail(int id, ShellController c) async {
    final package = dbManage.loadPackage(id);
    if (package == null) return;
    if (await c.hasOutput) package.logs.add(await c.outputLog);
    if (await c.hasOutputErr) package.logs.add(await c.outputErr);
    await dbManage.updatePackage(package..status = PackageStatus.fail);
    _packagingQueue.remove(package.id);
    await _resumeTask();
  }
}

//单例调用
final packageTaskManage = PackageTaskManage();
