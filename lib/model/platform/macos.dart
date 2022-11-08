import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';

/*
* macos平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class MacOSPlatform extends BasePlatform {
  // 沙盒模式-开发
  bool sandBoxDebug = true;

  // 沙盒模式-发布
  bool sandBoxRelease = true;

  MacOSPlatform({
    required super.platformPath,
  }) : super(type: PlatformType.macos);

  // // info.plist文件绝对路径
  // String get _infoPlistFilePath =>
  //     '$platformPath/${ProjectFilePath.macosInfoPlist}';

  // 开发模式的 DebugProfile.entitlements文件绝对路径
  String get _debugPlistFilePath =>
      '$platformPath/${ProjectFilePath.debugProfilePlist}';

  // 发布模式的 Release.entitlements文件绝对路径
  String get _releasePlistFilePath =>
      '$platformPath/${ProjectFilePath.releasePlist}';

  // appIcon.appIconSet目录路径
  String get _appIconAssetsPath =>
      '$platformPath/${ProjectFilePath.macosAssetsAppIcon}';

  @override
  Future<bool> update(bool simple) async {
    try {
      // 加载项目图标
      projectIcons = await _loadIcons();
      if (simple) return true;
      final debugPlistHandle = FileHandlePList.from(_debugPlistFilePath);
      final releasePlistHandle = FileHandlePList.from(_releasePlistFilePath);
      // 获取沙盒模式-开发状态
      sandBoxDebug = await debugPlistHandle
          .getValue('com.apple.security.app-sandbox', def: true) as bool;
      // 获取沙盒模式-发布状态
      sandBoxRelease = await releasePlistHandle
          .getValue('com.apple.security.app-sandbox', def: true) as bool;
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
      final f = File('$_appIconAssetsPath/Contents.json');
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
          src: fileName.isNotEmpty ? '$_appIconAssetsPath/$fileName' : '',
          type: it['scale'] ?? '',
          desc: it['idiom'] ?? '',
          fileType: 'png',
        ));
      }
    } catch (e) {
      LogTool.e('macos图片加载异常：', error: e);
    }
    return result;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理DebugProfile.entitlements文件
      if (!await FileHandlePList.from(_debugPlistFilePath)
          .fileWrite((handle) async {
        // 修改沙盒模式
        handle.setValue('com.apple.security.app-sandbox', sandBoxDebug);
      })) return false;
      // 处理Release.entitlements文件
      if (!await FileHandlePList.from(_releasePlistFilePath)
          .fileWrite((handle) async {
        // 修改沙盒模式
        handle.setValue('com.apple.security.app-sandbox', sandBoxRelease);
      })) return false;
    } catch (e) {
      LogTool.e('macos平台信息提交失败：', error: e);
      return false;
    }
    return true;
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    ///待实现
    return true;
  }

  @override
  Future<bool> projectPackaging(File output) async {
    ///待实现
    return true;
  }
}
