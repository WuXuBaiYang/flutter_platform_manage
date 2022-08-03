import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

/*
* android平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
class AndroidPlatform extends BasePlatform {
  // 应用名
  String label;

  // 包名
  String package;

  // 图标对象
  String iconPath;

  // 权限集合
  List<PermissionItemModel> permissions;

  AndroidPlatform({
    required String platformPath,
    this.label = "",
    this.package = "",
    this.iconPath = "",
    this.permissions = const [],
  }) : super(type: PlatformType.android, platformPath: platformPath);

  // 获取图标文件路径集合
  Map<AndroidIconSize, String> loadIcons({String suffix = ".png"}) {
    if (iconPath.isEmpty) return {};
    return Map.fromEntries(AndroidIconSize.values.map((e) {
      var path = e.getAbsolutePath(iconPath, suffix: suffix);
      return MapEntry(e, "$platformPath/$path");
    }));
  }

  // androidManifest.xml文件绝对路径
  String get androidManifestFilePath =>
      "$platformPath/${ProjectFilePath.androidManifest}";

  @override
  Future<bool> update(bool simple) async {
    var handle = FileHandle.from(androidManifestFilePath);
    try {
      // 处理androidManifest.xml文件
      iconPath = (await handle.xmlSingleTagAttribute("application",
              attName: "android:icon"))
          .replaceAll(r'@', '');
      if (!simple) {
        label = await handle.xmlSingleTagAttribute("application",
            attName: "android:label");
        package =
            await handle.xmlSingleTagAttribute("manifest", attName: "package");
        permissions = await permissionManage.findAllAndroidPermissions(
          await handle.xmlTagAttributes('uses-permission',
              attName: 'android:name'),
        );
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    // try {
    //   // 处理androidManifest.xml文件
    //   if (!await InfoHandle.fileWrite(
    //     "$platformPath/${ProjectFilePath.androidManifest}",
    //     (source) {
    //       source = InfoHandle.sourceReplace(
    //           source, _labelReg, 'android:label="$label"');
    //       source = InfoHandle.sourceReplace(
    //           source, _packageReg, 'package="$package"');
    //       // 权限字段替换，
    //       // (1 删除全部已有权限
    //       source = InfoHandle.sourceReplace(source, _permissionReg, '');
    //       source = InfoHandle.sourceReplace(source, RegExp(r'\t*\n'), '');
    //       // (2 将当前用户修改过的权限集合重新写入到指定位置
    //       var v = permissions
    //           .map((e) => '<uses-permission android:name="${e.value}" />')
    //           .join('\n');
    //       const anchor = "<application";
    //       source =
    //           InfoHandle.sourceReplace(source, RegExp(anchor), "$v\n$anchor");
    //       return source;
    //     },
    //   )) return false;
    //   // 处理app/build.gradle文件
    //   if (!await InfoHandle.fileWrite(
    //     "$platformPath/${ProjectFilePath.androidAppBuildGradle}",
    //     (source) {
    //       source = InfoHandle.sourceReplace(
    //           source, _packageReg, 'applicationId "$package"');
    //       return source;
    //     },
    //   )) return false;
    // } catch (e) {
    //   return false;
    // }
    return true;
  }

  @override
  String? getProjectIcon() {
    try {
      return loadIcons()
          .values
          .toList()
          .reversed
          .firstWhere((e) => File(e).existsSync());
    } catch (e) {
      // 未找到
    }
    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final AndroidPlatform typedOther = other;
    return label == typedOther.label &&
        package == typedOther.package &&
        iconPath == typedOther.iconPath &&
        (permissions.length == typedOther.permissions.length &&
            !permissions.any((e) => !typedOther.permissions.contains(e)));
  }

  @override
  int get hashCode => Object.hash(
        label,
        package,
        iconPath,
        Object.hashAll(permissions),
      );
}

/*
* android图标尺寸枚举
* @author JTech JH
* @Time 2022-07-29 17:59:54
*/
enum AndroidIconSize { mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi }

/*
* android图标尺寸枚举扩展
* @author JTech JH
* @Time 2022-07-29 18:00:20
*/
extension AndroidIconSizeExtension on AndroidIconSize {
  // 图标展示尺寸
  double get showSize {
    switch (this) {
      case AndroidIconSize.mdpi:
        return 30.0;
      case AndroidIconSize.hdpi:
        return 40.0;
      case AndroidIconSize.xhdpi:
        return 50.0;
      case AndroidIconSize.xxhdpi:
        return 60.0;
      case AndroidIconSize.xxxhdpi:
      default:
        return 70.0;
    }
  }

  // 获取真实图片尺寸
  double get sizePx {
    switch (this) {
      case AndroidIconSize.mdpi:
        return 48;
      case AndroidIconSize.hdpi:
        return 72;
      case AndroidIconSize.xhdpi:
        return 96;
      case AndroidIconSize.xxhdpi:
        return 144;
      case AndroidIconSize.xxxhdpi:
      default:
        return 192;
    }
  }

  // 拼装附件相对路径
  String getAbsolutePath(String iconPath, {String suffix = ".png"}) {
    var t = iconPath.split("/"), dir = t.first, fileName = t.last + suffix;
    return "${ProjectFilePath.androidRes}/$dir-$name/$fileName";
  }
}
