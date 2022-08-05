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
  double get showSize => const {
        IOSIcons.x1_20: 15.0,
        IOSIcons.x2_20: 25.0,
        IOSIcons.x3_20: 35.0,
        IOSIcons.x1_29: 25.0,
        IOSIcons.x2_29: 35.0,
        IOSIcons.x3_29: 45.0,
        IOSIcons.x1_40: 35.0,
        IOSIcons.x2_40: 45.0,
        IOSIcons.x3_40: 55.0,
        IOSIcons.x2_60: 45.0,
        IOSIcons.x3_60: 55.0,
        IOSIcons.x1_76: 55.0,
        IOSIcons.x2_76: 65.0,
        IOSIcons.x2_83_5: 65.0,
        IOSIcons.x1_1024: 75.0,
      }[this]!;

  // 获取真实图片尺寸
  double get sizePx => const {
        IOSIcons.x1_20: 20.0,
        IOSIcons.x2_20: 40.0,
        IOSIcons.x3_20: 60.0,
        IOSIcons.x1_29: 29.0,
        IOSIcons.x2_29: 58.0,
        IOSIcons.x3_29: 87.0,
        IOSIcons.x1_40: 40.0,
        IOSIcons.x2_40: 80.0,
        IOSIcons.x3_40: 120.0,
        IOSIcons.x2_60: 120.0,
        IOSIcons.x3_60: 180.0,
        IOSIcons.x1_76: 76.0,
        IOSIcons.x2_76: 152.0,
        IOSIcons.x2_83_5: 167.0,
        IOSIcons.x1_1024: 1024.0,
      }[this]!;

  // 倍数关系
  int get multiple => const {
        IOSIcons.x1_20: 1,
        IOSIcons.x1_29: 1,
        IOSIcons.x1_40: 1,
        IOSIcons.x1_76: 1,
        IOSIcons.x1_1024: 1,
        IOSIcons.x2_20: 2,
        IOSIcons.x2_29: 2,
        IOSIcons.x2_40: 2,
        IOSIcons.x2_60: 2,
        IOSIcons.x2_76: 2,
        IOSIcons.x2_83_5: 2,
        IOSIcons.x3_20: 3,
        IOSIcons.x3_29: 3,
        IOSIcons.x3_40: 3,
        IOSIcons.x3_60: 3,
      }[this]!;

  // 拼装附件相对路径
  String getAbsolutePath({String suffix = ".png"}) {
    var m = multiple, s = sizePx / m;
    var fileName = "Icon-App-${s}x$s@${m}x$suffix";
    return "${ProjectFilePath.iosAssetsAppIcon}/$fileName";
  }
}
