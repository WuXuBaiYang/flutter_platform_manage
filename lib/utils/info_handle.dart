import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/project.dart';

/*
* 项目信息处理
* @author wuxubaiyang
* @Time 5/15/2022 8:42 PM
*/
class ProjectInfoHandle extends BaseInfoHandle {
  // 项目版本号正则匹配
  final regVersion = RegExp(r'version: .+\+.+');

  // 加载项目版本号
  Future<String> loadVersion(String rootPath) {
    return _loadOnPubspecInfo(rootPath, regVersion)
        .then((v) => v.replaceAll("version: ", ""));
  }

  // 设置项目版本号
  Future<void> setVersion(String rootPath, String value) {
    return _setOnPubspecInfo(rootPath, regVersion, value: "version: $value");
  }

  // 项目名称正则匹配
  final regName = RegExp(r'name: .+');

  // 加载项目名称
  Future<String> loadName(String rootPath) {
    return _loadOnPubspecInfo(rootPath, regName)
        .then((v) => v.replaceAll("name: ", ""));
  }

  // 设置项目名称(不可为中文)
  Future<void> setName(String rootPath, String value) {
    return _setOnPubspecInfo(rootPath, regName, value: "name: $value");
  }

  // 读取pubspec.yaml文件信息
  Future<String> _loadOnPubspecInfo(String rootPath, RegExp regExp) {
    var file = _getPubspecFileAsync(rootPath);
    return loadRegString(file, regExp);
  }

  // 写入pubspec.yaml文件信息
  Future<void> _setOnPubspecInfo(
    String rootPath,
    RegExp regExp, {
    required String value,
  }) {
    var file = _getPubspecFileAsync(rootPath);
    return setRegString(file, regExp, value: value);
  }

  // 读取pubspec.yaml文件
  File _getPubspecFileAsync(String rootPath) =>
      getFileAsync("$rootPath/${ProjectFilePath.pubspec}");
}

/*
* android信息处理
* @author wuxubaiyang
* @Time 5/15/2022 8:39 PM
*/
class AndroidInfoHandle extends BaseInfoHandle {
  // 图标正则匹配
  final regIconPath = RegExp(r'android:icon="@.+"');

  // 加载应用图标信息
  Future<List<String>> loadIconInfo(String rootPath) {
    return _loadOnAndroidManifestInfo(rootPath, regIconPath)
        .then((v) => v.replaceAll(RegExp(r'android:icon=|"|@'), ""))
        .then((v) => v.split("/"));
  }

  // 加载应用图标信息对象
  Future<AndroidIcons> loadIcons(String rootPath) async {
    var paths = await loadIconInfo(rootPath);
    if (paths.isEmpty || paths.length != 2) throw Exception("android图标路径有误");
    var holder = "%{dpi}";
    var filePath =
        "${ProjectFilePath.androidRes}/${paths.first}-$holder/${paths.last}.png";
    return AndroidIcons(
      filePath.replaceFirst(holder, "hdpi"),
      filePath.replaceFirst(holder, "mdpi"),
      filePath.replaceFirst(holder, "xhdpi"),
      filePath.replaceFirst(holder, "xxhdpi"),
      filePath.replaceFirst(holder, "xxxhdpi"),
    );
  }

  // 应用名正则匹配
  final regLabel = RegExp(r'android:label=".+"');

  // 加载应用名
  Future<String> loadLabel(String rootPath) {
    return _loadOnAndroidManifestInfo(rootPath, regLabel)
        .then((v) => v.replaceAll(RegExp(r'android:label=|"'), ""));
  }

  // 设置应用名
  Future<void> setLabel(String rootPath, String value) async {
    return await _setOnAndroidManifestInfo(rootPath, regLabel,
        value: 'android:label="$value"');
  }

  // 包名正则匹配
  final regPackage = RegExp(r'(package=|applicationId )".+"');

  // 加载包名
  Future<String> loadPackage(String rootPath) {
    return _loadOnAppBuildGradleInfo(rootPath, regPackage)
        .then((v) => v.replaceAll(RegExp(r'applicationId |"'), ""));
  }

  // 设置包名
  Future<void> setPackage(String rootPath, String value) async {
    await _setOnAndroidManifestInfo(rootPath, regPackage,
        value: 'package="$value"');
    return await _setOnAppBuildGradleInfo(rootPath, regPackage,
        value: 'applicationId "$value"');
  }

  // 读取app/build.gradle文件信息
  Future<String> _loadOnAppBuildGradleInfo(String rootPath, RegExp regExp) {
    var file = _getAppBuildGradleFileAsync(rootPath);
    return loadRegString(file, regExp);
  }

  // 写入app/build.gradle文件信息
  Future<void> _setOnAppBuildGradleInfo(
    String rootPath,
    RegExp regExp, {
    required String value,
  }) {
    var file = _getAppBuildGradleFileAsync(rootPath);
    return setRegString(file, regExp, value: value);
  }

  // 读取androidManifest.xml文件信息
  Future<String> _loadOnAndroidManifestInfo(String rootPath, RegExp regExp) {
    var file = _getManifestFileAsync(rootPath);
    return loadRegString(file, regExp);
  }

  // 写入androidManifest.xml文件信息
  Future<void> _setOnAndroidManifestInfo(
    String rootPath,
    RegExp regExp, {
    required String value,
  }) {
    var file = _getManifestFileAsync(rootPath);
    return setRegString(file, regExp, value: value);
  }

  // 读取android/app/build.gradle文件
  File _getAppBuildGradleFileAsync(String rootPath) =>
      getFileAsync("$rootPath/${ProjectFilePath.androidAppBuildGradle}");

  // 读取android/app/src/main/AndroidManifest.xml文件
  File _getManifestFileAsync(String rootPath) =>
      getFileAsync("$rootPath/${ProjectFilePath.androidManifest}");
}

/*
* 处理器基类
* @author wuxubaiyang
* @Time 5/16/2022 11:12 AM
*/
abstract class BaseInfoHandle {
  // 读取文件
  File getFileAsync(String filePath) {
    var file = File(filePath);
    if (!file.existsSync()) throw Exception("文件不存在");
    return file;
  }

  // 加载匹配信息
  Future<String> loadRegString(File file, RegExp regExp) async {
    var fileInfo = file.readAsStringSync();
    var result = regExp.stringMatch(fileInfo);
    if (null == result) throw Exception("字段匹配失败");
    return result;
  }

  // 写入匹配信息
  Future<void> setRegString(
    File file,
    RegExp regExp, {
    required String value,
  }) async {
    var fileInfo = file.readAsStringSync();
    if (!regExp.hasMatch(fileInfo)) throw Exception("字段匹配失败");
    fileInfo = fileInfo.replaceFirst(regExp, value);
    return file.writeAsStringSync(fileInfo);
  }
}
