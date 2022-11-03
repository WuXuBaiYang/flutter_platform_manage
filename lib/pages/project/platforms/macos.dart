import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/macos.dart';

import 'platform.dart';

/*
* macos平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformMacOSPage extends BasePlatformPage<MacOSPlatform> {
  const PlatformMacOSPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformMacOSPageState();
}

/*
* macos平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformMacOSPageState
    extends BasePlatformPageState<PlatformMacOSPage, _PlatformMacOSPageLogic> {
  @override
  _PlatformMacOSPageLogic initLogic() =>
      _PlatformMacOSPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildAppLogo(),
    ];
  }
}

/*
* macos平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformMacOSPageLogic extends BasePlatformPageLogic<MacOSPlatform> {
  _PlatformMacOSPageLogic(super.platformInfo);
}
