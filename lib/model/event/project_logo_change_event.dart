import 'package:flutter_platform_manage/model/event/base_event.dart';

/*
* 项目图标变化事件
* @author JTech JH
* @Time 2022-07-30 15:53:34
*/
class ProjectLogoChangeEvent extends BaseEvent {
  // 批量修改的图标地址集合
  final List<String> filePaths;

  ProjectLogoChangeEvent(this.filePaths);
}
