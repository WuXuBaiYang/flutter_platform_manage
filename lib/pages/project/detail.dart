import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/router.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/app_page.dart';
import 'package:flutter_platform_manage/utils/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/dialog/important_option.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/platform_tag_group.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_import.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_logo_manage.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_name_update.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_version_update.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'platforms/android.dart';
import 'platforms/ios.dart';
import 'platforms/linux.dart';
import 'platforms/macos.dart';
import 'platforms/web.dart';
import 'platforms/win.dart';

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
class _ProjectDetailPageState
    extends LogicState<ProjectDetailPage, _ProjectDetailPageLogic> {
  @override
  _ProjectDetailPageLogic initLogic() => _ProjectDetailPageLogic();

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '项目详情',
      content: ScaffoldPage.withPadding(
        content: CacheFutureBuilder<ProjectModel>(
          controller: logic.projectController,
          future: () => logic.loadProjectInfo(context),
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
          Expanded(child: _buildProjectInfoItem(item)),
          const ThicknessDivider(
            size: 70,
            direction: Axis.vertical,
          ),
          Expanded(child: _buildProjectInfoMenus(item)),
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
          leading: ProjectLogo(
            projectIcon: item.projectIcon,
          ),
          title: Text(
            !item.exist ? '项目信息丢失' : item.showTitle,
            style: TextStyle(
              color: !item.exist ? Colors.red : null,
              fontWeight: FontWeight.bold,
              fontSize: 18,
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

  // 构建项目信息菜单列表
  Widget _buildProjectInfoMenus(ProjectModel item) {
    return Column(
      children: [
        CommandBar(
          mainAxisAlignment: MainAxisAlignment.start,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text('替换图标'),
              onPressed: () => ProjectLogoManageDialog.show(
                context,
                initialPlatforms: item.platformList,
                minFileSize: const Size.square(1024),
              ),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text('修改版本号'),
              onPressed: () => ProjectVersionUpdateDialog.show(
                context,
                initialProjectInfo: item,
              ).then((v) {
                if (null != v) logic.projectController.refreshValue();
              }),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text('修改项目名称'),
              onPressed: () => ProjectNameUpdateDialog.show(
                context,
                initialProjectInfo: item,
              ).then((v) {
                if (null != v) logic.projectController.refreshValue();
              }),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text('打开根目录'),
              onPressed: () => logic.openAppPath(item).then((v) {
                if (!v) Utils.showSnack(context, '目录启动失败');
              }),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text('应用打包'),
              onPressed: () {
                Utils.showSnack(context, '开发中');
              },
            ),
          ],
        ),
        CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.refresh),
              label: const Text('刷新'),
              onPressed: () {
                logic.projectController.refreshValue();
                Utils.showSnack(context, '项目信息已刷新');
              },
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.app_icon_default_edit),
              label: const Text('编辑'),
              onPressed: () => ProjectImportDialog.show(
                context,
                initialProject: item.project,
              ).then((v) {
                if (null != v) logic.projectController.refreshValue();
              }),
            ),
            CommandBarButton(
              icon: Icon(FluentIcons.delete, color: Colors.red),
              label: Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () => ImportantOptionDialog.show(
                context,
                message: '是否删除该项目 ${item.showTitle}',
                confirm: '删除',
                onConfirmTap: () => logic
                    .deleteProject(item)
                    .then((_) => Navigator.maybePop(context)),
              ),
            ),
          ],
        )
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
      valueListenable: logic.bottomBarIndex,
      builder: (_, v, child) {
        return IndexedStack(
          index: logic.bottomBarIndex.value,
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
                    onPressed: () => logic.createPlatform(context, item, t),
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
        valueListenable: logic.bottomBarIndex,
        builder: (_, v, child) {
          return BottomNavigation(
            index: v,
            onChanged: (i) => logic.bottomBarIndex.setValue(i),
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
}

/*
* 项目详情页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:14
*/
class _ProjectDetailPageLogic extends BaseLogic {
  // 异步缓存加载控制器
  final projectController = CacheFutureBuilderController<ProjectModel>();

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
      if (result ?? false) projectController.refreshValue();
    } catch (e) {
      Utils.showSnack(context, "平台创建失败");
    }
  }

  // 更新当前项目信息
  Future<ProjectModel> loadProjectInfo(BuildContext context) async {
    final id = jRouter.find<int>(context, 'id');
    if (null == id) throw Exception('项目id不能为空');
    final value = dbManage.loadProject(id);
    if (null == value) throw Exception('项目信息不存在');
    final project = ProjectModel(project: value);
    await project.update();
    return project;
  }

  @override
  void dispose() {
    projectController.dispose();
    bottomBarIndex.dispose();
    super.dispose();
  }

  // 打开项目根目录
  Future<bool> openAppPath(ProjectModel item) {
    final uri = Uri.parse('file:${item.project.path}');
    return launchUrl(uri);
  }

  // 删除项目信息
  Future<bool> deleteProject(ProjectModel item) {
    final id = item.project.id;
    return dbManage.deleteProject(id);
  }
}
