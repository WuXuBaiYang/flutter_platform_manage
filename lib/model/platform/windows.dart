import 'dart:io';
import 'dart:ui';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';

/*
* windows平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WindowsPlatform extends BasePlatform {
  WindowsPlatform({
    required String platformPath,
  }) : super(type: PlatformType.windows, platformPath: platformPath);

  // 默认图标路径
  String get iconFilePath => '$platformPath/runner/resources/app_icon.ico';

  @override
  Future<bool> update(bool simple) async {
    final handle = FileHandle.from('');
    try {
      // 加载项目图标
      projectIcons = await _loadIcons();

      ///待实现
    } catch (e) {
      return false;
    }
    return true;
  }

  // 加载项目图标
  Future<List<ProjectIcon>> _loadIcons() async {
    List<ProjectIcon> result = [];
    try {
      // 添加favicon图标
      if (File(iconFilePath).existsSync()) {
        result.add(ProjectIcon(
          size: const Size.square(256),
          src: iconFilePath,
          type: 'image/ico',
          fileType: 'ico',
        ));
      }
    } catch (e) {
      LogTool.e('windows图片加载异常：', error: e);
    }
    return result;
  }

  @override
  Future<bool> commit() async {
    final handle = FileHandle.from('');
    try {
      ///待实现
    } catch (e) {
      return false;
    }
    return handle.commit();
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
