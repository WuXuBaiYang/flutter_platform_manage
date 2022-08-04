import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

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
    var handle = FileHandle.from("");
    try {
      ///代码实现
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    var handle = FileHandle.from("");
    try {
      /// 代码实现
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
