import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

/*
* linux平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:29 AM
*/
class LinuxPlatform extends BasePlatform {
  LinuxPlatform({
    required String platformPath,
  }) : super(type: PlatformType.linux, platformPath: platformPath);

  @override
  Future<bool> update(bool simple) async {
    var handle = FileHandle.from("");
    try {
      /// 实现代码
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    var handle = FileHandle.from("");
    try {
      /// 实现代码
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}
