import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/windows_platform.dart';

import 'platform.dart';

/*
* win平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWinPage
    extends BasePlatformPage<WindowsPlatform, _PlatformWinPageLogic> {
  PlatformWinPage({
    super.key,
    required super.platformInfo,
  }) : super(logic: _PlatformWinPageLogic(platformInfo.hashCode));

  @override
  State<StatefulWidget> createState() => _PlatformWinPageState();
}

/*
* win平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformWinPageState extends BasePlatformPageState<PlatformWinPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }
}

/*
* win平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:14
*/
class _PlatformWinPageLogic extends BasePlatformPageLogic {
  _PlatformWinPageLogic(super.hashCode);
}
