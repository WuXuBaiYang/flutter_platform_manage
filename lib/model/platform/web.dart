import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';

/*
* web平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WebPlatform extends BasePlatform {
  WebPlatform({
    required String platformPath,
  }) : super(type: PlatformType.web, platformPath: platformPath);

  // manifest文件路径
  String get manifestFilePath => '$platformPath/${ProjectFilePath.webManifest}';

  // favicon图标路径
  String get faviconFilePath => '$platformPath/favicon.png';

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
      if (File(faviconFilePath).existsSync()) {
        result.add(ProjectIcon(
          size: const Size.square(16),
          src: faviconFilePath,
          type: 'image/png',
        ));
      }
      // 添加其他图标
      final f = File(manifestFilePath);
      final config = jsonDecode(f.readAsStringSync());
      for (var it in config['icons']) {
        final src = it['src'] ?? '';
        final size = (it['sizes'] ?? '').split('x');
        var w = 0.0, h = 0.0;
        if (size.length == 2) {
          w = double.tryParse(size.first) ?? 0.0;
          h = double.tryParse(size.last) ?? 0.0;
        }
        result.add(ProjectIcon(
          size: Size(w, h),
          src: '$platformPath/$src',
          type: it['type'],
        ));
      }
    } catch (e) {
      LogTool.e('web图片加载异常：', error: e);
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
