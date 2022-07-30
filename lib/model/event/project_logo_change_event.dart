import 'package:flutter_platform_manage/model/event/base_event.dart';

/*
* 项目图标变化事件
* @author JTech JH
* @Time 2022-07-30 15:53:34
*/
class ProjectLogoChangeEvent extends BaseEvent {
  // 目标文件地址
  final String filePath;

  ProjectLogoChangeEvent(this.filePath);
}
