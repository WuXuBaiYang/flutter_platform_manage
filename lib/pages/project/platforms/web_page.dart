import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/web_platform.dart';
import 'platform.dart';

/*
* web平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWebPage
    extends BasePlatformPage<WebPlatform, _PlatformWebPageLogic> {
  PlatformWebPage({
    super.key,
    required super.platformInfo,
  }) : super(logic: _PlatformWebPageLogic(platformInfo.hashCode));

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

/*
* web平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformWebPageLogic extends BasePlatformPageLogic {
  _PlatformWebPageLogic(super.hashCode);
}
