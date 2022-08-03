import 'package:flutter_platform_manage/model/platform/base_platform.dart';

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
    return true;
  }

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  String? getProjectIcon() {
    return null;
  }
}
