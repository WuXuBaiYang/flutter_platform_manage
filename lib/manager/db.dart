import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:isar/isar.dart';

/*
* 数据库管理
* @author wuxubaiyang
* @Time 5/12/2022 16:39
*/
class DBManage extends BaseManage {
  static final DBManage _instance = DBManage._internal();

  factory DBManage() => _instance;

  DBManage._internal();

  // isar对象持有
  late Isar _isar;

  @override
  Future<void> init() async {
    _isar = await Isar.open(
      [
        ProjectSchema,
        EnvironmentSchema,
        PackageSchema,
      ],
      directory: '.',
      name: 'jtech.db',
    );

    /// 测试代码
    // _testInsertPackageCompleteInfo(_isar);
    // _testUpdatePackageCompleteInfo(_isar);
  }

  // 添加/更新环境信息
  Future<Id> updateEnvironment(
    Environment env, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.environments.put(env),
        silent: silent,
      );

  // 移除环境信息
  Future<bool> deleteEnvironment(
    int id, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.environments.delete(id),
        silent: silent,
      );

  // 判断是否存在相同环境
  bool hasEnvironmentSync(String path) =>
      _isar.environments.filter().pathEqualTo(path).isNotEmptySync();

  // 加载环境信息
  Environment? loadEnvironment(int id) => _isar.environments.getSync(id);

  // 加载所有环境信息
  List<Environment> loadAllEnvironments() =>
      _isar.environments.where().findAllSync();

  // 监听环境信息变化并返回全部环境信息
  Stream<List<Environment>> watchEnvironmentList({
    bool fireImmediately = false,
  }) =>
      _isar.environments
          .watchLazy(fireImmediately: fireImmediately)
          .map((_) => loadAllEnvironments());

  // 添加/更新项目信息
  Future<Id> updateProject(
    Project project, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.projects.put(project),
        silent: silent,
      );

  // 添加/更新多个项目信息
  Future<List<Id>> updateProjects(
    List<Project> projects, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.projects.putAll(projects),
        silent: silent,
      );

  // 移除项目信息
  Future<bool> deleteProject(
    int id, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.projects.delete(id),
        silent: silent,
      );

  // 判断是否存在相同项目
  bool hasProjectSync(String path) =>
      _isar.projects.filter().pathEqualTo(path).isNotEmptySync();

  // 加载项目信息
  Project? loadProject(int id) => _isar.projects.getSync(id);

  // 加载所有项目信息
  List<Project> loadAllProjects() =>
      _isar.projects.where().sortByOrder().findAllSync();

  // 获取所有项目信息并读取本地文件信息
  Future<List<ProjectModel>> loadAllProjectInfos({
    bool simple = true,
  }) async {
    final list = <ProjectModel>[];
    for (var it in dbManage.loadAllProjects()) {
      final project = ProjectModel(project: it);
      await project.update(simple: simple);
      list.add(project);
    }
    return list;
  }

  // 监听项目信息变化并返回全部项目信息
  Stream<void> watchProjectList({
    bool fireImmediately = false,
  }) =>
      _isar.projects.watchLazy(fireImmediately: fireImmediately);

  // 添加打包任务(一个项目相同平台同时只能有一个打包任务，非完成状态)
  Future<Id?> addPackage(Package package, {bool silent = false}) =>
      _isar.writeTxn(
        () async {
          // 检查该项目是否已存在并且是非完成状态
          final hasTask = await _isar.packages
              .filter()
              .projectIdEqualTo(package.projectId)
              .and()
              .platformEqualTo(package.platform)
              .and()
              .not()
              .statusEqualTo(PackageStatus.completed)
              .isNotEmpty();
          if (hasTask) return null;
          return _isar.packages.put(package);
        },
        silent: silent,
      );

  // 移除多个打包任务/记录
  Future<int> deletePackages(
    List<Id> ids, {
    bool silent = false,
  }) =>
      _isar.writeTxn(
        () => _isar.packages.deleteAll(ids),
        silent: silent,
      );

  // 修改打包状态（已完成任务无法再改变）
  Future<bool> updatePackageStatus(
    List<Id> ids,
    PackageStatus status, {
    bool silent = false,
  }) async {
    if (ids.isEmpty) return true;
    try {
      final result = await _isar.writeTxn<List<Id>>(
        () async {
          // 判断id是否存在，并且状态为非完成
          final packages = await _isar.packages
              .filter()
              .allOf<int, dynamic>(ids, (q, e) => q.idEqualTo(e))
              .and()
              .not()
              .statusEqualTo(PackageStatus.completed)
              .findAll();
          if (packages.isEmpty) return [];
          for (var it in packages) {
            it.status = status;
          }
          return _isar.packages.putAll(packages);
        },
        silent: silent,
      );
      return result.every((e) => ids.contains(e));
    } catch (e) {
      LogTool.e('更新打包状态失败', error: e);
      return false;
    }
  }

  // 监听打包任务列表变化
  Stream<List<Package>> watchPackageTaskList({
    bool fireImmediately = false,
  }) =>
      _isar.packages
          .filter()
          .group((q) => q.not().statusEqualTo(PackageStatus.completed))
          .watchLazy(fireImmediately: fireImmediately)
          .map((_) => _isar.packages
              .filter()
              .group((q) => q.not().statusEqualTo(PackageStatus.completed))
              .sortByStatus()
              .findAllSync());

  // 监听打包历史记录的列表变化
  Stream<void> watchPackageRecordList({
    bool fireImmediately = false,
  }) =>
      _isar.packages
          .filter()
          .group((q) => q.statusEqualTo(PackageStatus.completed))
          .watchLazy(fireImmediately: fireImmediately);

  // 获取打包记录列表（非完成状态）
  List<Package> loadPackageTaskList() {
    return _isar.packages
        .filter()
        .not()
        .statusEqualTo(PackageStatus.completed)
        .findAllSync();
  }

  // 分页获取打包历史记录列表
  List<Package> loadPackageRecordList({
    int pageIndex = 1,
    int pageSize = 20,
    Sort sort = Sort.asc,
    DateTime? startTime,
    DateTime? endTime,
    Id? projectId,
  }) {
    final offset = pageIndex > 0 ? (pageIndex - 1) * pageSize : 0;
    var q = _isar.packages
        .filter()
        .statusEqualTo(PackageStatus.completed)
        .group((q) {
      startTime ??= DateTime(0);
      endTime ??= DateTime.now();
      if (projectId != null) {
        q = q.projectIdEqualTo(projectId).and();
      }
      return q.completeTimeBetween(startTime, endTime);
    });
    var tmp =
        sort == Sort.asc ? q.sortByCompleteTime() : q.sortByCompleteTimeDesc();
    return tmp.offset(offset).limit(pageSize).findAllSync();
  }

  // 获取总打包任务数据量
  int getPackageTaskCount() => _isar.packages
      .filter()
      .not()
      .statusEqualTo(PackageStatus.completed)
      .countSync();

  // 获取总打包记录数据量
  int getPackageRecordCount() => _isar.packages
      .filter()
      .statusEqualTo(PackageStatus.completed)
      .countSync();

  // 获取打包记录分页页数
  int getPackageRecordPageCount({
    int pageSize = 20,
  }) =>
      (getPackageRecordCount() / pageSize).ceil();
}

//单例调用
final dbManage = DBManage();

/// 测试代码--插入完成打包信息
void _testInsertPackageCompleteInfo(Isar db) {
  final objects = List.generate(99, (i) {
    return Package()
      ..projectId = 2
      ..envId = 1
      ..platform = PlatformType.android
      ..status = PackageStatus.completed
      ..packageSize = 1129301291
      ..timeSpent = 1000 * 60 * 3
      ..completeTime = DateTime.now().subtract(Duration(days: i % 15))
      ..outputPath = r'C:\Users\wuxubaiyang\Documents\xxxxx_test.zip';
  });
  db.writeTxn(() async {
    await db.packages.putAll(objects);
  });
}

/// 测试代码--修改打包信息项目id为已存在项目
void _testUpdatePackageCompleteInfo(Isar db) {
  final objects =
      db.packages.where().findAllSync().map((e) => e..projectId = 3).toList();
  db.writeTxn(() async {
    await db.packages.putAll(objects);
  });
}
