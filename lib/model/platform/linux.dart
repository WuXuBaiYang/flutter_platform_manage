import 'dart:io';

import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';

/*
* linux平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:29 AM
*/
class LinuxPlatform extends BasePlatform {
  LinuxPlatform({
    required super.platformPath,
  }) : super(type: PlatformType.linux);

  @override
  Future<bool> update({bool simple=false}) async {
    final handle = FileHandle.from('');
    try {
      if (simple) return true;
      ///待实现
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    final handle = FileHandle.from('');
    try {
      ///待实现
    } catch (e) {
      LogTool.e('linux平台信息提交失败：', error: e);
      return false;
    }
    return true;
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    ///待实现
    return true;
  }

  @override
  Future<bool> projectPackaging(File output) async {
    ///待实现
    return true;
  }
}
