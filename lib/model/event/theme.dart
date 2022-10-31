import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/event/event.dart';

/*
* 全局样式控制事件
* @author wuxubaiyang
* @Time 2022/4/1 15:14
*/
class ThemeEvent extends BaseEvent {
  // 全局样式类型
  final ThemeType themeType;

  const ThemeEvent({required this.themeType});
}
