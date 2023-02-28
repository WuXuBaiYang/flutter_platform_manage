import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:xml/xml.dart';

/*
* android平台信息
* @author wuxubaiyang
* @Time 5/15/2022 9:21 AM
*/
class AndroidPlatform extends BasePlatform {
  // 应用名
  String label = '';

  // 包名
  String package = '';

  // 图标对象
  String _iconPath = '';

  // 权限集合
  List<PermissionItemModel> permissions = [];

  AndroidPlatform({
    required super.platformPath,
  }) : super(type: PlatformType.android);

  // androidManifest.xml文件绝对路径
  String get _manifestFilePath =>
      '$platformPath/${ProjectFilePath.androidManifest}';

  // app/buildGradle 文件绝对路径
  String get _appBuildGradleFilePath =>
      '$platformPath/${ProjectFilePath.androidAppBuildGradle}';

  // app/src/main/res 资源路径
  String get _appResPath => '$platformPath/${ProjectFilePath.androidRes}';

  @override
  Future<bool> update({bool simple = false}) async {
    final handle = FileHandleXML.from(_manifestFilePath);
    try {
      // 处理androidManifest.xml文件
      // 获取图标路径
      _iconPath =
          (await handle.singleAtt('application', attName: 'android:icon'))
              .replaceAll(r'@', '');
      // 加载图标
      projectIcons = await _loadIcons();
      if (simple) return true;
      // 获取label
      label = await handle.singleAtt('application', attName: 'android:label');
      // 获取包名
      package = await handle.singleAtt('manifest', attName: 'package');
      // 获取权限集合
      permissions = await permissionManage.findAllPermissions(
        await handle.attList('uses-permission', attName: 'android:name'),
        platform: PlatformType.android,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  // 加载项目图标
  Future<List<ProjectIcon>> _loadIcons() async {
    if (_iconPath.isEmpty) return [];
    final paths = _iconPath.split('/');
    if (paths.length != 2) return [];
    List<ProjectIcon> icons = [];
    // 遍历目录下符合条件的图标
    for (var resIt in Directory(_appResPath).listSync()) {
      final path = resIt.path;
      final start = path.lastIndexOf(r'-');
      final type = start != -1 ? path.substring(start + 1) : '';
      if (path.contains(paths.first)) {
        for (var iconIt in Directory(path).listSync()) {
          if (iconIt.path.contains(paths.last)) {
            // 添加图片信息
            final file = File(iconIt.path);
            icons.add(ProjectIcon(
              size: await Utils.loadImageSize(file),
              src: file.path,
              type: type,
              fileType: 'png',
            ));
            break;
          }
        }
      }
    }
    return icons;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理androidManifest.xml文件
      if (!await FileHandleXML.from(_manifestFilePath)
          .fileWrite((handle) async {
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
      if (!await FileHandleXML.from(_appBuildGradleFilePath)
          .fileWrite((handle) async {
        // 修改包名
        await handle.replace(RegExp(r'(package=|applicationId\s*)".+"'),
            'applicationId "$package"');
      })) return false;
    } catch (e) {
      LogTool.e('android平台信息提交失败：', error: e);
      return false;
    }
    return true;
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandleXML.from(_manifestFilePath);
    if (handle is! FileHandleXML) return false;
    // 修改label
    await handle.setElAtt('application', attName: 'android:label', value: name);
    return autoCommit ? await handle.commit(indentAtt: true) : true;
  }

  @override
  String? get displayName => label;

  @override
  bool operator ==(dynamic other) {
    if (other is! AndroidPlatform) return false;
    return label == other.label &&
        package == other.package &&
        (permissions.length == other.permissions.length &&
            !permissions.any((e) => !other.permissions.contains(e)));
  }

  @override
  int get hashCode => Object.hash(label, package, Object.hashAll(permissions));
}
