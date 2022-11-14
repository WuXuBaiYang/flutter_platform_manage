import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/manager/event.dart';
import 'package:flutter_platform_manage/model/event/theme.dart';
import 'cache.dart';

/*
* 样式管理
* @author wuxubaiyang
* @Time 2022/10/14 10:09
*/
class ThemeManage extends BaseManage {
  // 默认样式缓存字段
  final String _defaultThemeCacheKey = 'default_theme_cache';

  // 默认字体缓存字段
  final String _defaultThemeFontFamilyCacheKey =
      'default_theme_font_family_cache';

  static final ThemeManage _instance = ThemeManage._internal();

  factory ThemeManage() => _instance;

  ThemeManage._internal();

  // 当前类型
  ThemeType get currentType {
    final index = cacheManage.getInt(_defaultThemeCacheKey);
    return ThemeType.values[index ?? 0];
  }

  // 当前样式
  ThemeData get currentTheme => currentType.getTheme(
        fontFamily: currentFontFamily.fontFamily,
      );

  // 切换默认样式
  Future<bool> switchTheme(ThemeType type) async {
    final result = await cacheManage.setInt(_defaultThemeCacheKey, type.index);
    eventManage.fire(ThemeEvent(
      themeType: type,
      fontFamily: currentFontFamily,
    ));
    return result;
  }

  // 获取当前字体
  ThemeFontFamily get currentFontFamily {
    final index = cacheManage.getInt(_defaultThemeFontFamilyCacheKey);
    return ThemeFontFamily.values[index ?? 0];
  }

  // 切换字体
  Future<bool> switchFontFamily(ThemeFontFamily fontFamily) async {
    final result = await cacheManage.setInt(
        _defaultThemeFontFamilyCacheKey, fontFamily.index);
    eventManage.fire(ThemeEvent(
      themeType: currentType,
      fontFamily: fontFamily,
    ));
    return result;
  }
}

// 单例调用
final themeManage = ThemeManage();

// 支持的样式枚举
enum ThemeType {
  light,
  dark,
}

// 样式枚举扩展
extension ThemeTypeExtension on ThemeType {
  // 判断当前状态是否为日间模式
  bool get isDayLight => this == ThemeType.light;

  // 样式中文名
  String get nameCN => <ThemeType, String>{
        ThemeType.light: '日间模式',
        ThemeType.dark: '夜间模式',
      }[this]!;

  // 获取对应的样式配置
  ThemeData getTheme({String? fontFamily}) => <ThemeType, ThemeData>{
        ThemeType.light: ThemeData(
          brightness: Brightness.light,
          typography: _typography,
          fontFamily: fontFamily,
        ),
        ThemeType.dark: ThemeData(
          brightness: Brightness.dark,
          typography: _typography,
          fontFamily: fontFamily,
        ),
      }[this]!;

  // 获取字体样式
  Typography? get _typography => Typography.raw(
        title: TextStyle(
          fontSize: 18,
          color: isDayLight ? Colors.black : Colors.white,
        ),
      );
}

// 支持字体库
enum ThemeFontFamily {
  alibabaSans,
}

// 支持字体库扩展
extension ThemeFontFamilyExtension on ThemeFontFamily {
  // 获取名称
  String get fontFamily => {
        ThemeFontFamily.alibabaSans: 'AlibabaSans',
      }[this]!;
}
