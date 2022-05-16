import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/db/setting.dart';
import 'package:jtech_pomelo/pomelo.dart';
import 'package:realm/realm.dart';

// 事件事务回调
typedef DBTransaction = void Function(Realm realm);

/*
* 数据库管理
* @author wuxubaiyang
* @Time 5/12/2022 16:39
*/
class DBManage extends BaseManage {
  static final DBManage _instance = DBManage._internal();

  factory DBManage() => _instance;

  DBManage._internal();

  // realm对象持有
  late Realm realm;

  @override
  Future<void> init() async {
    var config = Configuration([
      Project.schema,
      AndroidPlatform.schema,
      AndroidIcons.schema,
      IOSPlatform.schema,
      WebPlatform.schema,
      LinuxPlatform.schema,
      MacosPlatform.schema,
      WindowsPlatform.schema,
      GitSource.schema,
      Environment.schema,
      Setting.schema,
    ]);
    config.path = "jtech.db";
    config.schemaVersion = 0;
    realm = Realm(config);
  }

  // 以事务方式写入数据
  void write(DBTransaction transaction) =>
      realm.write(() => transaction(realm));

  // 删除数据
  void delete<T extends RealmObject>(T item) => realm.delete<T>(item);

  // 删除多条数据
  void deleteMany<T extends RealmObject>(Iterable<T> items) =>
      realm.deleteMany(items);

  // 查询数据
  T? find<T extends RealmObject>(Object primaryKey) =>
      realm.find<T>(primaryKey);

  // 获取所有数据
  RealmResults<T> all<T extends RealmObject>() => realm.all<T>();

  // 查询多条数据
  RealmResults<T> query<T extends RealmObject>(String query,
          [List<Object> args = const []]) =>
      all<T>().query(query);

  // 监听目标数据变化
  Stream<RealmResultsChanges<T>> changes<T extends RealmObject>({
    Map<String, List<Object>> queryMap = const {},
  }) {
    var results = realm.all<T>();
    //遍历查询表
    queryMap.forEach((key, value) {
      results.query(key, value);
    });
    return results.changes;
  }

  // 加载所有项目信息
  RealmResults<Project> loadAllProjects() => all<Project>();

  // 加载指定项目信息
  Project? loadProjectByKey(String primaryKey) => find<Project>(primaryKey);

  // 加载所有环境信息
  RealmResults<Environment> loadAllEnvironments() => all<Environment>();

  // 加载指定环境信息
  Environment? loadEnvironmentByKey(String primaryKey) =>
      find<Environment>(primaryKey);

  // 获取系统设置
  Setting loadSetting() {
    var results = all<Setting>();
    if (results.isEmpty) {
      write((realm) {
        realm.add(Setting(
          JUtil.genID(),
          "",
        ));
      });
      return loadSetting();
    }
    return results.first;
  }
}

//单例调用
final dbManage = DBManage();
