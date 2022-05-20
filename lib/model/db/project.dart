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
  late String? alias;

  // 项目的本地存储路径
  late String path;

  // 项目环境key
  late String environmentKey;

  // 项目数据源类型
  late int sourceType;

  // 项目git数据源配置对象
  late _GitSource? gitSource;

  // 获取当前项目对应的环境对象
  Environment? getEnvironment() => dbManage.find<Environment>(environmentKey);

  // 设置数据源类型
  void setSourceType(SourceType type) => sourceType = type.index;

  // 获取数据源类型美剧
  SourceType getSourceType() => SourceType.values[sourceType];
}

/*
* git数据源对象
* @author wuxubaiyang
* @Time 5/14/2022 9:10 PM
*/
@RealmModel()
class _GitSource {
  // git地址
  late String url;

  // 授权类型
  late int authType = 0;

  // 是否在每次执行操作前都自动拉取最新代码
  late bool autoPull = true;

  // https授权-用户名
  late String authHTTPSUsername = "";

  // https授权-密码
  late String authHTTPSPassword = "";

  // 设置授权类型
  void setAuthType(GitAuthType type) => authType = type.index;

  // 获取授权类型
  GitAuthType getAuthType() => GitAuthType.values[authType];
}

/*
* 项目数据源类型枚举
* @author wuxubaiyang
* @Time 5/14/2022 9:03 PM
*/
enum SourceType { local, git }

/*
* git数据源授权类型枚举
* @author wuxubaiyang
* @Time 5/14/2022 9:13 PM
*/
enum GitAuthType { none, https, ssh }
