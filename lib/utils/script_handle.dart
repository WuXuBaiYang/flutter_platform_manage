import 'dart:async';
import 'dart:convert';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
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
  static Future<Environment?> loadFlutterEnv(String path) async {
    var list = await Shell(
      throwOnError: false,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    ).run("$path/${ProjectFilePath.flutter} --version");
    var errText = list.map((e) => e.errText).join("");
    if (errText.isNotEmpty) return null;
    var outText = list.map((e) => e.outText).join("");
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
}
