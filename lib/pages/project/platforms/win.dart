import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/windows.dart';

import 'platform.dart';

/*
* win平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWinPage extends BasePlatformPage<WindowsPlatform> {
  const PlatformWinPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformWinPageState();
}

/*
* win平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformWinPageState
    extends BasePlatformPageState<PlatformWinPage, _PlatformWinPageLogic> {
  @override
  _PlatformWinPageLogic initLogic() =>
      _PlatformWinPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildAppLogo(),
      if (Platform.isWindows) buildPackage(),
    ];
  }
}

/*
* win平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:14
*/
class _PlatformWinPageLogic extends BasePlatformPageLogic<WindowsPlatform> {
  _PlatformWinPageLogic(super.platformInfo);
}
