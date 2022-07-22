import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/route_path.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/manager/router_manage.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/platform_chip_group.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:window_manager/window_manager.dart';

/*
* 项目列表页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectListPageState();
}

/*
* 项目列表页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _ProjectListPageState extends State<ProjectListPage> with WindowListener {
  // 项目列表
  late List<ProjectModel> projectList = [];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    // 加载项目列表
    updateProjectList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text("项目列表"),
        commandBar: buildCommandBar(),
      ),
      content: projectList.isEmpty
          ? Center(
              child: NoticeBox.empty(
              message: "点击右上角添加一个项目",
            ))
          : buildProjectGrid(),
    );
  }

  // 构建动作菜单
  Widget buildCommandBar() {
    return CommandBar(
      overflowBehavior: CommandBarOverflowBehavior.noWrap,
      primaryItems: [
        CommandBarButton(
          icon: const Icon(FluentIcons.add),
          label: const Text("添加"),
          onPressed: () {
            ProjectImportDialog.show(context).then((v) {
              if (null != v) updateProjectList();
            });
          },
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.refresh),
          label: const Text("刷新"),
          onPressed: () => updateProjectList().then((_) =>
              showSnackbar(context, const Snackbar(content: Text("项目信息已刷新")))),
        ),
      ],
    );
  }

  // 滚动控制器
  final _scrollController = ScrollController();

  // grid Key
  final _gridViewKey = GlobalKey();

  // 构建项目列表
  Widget buildProjectGrid() {
    return ReorderableBuilder(
      scrollController: _scrollController,
      onReorder: (entities) {
        for (final entity in entities) {
          final item = projectList.removeAt(entity.oldIndex);
          projectList.insert(entity.newIndex, item);
        }
        dbManage.write((realm) {
          for (var i = 0; i < projectList.length; i++) {
            projectList[i].project.order = i;
          }
        });
      },
      builder: (children) => GridView(
        key: _gridViewKey,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: Common.windowMinimumSize.width / 2,
          mainAxisExtent: 120,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
        children: children,
      ),
      children: List.generate(
        projectList.length,
        (i) => buildProjectGridItem(projectList[i]),
      ),
    );
  }

  // 构建项目表格子项
  Widget buildProjectGridItem(ProjectModel item) {
    return MouseRightClickMenu(
      key: Key(item.project.primaryKey),
      menuItems: [
        TappableListTile(
          leading: const Icon(FluentIcons.app_icon_default_edit, size: 14),
          title: const Text("编辑"),
          onTap: () {
            Navigator.pop(context);
            modifyProjectInfo(item);
          },
        ),
        TappableListTile(
          leading: Icon(FluentIcons.delete, size: 14, color: Colors.red),
          title: Text(
            "删除",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            Navigator.pop(context);
            ImportantOptionDialog.show(
              context,
              message: "是否删除该项目(${item.getShowTitle()})",
              confirm: "删除",
              onConfirmTap: () {
                dbManage.delete(item.project);
                updateProjectList();
              },
            );
          },
        ),
      ],
      child: GestureDetector(
        onTapDown: (details) {
          if (!item.exist) return modifyProjectInfo(item);
          jRouter.pushNamed(RoutePath.projectDetail, parameters: {
            "key": item.project.primaryKey,
          })?.then((_) => updateProjectList());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xe0F6F6F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                isThreeLine: true,
                contentPadding: EdgeInsets.zero,
                leading: buildProjectGridItemIcon(item),
                title: Text(
                  !item.exist ? "项目信息丢失" : item.getShowTitle(),
                  style: TextStyle(
                    color: !item.exist ? Colors.red : null,
                  ),
                ),
                subtitle: Text(!item.exist ? item.project.alias : item.version),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: PlatformChipGroup(
                  platforms: item.platforms,
                  chipSize: PlatformChipSize.small,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 图标尺寸
  final double iconSize = 50;

  // 构造项目图标
  Widget buildProjectGridItemIcon(ProjectModel item) {
    if (!item.exist) {
      return Icon(
        FluentIcons.warning,
        color: Colors.red,
        size: iconSize,
      );
    }
    var iconMap = item.getProjectIcon();
    if (iconMap.isEmpty) return FlutterLogo(size: iconSize);
    var icon = iconMap.entries.first;
    return Image.file(
      File(icon.value),
      width: iconSize,
      height: iconSize,
    );
  }

  // 重新编辑项目信息
  void modifyProjectInfo(ProjectModel item) {
    ProjectImportDialog.show(
      context,
      project: item.project,
    ).then((v) {
      if (null != v) updateProjectList();
    });
  }

  // 更新现有项目列表
  Future<List<ProjectModel>> updateProjectList() {
    return projectManage.loadAll().then((v) {
      setState(() => projectList = v);
      return v;
    });
  }

  @override
  void onWindowFocus() {
    updateProjectList();
  }

  @override
  void onWindowRestore() {
    updateProjectList();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
