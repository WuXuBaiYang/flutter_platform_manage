import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/linux.dart';
import 'platform.dart';

/*
* linux平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformLinuxPage extends BasePlatformPage<LinuxPlatform> {
  const PlatformLinuxPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformLinuxPageState();
}

/*
* linux平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformLinuxPageState
    extends BasePlatformPageState<PlatformLinuxPage, _PlatformLinuxPageLogic> {
  @override
  _PlatformLinuxPageLogic initialLogic() =>
      _PlatformLinuxPageLogic(widget.platformInfo);

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
class _PlatformLinuxPageLogic extends BasePlatformPageLogic<LinuxPlatform> {
  _PlatformLinuxPageLogic(super.platformInfo);
}
