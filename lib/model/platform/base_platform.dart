import 'dart:io';

import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/model/platform/android_platform.dart';
import 'package:flutter_platform_manage/model/platform/ios_platform.dart';
import 'package:flutter_platform_manage/model/platform/linux_platform.dart';
import 'package:flutter_platform_manage/model/platform/macos_platform.dart';
import 'package:flutter_platform_manage/model/platform/web_platform.dart';
import 'package:flutter_platform_manage/model/platform/windows_platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';

/*
* 平台基类
* @author wuxubaiyang
* @Time 5/20/2022 11:14 AM
*/
abstract class BasePlatform {
  // 平台类型
  final PlatformType type;

  // 平台根路径
  final String platformPath;

  BasePlatform({
    required this.type,
    required this.platformPath,
  });

  // 更新信息
  Future<bool> update(bool simple);

  // 提交信息变动
  Future<bool> commit();

  // 获取应用图标
  String get projectIcon;

  // 修改平台应用名（展示名称）
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false});

  // 修改平台图标
  Future<List<String>> modifyProjectIcon(File file);

  // 项目打包
  Future<void> projectPackaging(File output);
}

/*
* 平台类型枚举
* @author wuxubaiyang
* @Time 5/20/2022 11:14 AM
*/
enum PlatformType {
  android,
  ios,
  windows,
  macos,
  linux,
  web,
}

/*
* 平台类型枚举扩展
* @author wuxubaiyang
* @Time 5/20/2022 11:23 AM
*/
extension PlatformTypeExtension on PlatformType {
  // 创建平台信息对象
  BasePlatform create(String platformPath) => {
        PlatformType.android: (_) => AndroidPlatform(platformPath: _),
        PlatformType.ios: (_) => IOSPlatform(platformPath: _),
        PlatformType.web: (_) => WebPlatform(platformPath: _),
        PlatformType.windows: (_) => WindowsPlatform(platformPath: _),
        PlatformType.macos: (_) => MacOSPlatform(platformPath: _),
        PlatformType.linux: (_) => LinuxPlatform(platformPath: _),
      }[this]!(platformPath);

  // 获取平台图标
  String get platformImage => const {
        PlatformType.android: Common.platformAndroid,
        PlatformType.ios: Common.platformIOS,
        PlatformType.web: Common.platformWeb,
        PlatformType.windows: Common.platformWindows,
        PlatformType.macos: Common.platformMacos,
        PlatformType.linux: Common.platformLinux,
      }[this]!;
}
