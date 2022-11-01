import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/route_path.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/project.dart';
import 'package:flutter_platform_manage/manager/router.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/project_rename_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_version_dialog.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:window_manager/window_manager.dart';

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
class _ProjectPageState extends State<ProjectPage> with WindowListener {
  // 逻辑管理
  final _logic = _ProjectPageLogic();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text('项目列表'),
        commandBar: _buildCommandBar(),
      ),
      content: CacheFutureBuilder<List<ProjectModel>>(
        controller: _logic.controller,
        future: () => projectManage.loadAll(simple: true),
        builder: (_, snap) {
          final value = snap.data;
          if (null != value && value.isNotEmpty) {
            return _buildProjectGrid(value);
          }
          return Center(
            child: NoticeBox.empty(
              message: '点击右上角添加一个项目',
            ),
          );
        },
      ),
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
            onPressed: () {
              ProjectImportDialog.show(context).then((v) {
                if (null != v) _logic.controller.refreshValue();
              });
            },
          ),
          CommandBarButton(
            icon: const Icon(FluentIcons.refresh),
            label: const Text('刷新'),
            onPressed: () {
              _logic.controller.refreshValue();
              Utils.showSnack(context, '项目信息已刷新');
            },
          ),
        ],
      ),
    );
  }

  // 构建项目列表
  Widget _buildProjectGrid(List<ProjectModel> projectList) {
    return ReorderableBuilder(
      scrollController: _logic.scrollController,
      onReorder: (entities) =>
          _logic.updateProjectListOrder(projectList, entities),
      builder: (children) => GridView(
        key: _logic.gridViewKey,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: Common.windowMinimumSize.width / 2,
          mainAxisExtent: 90,
          mainAxisSpacing: 8,
          crossAxisSpacing: 14,
        ),
        children: children,
      ),
      children: List.generate(
        projectList.length,
        (i) => _buildProjectGridItem(projectList[i]),
      ),
    );
  }

  // 构建项目表格子项
  Widget _buildProjectGridItem(ProjectModel item) {
    if (!item.project.isValid) return const SizedBox();
    return MouseRightClickMenu(
      key: ObjectKey(item.project.primaryKey),
      menuItems: _getProjectGirdItemMenuItems(item),
      child: Center(
        child: Card(
          child: !item.exist
              ? Center(
                  child: Text(
                  '项目信息丢失,点击重新编辑',
                  style: TextStyle(color: Colors.red),
                ))
              : _buildProjectGridItemContent(item),
        ),
      ),
    );
  }

  // 构建项目列表子项内容
  Widget _buildProjectGridItemContent(ProjectModel item) {
    return ListTile(
      leading: ProjectLogo(projectInfo: item),
      title: Text(
        item.showTitle,
        style: TextStyle(
          color: !item.exist ? Colors.red : null,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        'v${!item.exist ? item.project.alias : item.version}'
        ' · Flutter ${item.environment?.flutter}',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      onPressed: () {
        if (!item.exist) return _showModifyProjectDialog(item);
        jRouter.pushNamed(RoutePath.projectDetail, parameters: {
          'key': item.project.primaryKey,
        })?.then((_) => _logic.controller.refreshValue());
      },
    );
  }

  // 获取项目列表子项右键菜单项
  List<Widget> _getProjectGirdItemMenuItems(ProjectModel item) => [
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
              projectModel: item,
            ).then((v) {
              if (null != v) _logic.controller.refreshValue();
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
              projectModel: item,
            ).then((v) {
              if (null != v) _logic.controller.refreshValue();
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
                dbManage.delete(item.project);
                _logic.controller.refreshValue();
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
    ).then((v) {
      if (null != v) _logic.controller.refreshValue();
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
* 项目页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 14:33
*/
class _ProjectPageLogic extends BaseLogic {
  // 异步加载控制器
  final controller = CacheFutureBuilderController<List<ProjectModel>>();

  // 滚动控制器
  final scrollController = ScrollController();

  // grid Key
  final gridViewKey = GlobalKey();

  // 更新项目列表排序
  void updateProjectListOrder(
      List<ProjectModel> projectList, List<OrderUpdateEntity> entities) {
    for (final entity in entities) {
      final item = projectList.removeAt(entity.oldIndex);
      projectList.insert(entity.newIndex, item);
    }
    dbManage.write((realm) {
      for (var i = 0; i < projectList.length; i++) {
        projectList[i].project.order = i;
      }
    });
  }
}
