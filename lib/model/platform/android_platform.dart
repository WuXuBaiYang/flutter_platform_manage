import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/event_manage.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/event/project_logo_change_event.dart';
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
    this.label = "",
    this.package = "",
    this.iconPath = "",
    this.permissions = const [],
  }) : super(type: PlatformType.android, platformPath: platformPath);

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
      // 获取图标路径信息
      iconPath =
          (await handle.singleAtt("application", attName: "android:icon"))
              .replaceAll(r'@', "");
      if (!simple) {
        // 获取label
        label = await handle.singleAtt("application", attName: "android:label");
        // 获取包名
        package = await handle.singleAtt("manifest", attName: "package");
        // 获取权限集合
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
      // 修改label
      await modifyDisplayName(label, handle: handle);
      // 修改包名
      await handle.setElAtt("manifest", attName: "package", value: package);
      // 移除所有权限
      await handle.removeEl("uses-permission", target: "manifest");
      // 封装权限并插入
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
      // 修改包名
      await handle.replace(RegExp(r'(package=|applicationId\s*)".+"'),
          'applicationId "$package"');
    } catch (e) {
      return false;
    }
    return handle.commit();
  }

  // 获取图标文件路径集合
  Map<AndroidIcons, String> loadIcons({bool reversed = false}) {
    if (iconPath.isEmpty) return {};
    var values = AndroidIcons.values;
    return Map.fromEntries((reversed ? values.reversed : values).map((e) {
      var path = e.getAbsolutePath(iconPath);
      return MapEntry(e, "$platformPath/$path");
    }));
  }

  @override
  String get projectIcon => loadIcons().values.lastWhere(
        (e) => File(e).existsSync(),
        orElse: () => "",
      );

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandle.from(manifestFilePath);
    // 修改label
    await handle.setElAtt("application", attName: "android:label", value: name);
    return autoCommit ? await handle.commit(indentAtt: true) : true;
  }

  @override
  Future<void> modifyProjectIcon(File file) async {
    // 对图片尺寸进行遍历和压缩
    var paths = <String>[];
    final rawImage = await file.readAsBytes();
    for (var it in AndroidIcons.values) {
      var imageSize = it.sizePx.toInt();
      var bytes = await Utils.resizeImage(rawImage,
          height: imageSize, width: imageSize);
      if (null == bytes) continue;
      var f = File("$platformPath/${it.getAbsolutePath(iconPath)}");
      f = await f.writeAsBytes(bytes.buffer.asInt8List());
      paths.add(f.path);
    }
    // 发送图片源变动的地址集合
    eventManage.fire(ProjectLogoChangeEvent(paths));
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
    var t = iconPath.split("/"), dir = t.first, fileName = "${t.last}.png";
    return "${ProjectFilePath.androidRes}/$dir-$name/$fileName";
  }
}
