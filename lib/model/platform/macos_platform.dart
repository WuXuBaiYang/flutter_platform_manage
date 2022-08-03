import 'package:flutter_platform_manage/model/platform/base_platform.dart';

/*
* macos平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class MacOSPlatform extends BasePlatform {
  MacOSPlatform({
    required String platformPath,
  }) : super(type: PlatformType.macos, platformPath: platformPath);

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
