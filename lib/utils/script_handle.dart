import 'dart:async';
import 'dart:convert';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
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
    final outText = await runShell(
      '$path/${ProjectFilePath.flutter} --version',
    );
    var version = 'Flutter', channel = 'channel', dart = 'Dart';
    for (var it in outText.split(r'•')) {
      it = it.trim();
      if (it.startsWith(version)) {
        version = it.replaceAll(version, '').trim();
      } else if (it.startsWith(channel)) {
        channel = it.replaceAll(channel, '').trim();
      } else if (it.startsWith(dart)) {
        dart = it.replaceAll(dart, '').trim();
      }
    }
    return Environment(Utils.genID(), path, version, channel, dart);
  }

  // 创建平台信息
  static Future<bool> createPlatforms(
      ProjectModel projectInfo, List<PlatformType> platforms) async {
    final env = projectInfo.environment;
    if (null == env) return false;
    final outText = await runShell(
      '${env.path}/${ProjectFilePath.flutter} create --platforms=${platforms.map((e) => e.name).join(',')} .',
      path: projectInfo.project.path,
    );
    return RegExp(r'All done').hasMatch(outText);
  }

  // 脚本执行方法
  static Future<String> runShell(String script, {String? path}) async {
    final list = await Shell(
      throwOnError: false,
      workingDirectory: path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    ).run(script);
    final errText = list.map((e) => e.errText).join('');
    if (errText.isNotEmpty) throw Exception(errText);
    return list.map((e) => e.outText).join('');
  }
}
