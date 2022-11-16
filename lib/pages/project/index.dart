import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/route_path.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/router.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/dialog/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_rename_dialog.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_version_dialog.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

/*
* 项目页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectPageState();
}

/*
* 项目页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _ProjectPageState extends LogicState<ProjectPage, _ProjectPageLogic> {
  @override
  _ProjectPageLogic initLogic() => _ProjectPageLogic();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text('项目列表'),
        commandBar: _buildCommandBar(),
      ),
      content: StreamBuilder(
        stream: dbManage.watchProjectList(
          fireImmediately: true,
        ),
        builder: (_, snap) => _buildProjectGrid(),
      ),
    );
  }

  // 构建项目列表
  Widget _buildProjectGrid() {
    return FutureBuilder<List<ProjectModel>>(
      future: dbManage.loadAllProjectInfos(),
      builder: (c, snap) {
        final list = snap.data ?? [];
        if (snap.hasData && list.isNotEmpty) {
          return ReorderableBuilder(
            scrollController: logic.scrollController,
            onReorder: (entities) =>
                logic.updateProjectListOrder(list, entities),
            builder: (children) => GridView(
              key: logic.gridViewKey,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: Common.windowMinimumSize.width / 2,
                mainAxisExtent: 90,
                mainAxisSpacing: 8,
                crossAxisSpacing: 14,
              ),
              children: children,
            ),
            children: List.generate(
              list.length,
              (i) => _buildProjectGridItem(c, list[i]),
            ),
          );
        }
        return Center(
          child: NoticeBox.empty(
            message: '点击右上角添加一个项目',
          ),
        );
      },
    );
  }

  // 构建项目表格子项
  Widget _buildProjectGridItem(BuildContext context, ProjectModel item) {
    return MouseRightClickMenu(
      key: ObjectKey(item.project.id),
      menuItems: _getProjectMenuItems(context, item),
      child: Center(
        child: GestureDetector(
          child: Card(
            child: !item.exist
                ? Center(
                    child: Text(
                    '项目信息丢失,点击重新编辑',
                    style: TextStyle(color: Colors.red),
                  ))
                : _buildProjectGridItemContent(item),
          ),
          onTap: () {
            if (!item.exist) return _showModifyProjectDialog(item);
            jRouter.pushNamed(RoutePath.projectDetail, parameters: {
              'id': item.project.id,
            })?.then((_) => setState(() {}));
          },
        ),
      ),
    );
  }

  // 构建项目列表子项内容
  Widget _buildProjectGridItemContent(ProjectModel item) {
    return Row(
      children: [
        ProjectLogo(
          projectIcon: item.projectIcon,
        ),
        const SizedBox(width: 14),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.showTitle,
              style: TextStyle(
                color: !item.exist ? Colors.red : null,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              'v${!item.exist ? item.project.alias : item.version}'
              ' · Flutter ${item.environment?.flutter}',
              style: TextStyle(
                color: Colors.grey[120],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ],
    );
  }

  // 获取项目列表子项右键菜单项
  List<Widget> _getProjectMenuItems(BuildContext context, ProjectModel item) =>
      [
        ListTile(
          leading: const Icon(
            FluentIcons.rename,
            size: 14,
          ),
          title: const Text('项目名称'),
          onPressed: () {
            Navigator.pop(context);
            ProjectReNameDialog.show(
              context,
              initialProjectInfo: item,
            ).then((v) {
              if (null != v) setState(() {});
            });
          },
        ),
        ListTile(
          leading: const Icon(
            FluentIcons.version_control_push,
            size: 14,
          ),
          title: const Text('版本号'),
          onPressed: () {
            Navigator.pop(context);
            ProjectVersionDialog.show(
              context,
              initialProjectInfo: item,
            ).then((v) {
              if (null != v) setState(() {});
            });
          },
        ),
        ListTile(
          leading: const Icon(
            FluentIcons.app_icon_default_edit,
            size: 14,
          ),
          title: const Text('编辑'),
          onPressed: () {
            Navigator.pop(context);
            _showModifyProjectDialog(item);
          },
        ),
        ListTile(
          leading: Icon(
            FluentIcons.delete,
            size: 14,
            color: Colors.red,
          ),
          title: Text(
            '删除',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.pop(context);
            ImportantOptionDialog.show(
              context,
              message: '是否删除该项目 ${item.showTitle}',
              confirm: '删除',
              onConfirmTap: () {
                final id = item.project.id;
                dbManage.deleteProject(id);
              },
            );
          },
        ),
      ];

  // 展示编辑项目信息弹窗
  void _showModifyProjectDialog(ProjectModel item) {
    ProjectImportDialog.show(
      context,
      initialProject: item.project,
    );
  }

  // 构建动作菜单
  Widget _buildCommandBar() {
    return CommandBarCard(
      child: CommandBar(
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
        primaryItems: [
          CommandBarButton(
            icon: const Icon(FluentIcons.add),
            label: const Text('添加'),
            onPressed: () => ProjectImportDialog.show(context),
          ),
          const CommandBarSeparator(),
          CommandBarButton(
            icon: const Icon(FluentIcons.refresh),
            label: const Text('刷新'),
            onPressed: () => setState(() {
              Utils.showSnack(context, '项目信息已刷新');
            }),
          ),
        ],
      ),
    );
  }
}

/*
* 项目页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 14:33
*/
class _ProjectPageLogic extends BaseLogic {
  // 滚动控制器
  final scrollController = ScrollController();

  // grid Key
  final gridViewKey = GlobalKey();

  // 更新项目列表排序
  void updateProjectListOrder(
    List<ProjectModel> projectList,
    List<OrderUpdateEntity> entities,
  ) {
    for (final entity in entities) {
      final item = projectList.removeAt(entity.oldIndex);
      projectList.insert(entity.newIndex, item);
    }
    var i = 0;
    dbManage.updateProjects(projectList.map((e) {
      return e.project..order = i++;
    }).toList());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
