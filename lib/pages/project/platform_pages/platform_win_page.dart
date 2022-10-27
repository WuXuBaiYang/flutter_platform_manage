import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/windows_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* win平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWinPage extends BasePlatformPage<WindowsPlatform> {
  const PlatformWinPage({
    Key? key,
    required WindowsPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

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
