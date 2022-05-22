import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:realm/realm.dart';

part 'project.g.dart';

/*
* 项目对象
* @author wuxubaiyang
* @Time 5/12/2022 14:58
*/
@RealmModel()
class _Project {
  // 主键key
  @PrimaryKey()
  late String primaryKey;

  // 项目别名
  late String alias;

  // 项目的本地存储路径
  late String path;

  // 项目环境key
  late String environmentKey;
}
