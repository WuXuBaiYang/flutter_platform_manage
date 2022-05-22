import 'dart:io';

import 'package:flutter_platform_manage/common/file_path.dart';

/*
* 项目信息处理
* @author wuxubaiyang
* @Time 5/20/2022 11:15 AM
*/
class InfoHandle {
  // 判断项目是否存在
  static bool projectExistSync(String path) =>
      File("$path/${ProjectFilePath.pubspec}").existsSync();

  // 文件读取方法
  static Future<void> fileRead(
    String path,
    void Function(String source) onFileRead,
  ) async {
    var f = File(path);
    if (!f.existsSync()) return;
    var source = f.readAsStringSync();
    return onFileRead(source);
  }

  // 文件读取方法
  static Future<bool> fileWrite(String path,
      String Function(String source) onFileWrite,) async {
    var f = File(path);
    if (!f.existsSync()) return false;
    var source = f.readAsStringSync();
    source = onFileWrite(source);
    f.writeAsStringSync(source);
    return true;
  }

  // 字符串参数匹配
  static String stringMatch(String source, RegExp reg, RegExp replace) {
    var value = reg.stringMatch(source);
    return value?.replaceAll(replace, "") ?? "";
  }

  // 源文件替换
  static String sourceReplace(String source, RegExp reg, String value) {
    if (reg.hasMatch(source)) {
      source = source.replaceAll(reg, value);
    }
    return source;
  }
}
