import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:xml/xml.dart';

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
  Map<AndroidIcons, String> loadIcons(
      {String suffix = ".png", bool reversed = false}) {
    if (iconPath.isEmpty) return {};
    var values = AndroidIcons.values;
    return Map.fromEntries((reversed ? values.reversed : values).map((e) {
      var path = e.getAbsolutePath(iconPath, suffix: suffix);
      return MapEntry(e, "$platformPath/$path");
    }));
  }

  // androidManifest.xml文件绝对路径
  String get manifestFilePath =>
      "$platformPath/${ProjectFilePath.androidManifest}";

  String get appBuildGradle =>
      "$platformPath/${ProjectFilePath.androidAppBuildGradle}";

  @override
  Future<bool> update(bool simple) async {
    var handle = FileHandle.from(manifestFilePath);
    try {
      // 处理androidManifest.xml文件
      iconPath =
          (await handle.singleAtt("application", attName: "android:icon"))
              .replaceAll(r'@', "");
      if (!simple) {
        label = await handle.singleAtt("application", attName: "android:label");
        package = await handle.singleAtt("manifest", attName: "package");
        permissions = await permissionManage.findAllAndroidPermissions(
          await handle.attList('uses-permission', attName: 'android:name'),
        );
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    var handle = FileHandle.from(manifestFilePath);
    try {
      // 处理androidManifest.xml文件
      await handle.setElAtt("application",
          attName: "android:label", value: label);
      await handle.setElAtt("manifest", attName: "package", value: package);
      // 先移除所有权限标签
      await handle.removeEl("uses-permission", target: "manifest");
      // 写入新的权限标签集合
      var nodes = permissions.map((e) {
        return XmlElement(XmlName("uses-permission"), [
          XmlAttribute(XmlName("android:name"), e.value),
        ]);
      }).toList();
      await handle.insertEl("manifest", nodes: nodes);
      // 中场休息，提交一次
      if (!await handle.commit(indentAtt: true)) return false;
      // 处理app/build.gradle文件
      handle = FileHandle.from(appBuildGradle);
      await handle.replace(RegExp(r'(package=|applicationId\s*)".+"'),
          'applicationId "$package"');
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  @override
  String? get projectIcon {
    try {
      return loadIcons().values.lastWhere((e) {
        return File(e).existsSync();
      });
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
enum AndroidIcons { mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi }

/*
* android图标尺寸枚举扩展
* @author JTech JH
* @Time 2022-07-29 18:00:20
*/
extension AndroidIconsExtension on AndroidIcons {
  // 图标展示尺寸
  double get showSize {
    switch (this) {
      case AndroidIcons.mdpi:
        return 30.0;
      case AndroidIcons.hdpi:
        return 40.0;
      case AndroidIcons.xhdpi:
        return 50.0;
      case AndroidIcons.xxhdpi:
        return 60.0;
      case AndroidIcons.xxxhdpi:
      default:
        return 70.0;
    }
  }

  // 获取真实图片尺寸
  double get sizePx {
    switch (this) {
      case AndroidIcons.mdpi:
        return 48;
      case AndroidIcons.hdpi:
        return 72;
      case AndroidIcons.xhdpi:
        return 96;
      case AndroidIcons.xxhdpi:
        return 144;
      case AndroidIcons.xxxhdpi:
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
