import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/macos_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* macos平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformMacOSPage extends BasePlatformPage<MacOSPlatform> {
  const PlatformMacOSPage({
    Key? key,
    required MacOSPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

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
