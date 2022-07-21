import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/empty_box_notice.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/platform_chip_group.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';
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
              child: EmptyBoxNotice(
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

  // 控制列数量
  int gridCrossCount = 2;

  // 构建项目列表
  Widget buildProjectGrid() {
    return DraggableGridViewBuilder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 120,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        crossAxisCount: gridCrossCount,
      ),
      isOnlyLongPress: false,
      children: List.generate(projectList.length, (i) {
        var item = projectList[i];
        return DraggableGridItem(
          isDraggable: true,
          child: buildProjectGridItem(item),
        );
      }),
      dragCompletion: (list, beforeIndex, afterIndex) {
        dbManage.write((realm) {
          var it = projectList.removeAt(beforeIndex);
          projectList.insert(afterIndex, it);
          for (var i = 0; i < projectList.length; i++) {
            projectList[i].project.order = i;
          }
        });
      },
      dragFeedback: (list, i) {
        var item = projectList[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Chip(
            image: buildProjectGridItemIcon(item),
            text: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(item.getShowTitle()),
            ),
          ),
        );
      },
      dragPlaceHolder: (list, i) {
        return const PlaceHolderWidget(
          child: SizedBox(),
        );
      },
    );
  }

  // 构建项目表格子项
  Widget buildProjectGridItem(ProjectModel item) {
    return Listener(
      child: HoverButton(
        builder: (_, states) {
          states.add(ButtonStates.hovering);
          return RepaintBoundary(
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              duration: FluentTheme.of(context).fasterAnimationDuration,
              decoration: BoxDecoration(
                color: ButtonThemeData.uncheckedInputColor(
                  FluentTheme.of(context),
                  states,
                ),
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
                    subtitle:
                        Text(!item.exist ? item.project.alias : item.version),
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
          );
        },
        onPressed: () {
          if (!item.exist) return modifyProjectInfo(item);

          /// 跳转详情页
        },
      ),
      onPointerDown: (event) => onMouseRightClick(event, item),
    );
  }

  // 实现右键点击弹出菜单功能
  void onMouseRightClick(PointerEvent event, ProjectModel item) async {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)?.context.findRenderObject() as RenderBox;
      material
          .showMenu<int>(
              context: context,
              items: [
                const material.PopupMenuItem(
                  value: 0,
                  child: Text('编辑'),
                ),
                const material.PopupMenuItem(
                  value: 1,
                  child: Text(
                    '删除',
                    style: TextStyle(color: material.Colors.red),
                  ),
                ),
              ],
              position: RelativeRect.fromSize(
                event.position & const Size(48.0, 48.0),
                overlay.size,
              ))
          .then((v) {
        switch (v) {
          case 0: //编辑
            modifyProjectInfo(item);
            break;
          case 1: //删除
            ImportantOptionDialog.show(
              context,
              message: "是否删除该项目(${item.getShowTitle()})",
              confirm: "删除",
              onConfirmTap: () {
                dbManage.delete(item.project);
                updateProjectList();
              },
            );
            break;
        }
      });
    }
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
  void onWindowResize() {
    windowManager.getSize().then((v) {
      var count = v.width ~/ (Common.windowMinimumSize.width ~/ 2);
      if (gridCrossCount != count) {
        setState(() => gridCrossCount = count);
      }
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
