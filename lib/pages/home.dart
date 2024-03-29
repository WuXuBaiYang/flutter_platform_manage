import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/pages/package/index.dart';
import 'package:flutter_platform_manage/pages/project/index.dart';
import 'package:flutter_platform_manage/pages/setting/index.dart';
import 'package:flutter_platform_manage/widgets/app_page.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/widgets/dialog/windows_close.dart';
import 'package:window_manager/window_manager.dart';

/*
* 首页
* @author wuxubaiyang
* @Time 2022/5/12 12:49
*/
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/*
* 首页-状态
* @author wuxubaiyang
* @Time 2022/5/12 12:49
*/
class _HomePageState extends LogicState<HomePage, _HomePageLogic>
    with WindowListener {
  @override
  _HomePageLogic initLogic() => _HomePageLogic();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: logic.navigationIndex,
      builder: (_, value, child) {
        return AppPage(
          title: Common.appName,
          showBack: false,
          pane: NavigationPane(
            selected: value,
            onChanged: (v) => logic.navigationIndex.setValue(v),
            size: const NavigationPaneSize(
              openMinWidth: 120,
              openMaxWidth: 160,
            ),
            header: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 100,
            ),
            indicator: const StickyNavigationIndicator(
              duration: Duration(milliseconds: 120),
            ),
            items: _navigationItems,
            footerItems: _navigationFooterItems,
          ),
        );
      },
    );
  }

  // 导航项
  final List<NavigationPaneItem> _navigationItems = [
    PaneItem(
      icon: const Icon(FluentIcons.project_management),
      title: const Text('项目管理'),
      body: const ProjectPage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.packages),
      title: const Text('打包管理'),
      body: const PackagePage(),
    )
  ];

  // 导航底部项
  final List<NavigationPaneItem> _navigationFooterItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.settings),
      title: const Text('设置'),
      body: const SettingPage(),
    ),
  ];

  @override
  void onWindowClose() {
    // 弹出窗口关闭弹窗
    WindowsCloseDialog.show(context);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}

/*
* 首页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 13:55
*/
class _HomePageLogic extends BaseLogic {
  // 导航当前下标
  final navigationIndex = ValueChangeNotifier(0);

  @override
  void dispose() {
    navigationIndex.dispose();
    super.dispose();
  }
}
