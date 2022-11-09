import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/model/platform/android.dart';
import 'package:flutter_platform_manage/model/platform/ios.dart';
import 'package:flutter_platform_manage/model/platform/linux.dart';
import 'package:flutter_platform_manage/model/platform/macos.dart';
import 'package:flutter_platform_manage/model/platform/web.dart';
import 'package:flutter_platform_manage/model/platform/windows.dart';
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

  // 平台图标集合
  late List<ProjectIcon> projectIcons;

  BasePlatform({
    required this.type,
    required this.platformPath,
  }) : projectIcons = const [];

  // 更新信息
  Future<bool> update({bool simple=false});

  // 提交信息变动
  Future<bool> commit();

  // 图标展示目标尺寸
  final _targetIconSize = const Size.square(50);

  // 获取单一平台图标
  ProjectIcon? get singleIcon {
    if (projectIcons.isEmpty) return null;
    ProjectIcon? icon;
    for (var it in projectIcons) {
      if (it.size >= _targetIconSize) {
        return it;
      }
      if (it.size > (icon?.size ?? Size.zero)) {
        icon = it;
      }
    }
    return icon;
  }

  // 修改平台应用名（展示名称）
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false});

  // 项目打包
  Future<bool> projectPackaging(File output);
}

/*
* 平台图标信息管理
* @author wuxubaiyang
* @Time 2022/10/28 10:17
*/
class ProjectIcon {
  // 图标尺寸
  final Size size;

  // 资源路径/名称
  final String src;

  // 资源类型
  final String type;

  // 文件类型
  final String fileType;

  // 资源描述
  final String desc;

  ProjectIcon({
    required this.size,
    required this.src,
    required this.fileType,
    this.type = '',
    this.desc = '',
  });
}

// 平台类型枚举
enum PlatformType {
  android,
  ios,
  web,
  macos,
  windows,
  linux,
}

// 平台类型枚举扩展
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
