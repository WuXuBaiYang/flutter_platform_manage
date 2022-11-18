import 'dart:isolate';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/model/db/package.dart';

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
  final Map<int, Isolate> _packagingQueue = {};

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
    return startTask(
        ids: _taskQueue.values
            .where((e) => e.status == PackageStatus.prepare)
            .map((e) => e.id)
            .toList());
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
      final t = <int>[];
      c = c > ids.length ? ids.length : c;
      for (var id in ids.sublist(0, c)) {
        /// 启动下载任务线程
        // 开始打包任务,开始成功之后记录id统一更新状态
        if (ids.remove(id)) t.add(id);
      }
      // 更新添加成功的任务状态为打包中
      await dbManage.updatePackageStatus(t, PackageStatus.packing);
    }
    // 剩下没有立即开始的任务状态更新为准备中
    return dbManage.updatePackageStatus(ids, PackageStatus.prepare);
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
      final isolate = _packagingQueue.remove(id);

      /// 停止打包任务
      ids.remove(id);
    }
    return dbManage.updatePackageStatus(ids, PackageStatus.stopped);
  }
}

//单例调用
final packageTaskManage = PackageTaskManage();
