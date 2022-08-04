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
  String? getProjectIcon();
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
  BasePlatform create(String platformPath) {
    switch (this) {
      case PlatformType.android:
        return AndroidPlatform(platformPath: platformPath);
      case PlatformType.ios:
        return IOSPlatform(platformPath: platformPath);
      case PlatformType.web:
        return WebPlatform(platformPath: platformPath);
      case PlatformType.windows:
        return WindowsPlatform(platformPath: platformPath);
      case PlatformType.macos:
        return MacOSPlatform(platformPath: platformPath);
      case PlatformType.linux:
        return LinuxPlatform(platformPath: platformPath);
    }
  }

  // 获取平台图标
  String get platformImage {
    switch (this) {
      case PlatformType.android:
        return Common.platformAndroid;
      case PlatformType.ios:
        return Common.platformIOS;
      case PlatformType.web:
        return Common.platformWeb;
      case PlatformType.windows:
        return Common.platformWindows;
      case PlatformType.macos:
        return Common.platformMacos;
      case PlatformType.linux:
        return Common.platformLinux;
    }
  }
}
