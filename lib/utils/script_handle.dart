import 'dart:async';
import 'dart:convert';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/info_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:process_run/shell.dart';

/*
* 脚本处理
* @author wuxubaiyang
* @Time 5/21/2022 7:52 AM
*/
class ScriptHandle {
  // 查看flutter版本号信息
  static Future<Environment> loadFlutterEnv(String path) async {
    var outText = await runShell(
      "$path/${ProjectFilePath.flutter} --version",
    );
    var version = InfoHandle.stringMatch(
      outText,
      RegExp(r'Flutter .+? •'),
      RegExp(r'Flutter | •'),
    );
    var channel = InfoHandle.stringMatch(
      outText,
      RegExp(r'channel .+? •'),
      RegExp(r'channel | •'),
    );
    var dart = InfoHandle.stringMatch(
      outText,
      RegExp(r'Dart (.+? •|.+)'),
      RegExp(r'Dart | •'),
    );
    return Environment(Utils.genID(), path, version, channel, dart);
  }

  // 创建平台信息
  static Future<bool> createPlatforms(
      ProjectModel projectInfo, List<PlatformType> platforms) async {
    var env = projectInfo.getEnvironment();
    if (null == env) return false;
    var outText = await runShell(
      "${env.path}/${ProjectFilePath.flutter} create --platforms=${platforms.map((e) => e.name).join(',')} .",
      path: projectInfo.project.path,
    );
    return RegExp(r'All done').hasMatch(outText);
  }

  // 脚本执行方法
  static Future<String> runShell(String script, {String? path}) async {
    var list = await Shell(
      throwOnError: false,
      workingDirectory: path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    ).run(script);
    var errText = list.map((e) => e.errText).join("");
    if (errText.isNotEmpty) throw Exception(errText);
    return list.map((e) => e.outText).join("");
  }
}
