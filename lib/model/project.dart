import 'dart:io';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/utils/info_handle.dart';

import 'db/environment.dart';

/*
*
* @author wuxubaiyang
* @Time 5/20/2022 10:37 AM
*/
class ProjectModel {
  // 项目基本信息
  final Project project;

  // 项目本地存储路径项目是否存在(项目根目录下是否有pubspec.yaml)
  bool exist;

  // 项目名称（pubspec中不可为中文）
  String name;

  // 项目版本号
  String version;

  // 平台集合
  List<BasePlatform> platformList;

  // 平台表
  Map<PlatformType, BasePlatform> platformMap;

  ProjectModel({
    required this.project,
    this.exist = true,
    this.name = "",
    this.version = "",
    this.platformMap = const {},
  }) : platformList = platformMap.values.toList();

  // 获取展示标题
  String getShowTitle() {
    var t = project.alias;
    return t.isEmpty ? name : "$t($name)";
  }

  // 缓存环境信息
  Environment? _environment;

  // 获取当前项目对应的环境对象
  Environment? getEnvironment() =>
      _environment ??= dbManage.find<Environment>(project.environmentKey);

  // 项目名称正则
  final _nameReg = RegExp(r'name: .+');
  final _nameRegRe = RegExp(r'name: ');

  // 项目版本号正则
  final _versionReg = RegExp(r'version: .+\+.+');
  final _versionRegRe = RegExp(r'version: ');

  // 获取应用图标
  Map<PlatformType, String> getProjectIcon() {
    for (var it in platformList) {
      var path = it.getProjectIcon();
      if (null != path) {
        return {it.type: path};
      }
    }
    return {};
  }

  // 更新简略项目信息
  Future<bool> updateSimple() async {
    try {
      exist = InfoHandle.projectExistSync(project.path);
      // 处理pubspec.yaml文件
      await InfoHandle.fileRead(
        "${project.path}/${ProjectFilePath.pubspec}",
        (source) {
          name = InfoHandle.stringMatch(source, _nameReg, _nameRegRe);
          version = InfoHandle.stringMatch(source, _versionReg, _versionRegRe);
        },
      );
      // 处理平台信息
      platformMap = {};
      for (var t in PlatformType.values) {
        var d = Directory("${project.path}/${t.name}");
        if (!d.existsSync()) continue;
        platformMap[t] = t.create(d.path);
      }
      platformList = platformMap.values.toList();
      _environment = null;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 更新项目信息
  Future<bool> update() async {
    try {
      exist = InfoHandle.projectExistSync(project.path);
      // 处理pubspec.yaml文件
      await InfoHandle.fileRead(
        "${project.path}/${ProjectFilePath.pubspec}",
        (source) {
          name = InfoHandle.stringMatch(source, _nameReg, _nameRegRe);
          version = InfoHandle.stringMatch(source, _versionReg, _versionRegRe);
        },
      );
      // 处理平台信息
      platformMap = {};
      for (var t in PlatformType.values) {
        var d = Directory("${project.path}/${t.name}");
        if (!d.existsSync()) continue;
        var p = t.create(d.path);
        if (!await p.update()) return false;
        platformMap[t] = p;
      }
      platformList = platformMap.values.toList();
      _environment = null;
    } catch (e) {
      return false;
    }
    return true;
  }

  // pubspec文件绝对路径
  String get _pubspecFilePath => "${project.path}/${ProjectFilePath.pubspec}";

  // 执行项目信息变动
  Future<bool> commit() async {
    try {
      // 处理pubspec.yaml文件
      InfoHandle.fileWrite(
        _pubspecFilePath,
        (source) {
          source = InfoHandle.sourceReplace(source, _nameReg, "name: $name");
          source = InfoHandle.sourceReplace(
              source, _versionReg, "version: $version");
          return source;
        },
      );
      // 处理平台信息
      for (var p in platformList) {
        if (!await p.commit()) return false;
      }
      _environment = null;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 修改pubspec中的项目名称
  Future<bool> modifyProjectName(String name) {
    return InfoHandle.fileWrite(
      _pubspecFilePath,
      (source) =>
          source = InfoHandle.sourceReplace(source, _nameReg, "name: $name"),
    );
  }

  // 修改pubspec中的应用版本号
  Future<bool> modifyProjectVersion(String version) {
    return InfoHandle.fileWrite(
      _pubspecFilePath,
      (source) => source =
          InfoHandle.sourceReplace(source, _versionReg, "version: $version"),
    );
  }
}

/*
* android平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
class AndroidPlatform extends BasePlatform {
  // 应用名
  String label;

  // 包名
  String package;

  // 图标对象
  String iconPath;

  AndroidPlatform({
    required String platformPath,
    this.label = "",
    this.package = "",
    this.iconPath = "",
  }) : super(type: PlatformType.android, platformPath: platformPath);

  // 获取图标文件路径集合
  Map<String, String> loadIcons({String suffix = ".png"}) {
    if (iconPath.isEmpty) return {};
    var path = "$platformPath/${ProjectFilePath.androidRes}";
    var dir = iconPath.split("/").first;
    var name = iconPath.split("/").last + suffix;
    return {
      "mdpi": "$path/$dir-mdpi/$name",
      "hdpi": "$path/$dir-hdpi/$name",
      "xhdpi": "$path/$dir-xhdpi/$name",
      "xxhdpi": "$path/$dir-xxhdpi/$name",
      "xxxhdpi": "$path/$dir-xxxhdpi/$name",
    };
  }

  // 应用名正则
  final _labelReg = RegExp(r'android:label=".+"');
  final _labelRegRe = RegExp(r'android:label=|"');

  // 包名正则
  final _packageReg = RegExp(r'(package=|applicationId )".+"');
  final _packageRegRe = RegExp(r'package=|applicationId |"');

  // 图标路径正则
  final _iconPathReg = RegExp(r'android:icon="@.+"');
  final _iconPathRegRe = RegExp(r'android:icon=|"|@');

  @override
  Future<bool> update() async {
    try {
      // 处理androidManifest.xml文件
      await InfoHandle.fileRead(
        "$platformPath/${ProjectFilePath.androidManifest}",
        (source) {
          label = InfoHandle.stringMatch(source, _labelReg, _labelRegRe);
          package = InfoHandle.stringMatch(source, _packageReg, _packageRegRe);
          iconPath =
              InfoHandle.stringMatch(source, _iconPathReg, _iconPathRegRe);
        },
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理androidManifest.xml文件
      if (!await InfoHandle.fileWrite(
        "$platformPath/${ProjectFilePath.androidManifest}",
        (source) {
          source = InfoHandle.sourceReplace(
              source, _labelReg, 'android:label="$label"');
          source = InfoHandle.sourceReplace(
              source, _packageReg, 'package="$package"');
          return source;
        },
      )) return false;
      // 处理app/build.gradle文件
      if (!await InfoHandle.fileWrite(
        "$platformPath/${ProjectFilePath.androidAppBuildGradle}",
        (source) {
          source = InfoHandle.sourceReplace(
              source, _packageReg, 'applicationId "$package"');
          return source;
        },
      )) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  String? getProjectIcon() {
    try {
      return loadIcons()
          .values
          .toList()
          .reversed
          .firstWhere((e) => File(e).existsSync());
    } catch (e) {
      // 未找到
    }
    return null;
  }
}

/*
* ios平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:27 AM
*/
class IOSPlatform extends BasePlatform {
  IOSPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}

/*
* web平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WebPlatform extends BasePlatform {
  WebPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}

/*
* windows平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WindowsPlatform extends BasePlatform {
  WindowsPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}

/*
* macos平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class MacOSPlatform extends BasePlatform {
  MacOSPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}

/*
* linux平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:29 AM
*/
class LinuxPlatform extends BasePlatform {
  LinuxPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update() async {
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}

/*
* 平台基类
* @author wuxubaiyang
* @Time 5/20/2022 11:14 AM
*/
abstract class BasePlatform {
  // 平台类型
  final PlatformType type;

  // 平台根路径
  final String platformPath;

  BasePlatform({
    required this.type,
    required this.platformPath,
  });

  // 更新信息
  Future<bool> update();

  // 提交信息变动
  Future<bool> commit();

  // 获取应用图标
  String? getProjectIcon();
}

/*
* 平台类型枚举
* @author wuxubaiyang
* @Time 5/20/2022 11:14 AM
*/
enum PlatformType {
  android,
  ios,
  windows,
  macos,
  linux,
  web,
}

/*
* 平台类型枚举扩展
* @author wuxubaiyang
* @Time 5/20/2022 11:23 AM
*/
extension PlatformTypeExtension on PlatformType {
  // 创建平台信息对象
  BasePlatform create(String platformPath) {
    switch (this) {
      case PlatformType.android:
        return AndroidPlatform(platformPath: platformPath);
      case PlatformType.ios:
        return IOSPlatform(platformPath: platformPath);
      case PlatformType.web:
        return WebPlatform(platformPath: platformPath);
      case PlatformType.windows:
        return WindowsPlatform(platformPath: platformPath);
      case PlatformType.macos:
        return MacOSPlatform(platformPath: platformPath);
      case PlatformType.linux:
        return LinuxPlatform(platformPath: platformPath);
    }
  }

  // 获取平台图标
  String get platformImage {
    switch (this) {
      case PlatformType.android:
        return Common.platformAndroid;
      case PlatformType.ios:
        return Common.platformIOS;
      case PlatformType.web:
        return Common.platformWeb;
      case PlatformType.windows:
        return Common.platformWindows;
      case PlatformType.macos:
        return Common.platformMacos;
      case PlatformType.linux:
        return Common.platformLinux;
    }
  }
}
