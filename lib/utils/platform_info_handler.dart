import 'dart:io';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:jtech_pomelo/pomelo.dart';

/*
* 项目信息处理
* @author wuxubaiyang
* @Time 5/15/2022 8:42 PM
*/
class ProjectInfoHandle {
  // 项目版本号正则匹配
  static final regVersion = RegExp(r"version: (\d|\.)+\+\d+");

  // 加载项目版本号
  static Future<String> loadVersion(String rootPath) async {
    var file = File(joinAll([rootPath, ProjectFilePath.pubspec]));
    if (!file.existsSync()) throw Exception("pubspec.yaml文件不存在");
    var fileInfo = file.readAsStringSync();
    var version = regVersion.stringMatch(fileInfo);
    if (null == version) throw Exception("pubspec.yaml文件中缺少版本号信息");
    return version;
  }

  // 设置项目版本号
  static Future<void> setVersion(String rootPath, String? version) async {
    var file = File(joinAll([rootPath, ProjectFilePath.pubspec]));
    if (!file.existsSync()) throw Exception("pubspec.yaml文件不存在");
    var fileInfo = file.readAsStringSync();
    if (!regVersion.hasMatch(fileInfo)) {
      throw Exception("pubspec.yaml文件中缺少版本号信息");
    }
    fileInfo = fileInfo.replaceFirst(regVersion, "version: $version");
    return file.writeAsStringSync(fileInfo);
  }
}

/*
* android信息处理
* @author wuxubaiyang
* @Time 5/15/2022 8:39 PM
*/
class AndroidInfoHandle {}
