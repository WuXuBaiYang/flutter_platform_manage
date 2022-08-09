import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

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

  List<PermissionItemModel> permissions;

  IOSPlatform({
    required String platformPath,
    this.bundleName = "",
    this.bundleDisplayName = "",
    this.permissions = const [],
  }) : super(type: PlatformType.ios, platformPath: platformPath);

  // info.plist文件绝对路径
  String get infoPlistFilePath =>
      "$platformPath/${ProjectFilePath.iosInfoPlist}";

  @override
  Future<bool> update(bool simple) async {
    if (simple) return true;
    var handle = FileHandlePList.from(infoPlistFilePath);
    try {
      // 处理info.plist文件
      // 获取包名
      bundleName = await handle.getValue("CFBundleName", def: "");
      // 获取打包展示名称
      bundleDisplayName = await handle.getValue("CFBundleDisplayName", def: "");
      // 获取权限集合
      permissions = await permissionManage.findAllPermissions(
        await handle.getValueList<String>(includeKey: "NS"),
        platform: PlatformType.ios,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    var handle = FileHandle.from(infoPlistFilePath);
    try {
      // // 处理info.plist文件
      // // 修改打包名称
      // await handle.setMatchElNext("key",
      //     target: 'CFBundleName', value: bundleName);
      // // 修改显示名称
      // await modifyDisplayName(bundleDisplayName, handle: handle);
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  // 获取图标文件路径集合
  Map<IOSIcons, String> loadIcons() => Map.fromEntries(
        IOSIcons.values.map(
          (e) => MapEntry(e, "$platformPath/${e.absolutePath}"),
        ),
      );

  // 获取图标文件分组
  List<Map<IOSIcons, String>> loadGroupIcons() {
    return IOSIconsExtension.groups.map<Map<IOSIcons, String>>((e) {
      return Map.fromEntries(e.map(
        (i) => MapEntry(i, "$platformPath/${i.absolutePath}"),
      ));
    }).toList();
  }

  @override
  String get projectIcon => loadIcons().values.lastWhere(
        (e) => File(e).existsSync(),
        orElse: () => "",
      );

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandle.from(infoPlistFilePath);
    // await handle.setMatchElNext("key",
    //     target: 'CFBundleDisplayName', value: bundleDisplayName);
    return autoCommit ? await handle.commit() : true;
  }

  @override
  Future<List<String>> modifyProjectIcon(File file) async {
    return Utils.compressIcons(file, Map.fromEntries(IOSIcons.values.map((e) {
      var size = Size.square(e.sizePx.toDouble());
      return MapEntry(size, "$platformPath/${e.absolutePath}");
    })));
  }

  @override
  Future<void> projectPackaging(File output) async {
    ///待实现
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final IOSPlatform typedOther = other;
    return bundleName == typedOther.bundleName &&
        bundleDisplayName == typedOther.bundleDisplayName &&
        (permissions.length == typedOther.permissions.length &&
            !permissions.any((e) => !typedOther.permissions.contains(e)));
  }

  @override
  int get hashCode => Object.hash(
        bundleName,
        bundleDisplayName,
        Object.hashAll(permissions),
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
  num get showSize => const {
        IOSIcons.x1_20: 15,
        IOSIcons.x2_20: 25,
        IOSIcons.x3_20: 35,
        IOSIcons.x1_29: 25,
        IOSIcons.x2_29: 35,
        IOSIcons.x3_29: 45,
        IOSIcons.x1_40: 35,
        IOSIcons.x2_40: 45,
        IOSIcons.x3_40: 55,
        IOSIcons.x2_60: 45,
        IOSIcons.x3_60: 55,
        IOSIcons.x1_76: 55,
        IOSIcons.x2_76: 65,
        IOSIcons.x2_83_5: 65,
        IOSIcons.x1_1024: 95,
      }[this]!;

  // 获取真实图片尺寸
  num get sizePx => const {
        IOSIcons.x1_20: 20,
        IOSIcons.x2_20: 40,
        IOSIcons.x3_20: 60,
        IOSIcons.x1_29: 29,
        IOSIcons.x2_29: 58,
        IOSIcons.x3_29: 87,
        IOSIcons.x1_40: 40,
        IOSIcons.x2_40: 80,
        IOSIcons.x3_40: 120,
        IOSIcons.x2_60: 120,
        IOSIcons.x3_60: 180,
        IOSIcons.x1_76: 76,
        IOSIcons.x2_76: 152,
        IOSIcons.x2_83_5: 167,
        IOSIcons.x1_1024: 1024,
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

  // 将图标类型分组成二维数组
  static List<List<IOSIcons>> get groups => const [
        [IOSIcons.x1_20, IOSIcons.x2_20, IOSIcons.x3_20],
        [IOSIcons.x1_29, IOSIcons.x2_29, IOSIcons.x3_29],
        [IOSIcons.x1_40, IOSIcons.x2_40, IOSIcons.x3_40],
        [IOSIcons.x2_60, IOSIcons.x3_60],
        [IOSIcons.x1_76, IOSIcons.x2_76],
        [IOSIcons.x2_83_5],
        [IOSIcons.x1_1024]
      ];

  // 拼装附件相对路径
  String get absolutePath {
    var m = multiple, s = sizePx / m;
    var fileName = "Icon-App-${s}x$s@${m}x.png".replaceAll(".0", '');
    return "${ProjectFilePath.iosAssetsAppIcon}/$fileName";
  }
}
