import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/macos_platform.dart';

import 'platform.dart';

/*
* macos平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformMacOSPage
    extends BasePlatformPage<MacOSPlatform, _PlatformMacOSPageLogic> {
  PlatformMacOSPage({
    super.key,
    required super.platformInfo,
  }) : super(logic: _PlatformMacOSPageLogic(platformInfo.hashCode));

  @override
  State<StatefulWidget> createState() => _PlatformMacOSPageState();
}

/*
* macos平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformMacOSPageState extends BasePlatformPageState<PlatformMacOSPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }
}

/*
* macos平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformMacOSPageLogic extends BasePlatformPageLogic {
  _PlatformMacOSPageLogic(super.hashCode);
}
