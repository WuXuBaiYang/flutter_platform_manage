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
  MacOSPlatform({
    required String platformPath,
  }) : super(type: PlatformType.macos, platformPath: platformPath);

  // info.plist文件绝对路径
  String get infoPlistFilePath =>
      '$platformPath/${ProjectFilePath.macosInfoPlist}';

  // appIcon.appIconSet目录路径
  String get appIconAssetsPath =>
      '$platformPath/${ProjectFilePath.macosAssetsAppIcon}';

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
      LogTool.e('macos图片加载异常：', error: e);
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
