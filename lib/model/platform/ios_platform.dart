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
    if (simple) return true;
    var handle = FileHandle.from(infoPlistFilePath);
    try {
      // 处理info.plist文件
      bundleName = await handle.matchElNext("key", target: "CFBundleName");
      bundleDisplayName =
          await handle.matchElNext("key", target: "CFBundleDisplayName");
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
      await handle.setMatchElNext("key",
          target: 'CFBundleName', value: bundleName);
      await handle.setMatchElNext("key",
          target: 'CFBundleDisplayName', value: bundleDisplayName);
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  @override
  String? get projectIcon {}

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

/*
* ios图标尺寸枚举
* @author JTech JH
* @Time 2022-08-04 17:48:03
*/
enum IOSIcons {
  x1_20,
  x2_20,
  x3_20,
  x1_29,
  x2_29,
  x3_29,
  x1_40,
  x2_40,
  x3_40,
  x2_60,
  x3_60,
  x1_76,
  x2_76,
  x2_83_5,
  x1_1024,
}

/*
* ios图标尺寸枚举扩展
* @author JTech JH
* @Time 2022-08-04 17:48:17
*/
extension IOSIconsExtension on IOSIcons {
  // 图标展示尺寸
  double get showSize {
    switch (this) {
      case IOSIcons.x1_20:
        return 15;
      case IOSIcons.x2_20:
        return 25;
      case IOSIcons.x3_20:
        return 35;
      case IOSIcons.x1_29:
        return 25;
      case IOSIcons.x2_29:
        return 35;
      case IOSIcons.x3_29:
        return 45;
      case IOSIcons.x1_40:
        return 35;
      case IOSIcons.x2_40:
        return 45;
      case IOSIcons.x3_40:
        return 55;
      case IOSIcons.x2_60:
        return 45;
      case IOSIcons.x3_60:
        return 55;
      case IOSIcons.x1_76:
        return 55;
      case IOSIcons.x2_76:
        return 65;
      case IOSIcons.x2_83_5:
        return 65;
      case IOSIcons.x1_1024:
        return 75;
    }
  }

  // 获取真实图片尺寸
  double get sizePx {
    switch (this) {
      case IOSIcons.x1_20:
        return 20;
      case IOSIcons.x2_20:
        return 40;
      case IOSIcons.x3_20:
        return 60;
      case IOSIcons.x1_29:
        return 29;
      case IOSIcons.x2_29:
        return 58;
      case IOSIcons.x3_29:
        return 87;
      case IOSIcons.x1_40:
        return 40;
      case IOSIcons.x2_40:
        return 80;
      case IOSIcons.x3_40:
        return 120;
      case IOSIcons.x2_60:
        return 120;
      case IOSIcons.x3_60:
        return 180;
      case IOSIcons.x1_76:
        return 76;
      case IOSIcons.x2_76:
        return 152;
      case IOSIcons.x2_83_5:
        return 167;
      case IOSIcons.x1_1024:
        return 1024;
    }
  }

  // 倍数关系
  int get multiple {
    switch (this) {
      case IOSIcons.x1_20:
      case IOSIcons.x1_29:
      case IOSIcons.x1_40:
      case IOSIcons.x1_76:
      case IOSIcons.x1_1024:
        return 1;
      case IOSIcons.x2_20:
      case IOSIcons.x2_29:
      case IOSIcons.x2_40:
      case IOSIcons.x2_60:
      case IOSIcons.x2_76:
      case IOSIcons.x2_83_5:
        return 2;
      case IOSIcons.x3_20:
      case IOSIcons.x3_29:
      case IOSIcons.x3_40:
      case IOSIcons.x3_60:
        return 3;
    }
  }

  // 拼装附件相对路径
  String getAbsolutePath({String suffix = ".png"}) {
    var m = multiple, s = sizePx / m;
    var fileName = "Icon-App-${s}x$s@${m}x$suffix";
    return "${ProjectFilePath.iosAssetsAppIcon}/$fileName";
  }
}
