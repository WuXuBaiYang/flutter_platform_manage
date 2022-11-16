import 'package:flutter_platform_manage/model/event/event.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';

/*
* 项目打包事件
* @author wuxubaiyang
* @Time 2022/11/3 15:41
*/
class ProjectPackageEvent extends BaseEvent {
  // 传入平台类型
  final PlatformType type;

  ProjectPackageEvent(this.type);
}
