import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/permission.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';

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
    this.bundleName = '',
    this.bundleDisplayName = '',
    this.permissions = const [],
  }) : super(type: PlatformType.ios, platformPath: platformPath);

  // info.plist文件绝对路径
  String get infoPlistFilePath =>
      '$platformPath/${ProjectFilePath.iosInfoPlist}';

  // appIcon.appIconSet目录路径
  String get appIconAssetsPath =>
      '$platformPath/${ProjectFilePath.iosAssetsAppIcon}';

  @override
  Future<bool> update(bool simple) async {
    final handle = FileHandlePList.from(infoPlistFilePath);
    try {
      // 加载项目图标
      projectIcons = await _loadIcons();
      if (!simple) {
        // 处理info.plist文件
        // 获取包名
        bundleName = await handle.getValue('CFBundleName', def: '');
        // 获取打包展示名称
        bundleDisplayName =
            await handle.getValue('CFBundleDisplayName', def: '');
        // 获取权限集合
        permissions = await permissionManage.findAllPermissions(
          await handle.getKeyList(includeKey: 'NS'),
          platform: PlatformType.ios,
        );
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  // 加载项目图标
  Future<List<ProjectIcon>> _loadIcons() async {
    List<ProjectIcon> result = [];
    try {
      // 读取配置文件信息
      final f = File('$appIconAssetsPath/Contents.json');
      final config = jsonDecode(f.readAsStringSync());
      for (var it in config['images'] ?? []) {
        final fileName = it['filename'] ?? '';
        final size = (it['size'] ?? '').split('x');
        var w = 0.0, h = 0.0;
        if (size.length == 2) {
          w = double.tryParse(size.first) ?? 0.0;
          h = double.tryParse(size.last) ?? 0.0;
        }
        result.add(ProjectIcon(
          size: Size(w, h),
          src: fileName.isNotEmpty ? '$appIconAssetsPath/$fileName' : '',
          type: it['scale'] ?? '',
          desc: it['idiom'] ?? '',
        ));
      }
    } catch (e) {
      LogTool.e('ios图片加载异常：', error: e);
    }
    return result;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理info.plist文件
      if (!await FileHandlePList.from(infoPlistFilePath)
          .fileWrite((handle) async {
        // 修改打包名称
        await handle.setValue('CFBundleName', bundleName);
        // 修改显示名称
        await modifyDisplayName(bundleDisplayName, handle: handle);
        // 移除所有权限
        await handle.removeValueList(includeKey: 'NS');
        // 插入编辑好的权限
        await handle.insertValueMap(
          valueMap: permissions.asMap().map((key, value) {
            return MapEntry(value.value, value.describe ?? '');
          }),
        );
      })) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandle.from(infoPlistFilePath);
    if (handle is! FileHandlePList) return false;
    await handle.setValue('CFBundleDisplayName', name);
    return autoCommit ? await handle.commit() : true;
  }

  @override
  Future<bool> projectPackaging(File output) async {
    /// 待实现
    return true;
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
