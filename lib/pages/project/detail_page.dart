import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/manager/router_manage.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/project/menu.dart';
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

import 'platforms/android_page.dart';
import 'platforms/ios_page.dart';
import 'platforms/linux_page.dart';
import 'platforms/macos_page.dart';
import 'platforms/web_page.dart';
import 'platforms/win_page.dart';

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
  // 逻辑管理
  final _logic = _ProjectDetailPageLogic();

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
          controller: _logic.controller,
          future: () => _logic.loadProjectInfo(context),
          builder: (_, snap) {
            if (snap.hasData) {
              final item = snap.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProjectInfo(item),
                  const SizedBox(height: 14),
                  Expanded(child: _buildPlatformView(item)),
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
        bottomBar: _buildBottomBar(),
      ),
    );
  }

  // 构建项目信息
  Widget _buildProjectInfo(ProjectModel item) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildProjectInfoItem(item),
          ),
          const ThicknessDivider(
            size: 70,
            direction: Axis.vertical,
          ),
          Expanded(
            child: ProjectMenu.getProjectCommands(
                context, item, _logic.controller),
          ),
        ],
      ),
    );
  }

  // 构建项目信息子项
  Widget _buildProjectInfoItem(ProjectModel item) {
    return Column(
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
          subtitle: Text('${!item.exist ? item.project.alias : item.version}'
              '\nFlutter · ${item.environment?.flutter}'),
        ),
        const SizedBox(height: 4),
        PlatformTagGroup(
          platforms: item.platformList,
          tagSize: PlatformTagSize.small,
        ),
      ],
    );
  }

  // 平台对照表
  final Map<PlatformType, PlatformPageBuilder> _platformPage = {
    PlatformType.android: (p) => PlatformAndroidPage(platformInfo: p),
    PlatformType.ios: (p) => PlatformIosPage(platformInfo: p),
    PlatformType.web: (p) => PlatformWebPage(platformInfo: p),
    PlatformType.windows: (p) => PlatformWinPage(platformInfo: p),
    PlatformType.linux: (p) => PlatformLinuxPage(platformInfo: p),
    PlatformType.macos: (p) => PlatformMacOSPage(platformInfo: p),
  };

  // 构建平台信息切页
  Widget _buildPlatformView(ProjectModel item) {
    return ValueListenableBuilder<int>(
      valueListenable: _logic.bottomBarIndex,
      builder: (_, v, child) {
        return IndexedStack(
          index: _logic.bottomBarIndex.value,
          children: List.generate(PlatformType.values.length, (i) {
            final t = PlatformType.values[i];
            final p = item.platformMap[t];
            if (null != p) return _platformPage[t]!(p);
            return Center(
              child: CommandBar(
                mainAxisAlignment: MainAxisAlignment.center,
                primaryItems: [
                  CommandBarButton(
                    icon: const Icon(FluentIcons.add),
                    label: const Text('创建平台'),
                    onPressed: () => _logic.createPlatform(context, item, t),
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
  Widget _buildBottomBar() {
    const iconSize = 24.0;
    final style = BottomNavigationTheme.of(context);
    return ValueListenableBuilder<int>(
        valueListenable: _logic.bottomBarIndex,
        builder: (_, v, child) {
          return BottomNavigation(
            index: v,
            onChanged: (i) => _logic.bottomBarIndex.setValue(i),
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

  @override
  void dispose() {
    windowManager.removeListener(this);
    _logic.dispose();
    super.dispose();
  }
}

/*
* 项目详情页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:14
*/
class _ProjectDetailPageLogic extends BaseLogic {
  // 异步缓存加载控制器
  final controller = CacheFutureBuilderController<ProjectModel>();

  // 底部导航条当前下标
  final bottomBarIndex = ValueChangeNotifier<int>(0);

  // 创建平台
  Future<void> createPlatform(
      BuildContext context, ProjectModel item, PlatformType platform) async {
    try {
      final projectDir = item.project.path.split(RegExp(r'[\\/]')).last;
      if (!RegExp(r'^\w+$').hasMatch(projectDir)) {
        Utils.showSnack(context, '创建失败，本地目录名称只能使用字母数字下划线');
        return;
      }
      final result = await Utils.showLoading<bool>(
        context,
        loadFuture: ScriptHandle.createPlatforms(item, [platform]),
      );
      if (result ?? false) controller.refreshValue();
    } catch (e) {
      Utils.showSnack(context, "平台创建失败");
    }
  }

  // 更新当前项目信息
  Future<ProjectModel> loadProjectInfo(BuildContext context) async {
    final key = jRouter.find<String>(context, 'key');
    if (null == key || key.isEmpty) throw Exception('项目key不能为空');
    final value = await projectManage.getProjectInfo(key);
    if (null == value) throw Exception('项目信息不存在');
    return Future.value(value);
  }
}
