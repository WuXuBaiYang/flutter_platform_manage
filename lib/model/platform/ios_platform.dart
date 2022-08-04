import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

/*
* ios平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:27 AM
*/
class IOSPlatform extends BasePlatform {
  // 应用名
  String bundleName;

  // 展示应用名
  String bundleDisplayName;

  IOSPlatform({
    required String platformPath,
    this.bundleName = "",
    this.bundleDisplayName = "",
  }) : super(type: PlatformType.ios, platformPath: platformPath);

  // info.plist文件绝对路径
  String get infoPlistFilePath =>
      "$platformPath/${ProjectFilePath.iosInfoPlist}";

  @override
  Future<bool> update(bool simple) async {
    var handle = FileHandle.from(infoPlistFilePath);
    try {
      // 处理info.plist文件
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    var handle = FileHandle.from(infoPlistFilePath);
    try {
      // 处理info.plist文件
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  @override
  String? getProjectIcon() {
    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final IOSPlatform typedOther = other;
    return bundleName == typedOther.bundleName &&
        bundleDisplayName == typedOther.bundleDisplayName;
  }

  @override
  int get hashCode => Object.hash(
        bundleName,
        bundleDisplayName,
      );
}
