import 'dart:io';

import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

/*
* windows平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WindowsPlatform extends BasePlatform {
  WindowsPlatform({
    required String platformPath,
  }) : super(type: PlatformType.windows, platformPath: platformPath);

  @override
  Future<bool> update(bool simple) async {
    final handle = FileHandle.from("");
    try {
      ///待实现
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    final handle = FileHandle.from("");
    try {
      ///待实现
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  @override
  String get projectIcon {
    ///待实现
    return "";
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    ///待实现
    return true;
  }

  @override
  Future<List<String>> modifyProjectIcon(File file) async {
    ///待实现
    return [];
  }

  @override
  Future<void> projectPackaging(File output) async {
    ///待实现
  }
}
