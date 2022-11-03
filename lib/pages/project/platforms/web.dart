import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/web.dart';
import 'platform.dart';

/*
* web平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWebPage extends BasePlatformPage<WebPlatform> {
  const PlatformWebPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformWebPageState();
}

/*
* web平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformWebPageState
    extends BasePlatformPageState<PlatformWebPage, _PlatformWebPageLogic> {
  @override
  _PlatformWebPageLogic initLogic() =>
      _PlatformWebPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildAppLogo(),
    ];
  }
}

/*
* web平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformWebPageLogic extends BasePlatformPageLogic<WebPlatform> {
  _PlatformWebPageLogic(super.platformInfo);
}
