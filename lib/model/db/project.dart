import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:realm/realm.dart';

part 'project.g.dart';

// 检查本地文件是否变动回调
typedef CheckFileUpdate = bool Function(String filePath);

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

  // 项目名称（pubspec中不可为中文）
  late String name;

  // 项目别名
  late String alias;

  // 项目的本地存储路径
  late String path;

  // 项目环境key
  late String environmentKey;

  // 项目版本号
  late String version;

  // 项目数据源类型
  late int sourceType;

  // 项目git数据源配置对象
  late _GitSource? gitSource;

  // android平台信息
  late _AndroidPlatform? androidPlatform;

  // ios平台信息
  late _IOSPlatform? iosPlatform;

  // web平台信息
  late _WebPlatform? webPlatform;

  // linux平台信息
  late _LinuxPlatform? linuxPlatform;

  // macos平台信息
  late _MacosPlatform? macosPlatform;

  // windows平台信息
  late _WindowsPlatform? windowsPlatform;

  // 获取当前项目对应的环境对象
  Environment? getEnvironment() => dbManage.find<Environment>(environmentKey);

  // 设置数据源类型
  void setSourceType(SourceType type) => sourceType = type.index;

  // 获取数据源类型美剧
  SourceType getSourceType() => SourceType.values[sourceType];

  // 获取所有已存在平台名称集合
  List<String> loadExitPlatforms() {
    return [
      ...<dynamic>[
        androidPlatform?.name,
        iosPlatform?.name,
        webPlatform?.name,
        linuxPlatform?.name,
        macosPlatform?.name,
        windowsPlatform?.name
      ]..removeWhere((e) => null == e)
    ];
  }

  // 更新项目信息
  void updateInfo({
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* android平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _AndroidPlatform {
  // 平台名称
  late String name = "android";

  // 应用名
  late String label;

  // 包名
  late String package;

  // 图标对象
  late _AndroidIcons? icons;

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* android平台图标信息对象
* @author wuxubaiyang
* @Time 5/16/2022 6:40 PM
*/
@RealmModel()
class _AndroidIcons {
  // hdpi
  late String hdpiIcon;

  // mdpi
  late String mdpiIcon;

  // xhdpi
  late String xhdpiIcon;

  // xxhdpi
  late String xxhdpiIcon;

  // xxxhdpi
  late String xxxhdpiIcon;
}

/*
* ios平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _IOSPlatform {
  // 平台名称
  late String name = "ios";

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* web平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _WebPlatform {
  // 平台名称
  late String name = "web";

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* linux平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _LinuxPlatform {
  // 平台名称
  late String name = "linux";

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* macos平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _MacosPlatform {
  // 平台名称
  late String name = "macos";

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
}

/*
* windows平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
@RealmModel()
class _WindowsPlatform {
  // 平台名称
  late String name = "windows";

  // 更新信息
  void updateInfo(
    String rootPath, {
    required CheckFileUpdate checkFileUpdate,
  }) {}
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
