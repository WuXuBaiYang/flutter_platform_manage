import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/manager/router_manage.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_android_page.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_ios_page.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_linux_page.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_macos_page.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_web_page.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/platform_win_page.dart';
import 'package:flutter_platform_manage/pages/project/project_command_menu.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/app_page.dart';
import 'package:flutter_platform_manage/widgets/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/platform_tag_group.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

/*
* 项目详情页
* @author wuxubaiyang
* @Time 2022-07-22 11:38:04
*/
class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectDetailPageState();
}

// 构造平台页面方法
typedef PlatformPageBuilder = Widget Function(dynamic platformInfo);

/*
* 项目详情页-状态
* @author wuxubaiyang
* @Time 2022-07-22 11:38:37
*/
class _ProjectDetailPageState extends State<ProjectDetailPage>
    with WindowListener {
  // 异步缓存加载控制器
  final controller = CacheFutureBuilderController<ProjectModel>();

  // 底部导航条当前下标
  final bottomBarIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '项目详情',
      content: ScaffoldPage.withPadding(
        content: CacheFutureBuilder<ProjectModel>(
          controller: controller,
          future: loadProjectInfo,
          builder: (_, snap) {
            if (snap.hasData) {
              final item = snap.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildProjectInfo(item),
                  const SizedBox(height: 14),
                  Expanded(child: buildPlatformView(item)),
                ],
              );
            }
            if (snap.hasError) {
              return NoticeBox.warning(
                message: snap.error.toString(),
              );
            }
            return const Center(child: ProgressRing());
          },
        ),
        bottomBar: buildBottomBar(),
      ),
    );
  }

  // 构建项目信息
  Widget buildProjectInfo(ProjectModel item) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: ProjectLogo(projectInfo: item),
                  title: Text(
                    !item.exist ? '项目信息丢失' : item.showTitle,
                    style: TextStyle(
                      color: !item.exist ? Colors.red : null,
                    ),
                  ),
                  subtitle:
                      Text('${!item.exist ? item.project.alias : item.version}'
                          '\nFlutter · ${item.environment?.flutter}'),
                ),
                const SizedBox(height: 4),
                PlatformTagGroup(
                  platforms: item.platformList,
                  tagSize: PlatformTagSize.small,
                ),
              ],
            ),
          ),
          const ThicknessDivider(
            size: 70,
            direction: Axis.vertical,
          ),
          Expanded(
            child: ProjectCommandMenu.getProjectCommands(
                context, item, controller),
          ),
        ],
      ),
    );
  }

  // 平台对照表
  final Map<PlatformType, PlatformPageBuilder> platformPage = {
    PlatformType.android: (p) => PlatformAndroidPage(platformInfo: p),
    PlatformType.ios: (p) => PlatformIosPage(platformInfo: p),
    PlatformType.web: (p) => PlatformWebPage(platformInfo: p),
    PlatformType.windows: (p) => PlatformWinPage(platformInfo: p),
    PlatformType.linux: (p) => PlatformLinuxPage(platformInfo: p),
    PlatformType.macos: (p) => PlatformMacOSPage(platformInfo: p),
  };

  // 构建平台信息切页
  Widget buildPlatformView(ProjectModel item) {
    return ValueListenableBuilder<int>(
      valueListenable: bottomBarIndex,
      builder: (_, v, child) {
        return IndexedStack(
          index: bottomBarIndex.value,
          children: List.generate(PlatformType.values.length, (i) {
            final t = PlatformType.values[i];
            final p = item.platformMap[t];
            if (null != p) return platformPage[t]!(p);
            return Center(
              child: CommandBar(
                mainAxisAlignment: MainAxisAlignment.center,
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.add),
                    label: const Text('创建平台'),
                    onPressed: () {
                      final projectDir =
                          item.project.path.split(RegExp(r'[\\/]')).last;
                      if (!RegExp(r'^\w+$').hasMatch(projectDir)) {
                        Utils.showSnack(context, '创建失败，本地目录名称只能使用字母数字下划线');
                        return;
                      }
                      Utils.showLoading<bool>(
                        context,
                        loadFuture: ScriptHandle.createPlatforms(item, [t]),
                      ).then((value) {
                        if (value!) {
                          controller.refreshValue();
                          return Utils.showSnack(context, '平台创建成功');
                        }
                        throw Exception('平台创建失败');
                      }).catchError((e) {
                        Utils.showSnack(context, e.toString());
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // 构建底部导航
  Widget buildBottomBar() {
    const iconSize = 24.0;
    final style = BottomNavigationTheme.of(context);
    return ValueListenableBuilder<int>(
        valueListenable: bottomBarIndex,
        builder: (_, v, child) {
          return BottomNavigation(
            index: v,
            onChanged: (i) => bottomBarIndex.value = i,
            items: List.generate(PlatformType.values.length, (i) {
              final type = PlatformType.values[i];
              return BottomNavigationItem(
                icon: SvgPicture.asset(
                  type.platformImage,
                  color: v == i ? style.selectedColor : style.inactiveColor,
                  width: iconSize,
                  height: iconSize,
                ),
                title: Text(type.name),
              );
            }),
          );
        });
  }

  // 更新当前项目信息
  Future<ProjectModel> loadProjectInfo() async {
    final key = jRouter.find<String>(context, 'key');
    if (null == key || key.isEmpty) throw Exception('项目key不能为空');
    final value = await projectManage.getProjectInfo(key);
    if (null == value) throw Exception('项目信息不存在');
    return Future.value(value);
  }

  @override
  void onWindowFocus() {
    controller.refreshValue();
  }

  @override
  void onWindowRestore() {
    controller.refreshValue();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
