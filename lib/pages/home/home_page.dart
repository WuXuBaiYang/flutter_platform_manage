import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/pages/project/project_list.dart';
import 'package:flutter_platform_manage/pages/record/package_record.dart';
import 'package:flutter_platform_manage/pages/setting/setting.dart';
import 'package:flutter_platform_manage/widgets/app_page.dart';
import 'package:flutter_platform_manage/widgets/windows_close_dialog.dart';
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
class _HomePageState extends State<HomePage> with WindowListener {
  // 导航当前下标
  final navigationIndex = ValueNotifier(0);

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: navigationIndex,
      builder: (_, value, child) {
        return AppPage(
          title: Common.appName,
          showBack: false,
          pane: NavigationPane(
            selected: value,
            onChanged: (v) => navigationIndex.value = v,
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
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.project_management),
                title: const Text('项目管理'),
                body: const ProjectListPage(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.packages),
                title: const Text('打包记录'),
                body: const PackageRecordPage(),
              )
            ],
            footerItems: [
              PaneItemSeparator(),
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('设置'),
                body: const SettingPage(),
              ),
            ],
          ),
        );
      },
    );
  }

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
