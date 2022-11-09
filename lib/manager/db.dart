import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
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
      ],
      directory: '.',
      name: 'jtech.db',
    );
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
  Stream<List<Environment>> watchAllEnvironmentByLazy({
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

  // 监听项目信息变化并返回全部项目信息
  Stream<List<Project>> watchAllProjectByLazy({
    bool fireImmediately = false,
  }) =>
      _isar.projects
          .watchLazy(fireImmediately: fireImmediately)
          .map((_) => loadAllProjects());
}

//单例调用
final dbManage = DBManage();
