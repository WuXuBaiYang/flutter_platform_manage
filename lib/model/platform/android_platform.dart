import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
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
    this.label = '',
    this.package = '',
    this.iconPath = '',
    this.permissions = const [],
  }) : super(type: PlatformType.android, platformPath: platformPath);

  // androidManifest.xml文件绝对路径
  String get manifestFilePath =>
      '$platformPath/${ProjectFilePath.androidManifest}';

  String get appBuildGradle =>
      '$platformPath/${ProjectFilePath.androidAppBuildGradle}';

  @override
  Future<bool> update(bool simple) async {
    final handle = FileHandleXML.from(manifestFilePath);
    try {
      // 处理androidManifest.xml文件
      // 获取图标路径信息
      iconPath =
          (await handle.singleAtt('application', attName: 'android:icon'))
              .replaceAll(r'@', '');
      if (!simple) {
        // 获取label
        label = await handle.singleAtt('application', attName: 'android:label');
        // 获取包名
        package = await handle.singleAtt('manifest', attName: 'package');
        // 获取权限集合
        permissions = await permissionManage.findAllPermissions(
          await handle.attList('uses-permission', attName: 'android:name'),
          platform: PlatformType.android,
        );
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理androidManifest.xml文件
      if (!await FileHandleXML.from(manifestFilePath).fileWrite((handle) async {
        // 修改label
        await modifyDisplayName(label, handle: handle);
        // 修改包名
        await handle.setElAtt('manifest', attName: 'package', value: package);
        // 移除所有权限
        await handle.removeEl('uses-permission', target: 'manifest');
        // 封装权限并插入
        await handle.insertEl('manifest',
            nodes: permissions.map((e) {
              return XmlElement(XmlName('uses-permission'), [
                XmlAttribute(XmlName('android:name'), e.value),
              ]);
            }).toList());
      })) return false;
      // 处理app/build.gradle文件
      if (!await FileHandleXML.from(appBuildGradle).fileWrite((handle) async {
        // 修改包名
        await handle.replace(RegExp(r'(package=|applicationId\s*)".+"'),
            'applicationId "$package"');
      })) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 获取图标文件路径集合
  Map<AndroidIcons, String> loadIcons({bool reversed = false}) {
    if (iconPath.isEmpty) return {};
    const values = AndroidIcons.values;
    return Map.fromEntries((reversed ? values.reversed : values).map((e) {
      final path = e.getAbsolutePath(iconPath);
      return MapEntry(e, '$platformPath/$path');
    }));
  }

  @override
  String get projectIcon => loadIcons().values.lastWhere(
        (e) => File(e).existsSync(),
        orElse: () => '',
      );

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandleXML.from(manifestFilePath);
    if (handle is! FileHandleXML) return false;
    // 修改label
    await handle.setElAtt('application', attName: 'android:label', value: name);
    return autoCommit ? await handle.commit(indentAtt: true) : true;
  }

  @override
  Future<List<String>> modifyProjectIcon(File file) async {
    return Utils.compressIcons(file,
        Map.fromEntries(AndroidIcons.values.map((e) {
      final size = Size.square(e.sizePx.toDouble());
      return MapEntry(size, '$platformPath/${e.getAbsolutePath(iconPath)}');
    })));
  }

  @override
  Future<void> projectPackaging(File output) async {
    ///待实现
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
  num get showSize => const {
        AndroidIcons.mdpi: 30,
        AndroidIcons.hdpi: 40,
        AndroidIcons.xhdpi: 50,
        AndroidIcons.xxhdpi: 60,
        AndroidIcons.xxxhdpi: 70,
      }[this]!;

  // 获取真实图片尺寸
  num get sizePx => {
        AndroidIcons.mdpi: 48,
        AndroidIcons.hdpi: 72,
        AndroidIcons.xhdpi: 96,
        AndroidIcons.xxhdpi: 144,
        AndroidIcons.xxxhdpi: 192,
      }[this]!;

  // 拼装附件相对路径
  String getAbsolutePath(String iconPath) {
    final t = iconPath.split('/'), dir = t.first, fileName = '${t.last}.png';
    return '${ProjectFilePath.androidRes}/$dir-$name/$fileName';
  }
}
