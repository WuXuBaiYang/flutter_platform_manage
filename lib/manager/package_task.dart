import 'dart:isolate';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
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

  // 打包任务列表
  final Map<int, Package> _packageTasks = {};

  // 打包任务队列
  final Map<int, Isolate> _taskQueue = {};

  // 打包队列并发数量
  final _maxQueueController = ValueChangeNotifier<int>(1);

  @override
  Future<void> init() async {
    // 加载已有任务列表
    _packageTasks.addAll(dbManage
        .loadPackageTaskList()
        .asMap()
        .map((_, v) => MapEntry(v.id, v)));
    // 监听最大打包队列
    _maxQueueController.addListener(resumeTask);
  }

  // 更新打包队列最大并发数
  bool updateMaxQueue(int count) {
    if (count <= 0 || count > 3) return false;
    return _maxQueueController.setValue(count);
  }

  // 添加任务到队列
  Future<bool> addTask(Package package) async {
    // 设置打包状态并写入数据库添加到任务队列
    package.status = PackageStatus.prepare;
    final result = await dbManage.addPackage(package);
    if (result == null) return false;
    final id = package.id;
    _packageTasks[id] = package;
    return resumeTask(ids: [id]);
  }

  // 移除打包任务
  Future<bool> removeTask({List<int> ids = const []}) async {
    if (ids.isEmpty) ids.addAll(_packageTasks.keys);
    // 停止全部任务并移除
    if (!await stopTask(ids: ids)) return false;
    final l = await dbManage.deletePackages(ids);
    if (l != ids.length) return false;
    _packageTasks.removeWhere((e, _) => ids.contains(e));
    return true;
  }

  // 开始/恢复打包任务
  Future<bool> resumeTask({List<int> ids = const []}) async {
    final maxQueue = _maxQueueController.value;
    if (ids.isEmpty) ids.addAll(_packageTasks.keys);
    return true;
  }

  // 停止打包任务
  Future<bool> stopTask({List<int> ids = const []}) async {
    if (ids.isEmpty) ids.addAll(_packageTasks.keys);
    return true;
  }
}

//单例调用
final packageTaskManage = PackageTaskManage();
