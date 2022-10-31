import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/db/setting.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:realm/realm.dart';

import '../common/manage.dart';

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
    final config = Configuration.local(
      [
        Project.schema,
        Environment.schema,
        Setting.schema,
      ],
      schemaVersion: 0,
      path: 'jtech.db',
    );
    realm = Realm(config);
  }

  // 以事务方式写入数据
  void write(DBTransaction transaction) =>
      realm.write(() => transaction(realm));

  // 删除数据
  void delete<T extends RealmObject>(T item) => write((realm) {
        realm.delete<T>(item);
      });

  // 删除多条数据
  void deleteMany<T extends RealmObject>(Iterable<T> items) => write((realm) {
        realm.deleteMany(items);
      });

  // 查询数据
  T? find<T extends RealmObject>(Object primaryKey) =>
      realm.find<T>(primaryKey);

  // 获取所有数据
  RealmResults<T> all<T extends RealmObject>() => realm.all<T>();

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

  // 写入环境信息
  void addEnvironment(Environment env) {
    return write((realm) {
      realm.add<Environment>(env);
    });
  }

  // 加载第一条环境信息
  Environment? loadFirstEnvironment({String? environmentKey}) {
    var result = loadAllEnvironments();
    if (result.isEmpty) return null;
    for (var it in result) {
      if (it.primaryKey == environmentKey) {
        return it;
      }
    }
    return result.first;
  }

  // 加载所有环境信息
  RealmResults<Environment> loadAllEnvironments() => all<Environment>();

  // 加载指定环境信息
  Environment? loadEnvironmentByKey(String primaryKey) =>
      find<Environment>(primaryKey);

  // 判断是否存在相同环境
  bool hasEnvironment(String path) =>
      all<Environment>().query(r'path == $0', [path]).isNotEmpty;

  // 获取系统设置
  Future<Setting> loadSetting() async {
    var results = all<Setting>();
    if (results.isEmpty) {
      write((realm) {
        realm.add(Setting(Utils.genID()));
      });
      return loadSetting();
    }
    return results.first;
  }
}

//单例调用
final dbManage = DBManage();
