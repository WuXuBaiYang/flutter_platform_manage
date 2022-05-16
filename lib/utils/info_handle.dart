import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:jtech_pomelo/pomelo.dart';

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
    return _loadOnPubspecInfo(rootPath, regVersion, regName: "版本号信息");
  }

  // 设置项目版本号
  Future<void> setVersion(String rootPath, String value) {
    return _setOnPubspecInfo(rootPath, regVersion,
        regName: "版本号信息", value: "version: $value");
  }

  // 项目名称正则匹配
  final regName = RegExp(r'name: .+');

  // 加载项目名称
  Future<String> loadName(String rootPath) {
    return _loadOnPubspecInfo(rootPath, regName, regName: "项目名称");
  }

  // 设置项目名称(不可为中文)
  Future<void> setName(String rootPath, String value) {
    return _setOnPubspecInfo(rootPath, regName,
        regName: "项目名称", value: "name: $value");
  }

  // 读取pubspec.yaml文件信息
  Future<String> _loadOnPubspecInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
  }) {
    var file = _getPubspecFileAsync(rootPath);
    return loadRegString(file, regExp, regName: regName);
  }

  // 写入pubspec.yaml文件信息
  Future<void> _setOnPubspecInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
    required String value,
  }) {
    var file = _getPubspecFileAsync(rootPath);
    return setRegString(file, regExp, regName: regName, value: value);
  }

  // 读取pubspec.yaml文件
  File _getPubspecFileAsync(String rootPath) =>
      getFileAsync(joinAll([rootPath, ProjectFilePath.pubspec]));
}

/*
* android信息处理
* @author wuxubaiyang
* @Time 5/15/2022 8:39 PM
*/
class AndroidInfoHandle extends BaseInfoHandle {
  // 应用名正则匹配
  final regLabel = RegExp(r'android:label=".+"');

  // 加载应用名
  Future<String> loadLabel(String rootPath) {
    return _loadOnAndroidManifestInfo(rootPath, regLabel, regName: "应用名");
  }

  // 设置应用名
  Future<void> setLabel(String rootPath, String value) async {
    return await _setOnAndroidManifestInfo(rootPath, regLabel,
        regName: "应用名", value: 'android:label="$value"');
  }

  // 包名正则匹配
  final regPackage = RegExp(r'(package=|applicationId )".+"');

  // 加载包名
  Future<String> loadPackage(String rootPath) {
    return _loadOnAndroidManifestInfo(rootPath, regPackage, regName: "包名");
  }

  // 设置包名
  Future<void> setPackage(String rootPath, String value) async {
    var regName = "包名";
    await _setOnAppBuildGradleInfo(rootPath, regPackage,
        regName: regName, value: 'applicationId "$value"');
    return await _setOnAndroidManifestInfo(rootPath, regPackage,
        regName: regName, value: 'package="$value"');
  }

  // 读取app/build.gradle文件信息
  Future<String> _loadOnAppBuildGradleInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
  }) {
    var file = _getAppBuildGradleFileAsync(rootPath);
    return loadRegString(file, regExp, regName: regName);
  }

  // 写入app/build.gradle文件信息
  Future<void> _setOnAppBuildGradleInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
    required String value,
  }) {
    var file = _getAppBuildGradleFileAsync(rootPath);
    return setRegString(file, regExp, regName: regName, value: value);
  }

  // 读取androidManifest.xml文件信息
  Future<String> _loadOnAndroidManifestInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
  }) {
    var file = _getManifestFileAsync(rootPath);
    return loadRegString(file, regExp, regName: regName);
  }

  // 写入androidManifest.xml文件信息
  Future<void> _setOnAndroidManifestInfo(
    String rootPath,
    RegExp regExp, {
    required String regName,
    required String value,
  }) {
    var file = _getManifestFileAsync(rootPath);
    return setRegString(file, regExp, regName: regName, value: value);
  }

  // 读取android/app/build.gradle文件
  File _getAppBuildGradleFileAsync(String rootPath) =>
      getFileAsync(joinAll([rootPath, ProjectFilePath.androidAppBuildGradle]));

  // 读取android/app/src/main/AndroidManifest.xml文件
  File _getManifestFileAsync(String rootPath) =>
      getFileAsync(joinAll([rootPath, ProjectFilePath.androidManifest]));
}

/*
* 处理器基类
* @author wuxubaiyang
* @Time 5/16/2022 11:12 AM
*/
abstract class BaseInfoHandle {
  // 读取文件
  File getFileAsync(String filePath, {String? fileName}) {
    var file = File(filePath);
    fileName ??= file.name;
    if (!file.existsSync()) throw Exception("$fileName 文件不存在");
    return file;
  }

  // 加载匹配信息
  Future<String> loadRegString(
    File file,
    RegExp regExp, {
    String? fileName,
    required String regName,
  }) async {
    fileName ??= file.name;
    var fileInfo = file.readAsStringSync();
    var result = regExp.stringMatch(fileInfo);
    if (null == result) throw Exception("$fileName 文件中缺少 $regName 信息");
    return result;
  }

  // 写入匹配信息
  Future<void> setRegString(
    File file,
    RegExp regExp, {
    String? fileName,
    required String regName,
    required String value,
  }) async {
    fileName ??= file.name;
    var fileInfo = file.readAsStringSync();
    if (!regExp.hasMatch(fileInfo)) {
      throw Exception("$fileName 文件中缺少 $regName 信息");
    }
    fileInfo = fileInfo.replaceFirst(regExp, value);
    return file.writeAsStringSync(fileInfo);
  }
}
