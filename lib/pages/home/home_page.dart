import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/pages/project/project_list.dart';
import 'package:flutter_platform_manage/pages/record/package_record.dart';
import 'package:flutter_platform_manage/pages/setting/setting.dart';
import 'package:flutter_platform_manage/widgets/window_buttons.dart';
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
  // 导航组件key
  final viewKey = GlobalKey();

  // 导航当前下标
  int index = 0;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: const DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("  ${Common.appName}"),
          ),
        ),
        actions: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Spacer(), WindowButtons()],
        ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (v) => setState(() => index = v),
        size: const NavigationPaneSize(
          openMinWidth: 120,
          openMaxWidth: 200,
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
            title: const Text("项目管理"),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.packages),
            title: const Text("打包记录"),
          )
        ],
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text("设置"),
          ),
        ],
      ),
      content: NavigationBody(
        index: index,
        children: const [
          ProjectListPage(),
          PackageRecordPage(),
          SettingPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    if (await windowManager.isPreventClose()) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text("关闭提醒"),
            content: const Text("确定要关闭应用吗？"),
            actions: [
              FilledButton(
                child: const Text("关闭"),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text("取消"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }
}
