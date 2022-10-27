import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/linux_platform.dart';
import 'platform.dart';

/*
* linux平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformLinuxPage
    extends BasePlatformPage<LinuxPlatform, _PlatformLinuxPageLogic> {
  PlatformLinuxPage({
    super.key,
    required super.platformInfo,
  }) : super(logic: _PlatformLinuxPageLogic(platformInfo.hashCode));

  @override
  State<StatefulWidget> createState() => _PlatformLinuxPageState();
}

/*
* linux平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformLinuxPageState extends BasePlatformPageState<PlatformLinuxPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }
}

/*
* linux平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:12
*/
class _PlatformLinuxPageLogic extends BasePlatformPageLogic {
  _PlatformLinuxPageLogic(super.hashCode);
}
