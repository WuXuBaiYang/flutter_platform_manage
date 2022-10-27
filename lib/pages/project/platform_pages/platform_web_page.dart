import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/web_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* web平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWebPage extends BasePlatformPage<WebPlatform> {
  const PlatformWebPage({
    Key? key,
    required WebPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

  @override
  State<StatefulWidget> createState() => _PlatformWebPageState();
}

/*
* web平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformWebPageState extends BasePlatformPageState<PlatformWebPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }
}
