import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/android_key.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:process_run/shell.dart';

/*
* 脚本处理
* @author wuxubaiyang
* @Time 5/21/2022 7:52 AM
*/
class ScriptHandle {
  // 查看flutter版本号信息
  static Future<Environment> loadFlutterEnv(
    String path, {
    Environment? oldEnv,
  }) async {
    final script = '$path/${ProjectFilePath.flutter} --version';
    final outText = await _runShell(script);
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
    return oldEnv ??= Environment()
      ..path = path
      ..flutter = version
      ..channel = channel
      ..dart = dart;
  }

  // 创建平台信息
  static Future<bool> createPlatforms(
    ProjectModel projectInfo,
    List<PlatformType> platforms,
  ) async {
    final env = projectInfo.environment;
    if (null == env) return false;
    final script = '${env.path}/${ProjectFilePath.flutter} create '
        '--platforms=${platforms.map((e) => e.name).join(',')} .';
    final outText = await _runShell(
      script,
      path: projectInfo.project.path,
    );
    return RegExp(r'All done').hasMatch(outText);
  }

  // 查看android签名文件信息
  static Future<String> loadAndroidKeyInfo(AndroidKeyParams params) {
    if (!params.checkCanGetInfo()) throw Exception('参数不完整');
    final script = 'keytool -v -list '
        '-storepass ${params.storePass} -keystore ${params.keystore}';
    return _runShell(script);
  }

  // 生成android签名文件
  static Future<bool> genAndroidKey(AndroidKeyParams params) async {
    try {
      if (!params.checkCanGenKey()) throw Exception('参数不完整');
      final script = 'keytool -genkey '
          '-alias ${params.alias} -keyalg ${params.keyAlg} '
          '-keysize ${params.keySize} -validity ${params.validity} '
          '-dname "${params.getDNameInfo()}" -storetype PKCS12 '
          '-keypass ${params.keyPass} -storepass ${params.storePass} '
          '-keystore ${params.keystore}';
      await _runShell(script);
      return File(params.keystore).exists();
    } catch (e) {
      LogTool.e('android签名生成失败', error: e);
      return false;
    }
  }

  // 脚本执行方法
  static Future<String> _runShell(
    String script, {
    String? path,
    Stream<List<int>>? stdin,
    StreamSink<List<int>>? stdout,
    StreamSink<List<int>>? stderr,
  }) async {
    final list = await Shell(
      throwOnError: false,
      workingDirectory: path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
      stdin: stdin,
      stdout: stdout,
      stderr: stderr,
    ).run(script);
    final errText = list.map((e) => e.errText).join('');
    if (errText.isNotEmpty) throw Exception(errText);
    return list.map((e) => e.outText).join('');
  }
}
