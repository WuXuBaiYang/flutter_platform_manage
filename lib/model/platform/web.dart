import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* web平台信息
* @author wuxubaiyang
* @Time 5/20/2022 11:28 AM
*/
class WebPlatform extends BasePlatform {
  // 名称
  String name = '';

  // 缩略名
  String shortName = '';

  // 启动地址
  String startUrl = '';

  // 启动模式
  WebDisplayMode display = WebDisplayMode.standalone;

  // 背景颜色
  Color backgroundColor = Colors.transparent;

  // 样式颜色
  Color themeColor = Colors.transparent;

  // 描述
  String description = '';

  // 如果建议使用应用商店或应用商店本机应用
  bool preferRelatedApplications = false;

  WebPlatform({
    required super.platformPath,
  }) : super(type: PlatformType.web);

  // manifest文件路径
  String get _manifestFilePath =>
      '$platformPath/${ProjectFilePath.webManifest}';

  // favicon图标路径
  String get _faviconFilePath => '$platformPath/favicon.png';

  @override
  Future<bool> update(bool simple) async {
    final handle = FileHandleJSON.from(_manifestFilePath);
    try {
      final jsonData = await handle.jsonDataMap;
      // 获取项目图标
      projectIcons = await _loadIcons(jsonData['icons'] ?? []);
      // 获取项目名称
      name = jsonData['name'] ?? '';
      // 获取缩略项目名称
      shortName = jsonData['short_name'] ?? '';
      // 获取启动地址
      startUrl = jsonData['start_url'] ?? '';
      // 获取启动模式
      display = _getDisplayMode(jsonData['display'] ?? '');
      // 获取背景颜色
      backgroundColor =
          Utils.parseHexColor(jsonData['background_color'] ?? '') ??
              const Color(0xff0175C2);
      // 获取主题色
      themeColor = Utils.parseHexColor(jsonData['theme_color'] ?? '') ??
          const Color(0xff0175C2);
      // 获取描述
      description = jsonData['description'] ?? '';
      // 获取商店推荐状态
      preferRelatedApplications =
          jsonData['prefer_related_applications'] ?? false;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 加载项目图标
  Future<List<ProjectIcon>> _loadIcons(List icons) async {
    List<ProjectIcon> result = [];
    try {
      // 添加favicon图标
      if (File(_faviconFilePath).existsSync()) {
        result.add(ProjectIcon(
          size: const Size.square(16),
          src: _faviconFilePath,
          type: 'image/png',
          fileType: 'png',
        ));
      }
      // 添加其他图标
      for (var it in icons) {
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
          fileType: 'png',
        ));
      }
    } catch (e) {
      LogTool.e('web图片加载异常：', error: e);
    }
    return result;
  }

  @override
  Future<bool> commit() async {
    try {
      // 处理manifest文件
      if (!await FileHandleJSON.from(_manifestFilePath)
          .fileWrite((handle) async {
        // 修改name
        await modifyDisplayName(name, handle: handle);
        // 修改短名
        await handle.setInMap('short_name', value: name);
        // 修改启动地址
        await handle.setInMap('start_url', value: startUrl);
        // 修改启动模式
        await handle.setInMap('display', value: display.value);
        // 修改背景颜色
        await handle.setInMap('background_color',
            value: Utils.toHexColor(backgroundColor));
        // 修改主体颜色
        await handle.setInMap('theme_color',
            value: Utils.toHexColor(themeColor));
        // 修改描述
        await handle.setInMap('description', value: description);
        // 修改推荐
        await handle.setInMap('prefer_related_applications',
            value: preferRelatedApplications);
      })) return false;
    } catch (e) {
      LogTool.e('web平台信息提交失败：', error: e);
      return false;
    }
    return true;
  }

  @override
  Future<bool> modifyDisplayName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandleJSON.from(_manifestFilePath);
    if (handle is! FileHandleJSON) return false;
    // 修改name
    await handle.setInMap('name', value: name);
    return autoCommit ? await handle.commit() : true;
  }

  @override
  Future<bool> projectPackaging(File output) async {
    ///待实现
    return true;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final WebPlatform typedOther = other;
    return name == typedOther.name &&
        shortName == typedOther.shortName &&
        startUrl == typedOther.startUrl &&
        display == typedOther.display &&
        backgroundColor == typedOther.backgroundColor &&
        themeColor == typedOther.themeColor &&
        description == typedOther.description &&
        preferRelatedApplications == typedOther.preferRelatedApplications;
  }

  @override
  int get hashCode => Object.hash(
        name,
        shortName,
        startUrl,
        display,
        backgroundColor,
        themeColor,
        description,
        preferRelatedApplications,
      );
}

// 根据名称获取对应启动模式
WebDisplayMode _getDisplayMode(String key) =>
    {
      'fullscreen': WebDisplayMode.fullscreen,
      'standalone': WebDisplayMode.standalone,
      'minimal-ui': WebDisplayMode.minimalUI,
      'browser': WebDisplayMode.browser,
    }[key] ??
    WebDisplayMode.standalone;

// 启动模式
enum WebDisplayMode {
  fullscreen,
  standalone,
  minimalUI,
  browser,
}

// 启动模式扩展
extension WebDisplayModeExtension on WebDisplayMode {
  // 获取值
  String get value => {
        WebDisplayMode.fullscreen: 'fullscreen',
        WebDisplayMode.standalone: 'standalone',
        WebDisplayMode.minimalUI: 'minimal-ui',
        WebDisplayMode.browser: 'browser',
      }[this]!;

  // 模式说明
  String get desc => {
        WebDisplayMode.fullscreen: '在没有任何浏览器UI的情况下打开Web应用程序并占用整个可用显示区域',
        WebDisplayMode.standalone:
            '打开Web应用程序，使其看起来和感觉像一个独立的应用程序。该应用程序在自己的窗口中运行，独立于浏览器，并隐藏了标准的浏览器UI元素，例如URL栏',
        WebDisplayMode.minimalUI: '此模式类似于独立模式，但为用户提供了一组最小的UI元素来控制导航（例如返回和重新加载）',
        WebDisplayMode.browser: '标准的浏览器体验',
      }[this]!;
}
