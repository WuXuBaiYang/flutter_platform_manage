import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/pages/package/index.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'package:flutter_platform_manage/widgets/value_listenable_builder.dart';

/*
* 打包任务页
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class PackageTaskPage extends StatefulWidget {
  // 加载项目信息缓存回调
  final OnProjectCacheLoad onProjectCacheLoad;

  const PackageTaskPage({
    Key? key,
    required this.onProjectCacheLoad,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PackageTaskPageState();
}

/*
* 打包任务页-状态
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackageTaskPageState
    extends LogicState<PackageTaskPage, _PackageTaskPageLogic> {
  @override
  _PackageTaskPageLogic initLogic() => _PackageTaskPageLogic(
        widget.onProjectCacheLoad,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.scaffoldBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          title: StreamBuilder(
            stream: dbManage.watchPackageTaskList(
              fireImmediately: true,
            ),
            builder: (_, snap) {
              final count = dbManage.getPackageTaskCount();
              return Text('共 $count 个任务');
            },
          ),
          commandBar: ValueListenableBuilder<bool>(
            valueListenable: logic.editorController,
            builder: (_, isEditor, __) {
              if (isEditor) return _buildEditorCommandBar(context);
              return _buildCommandBar(context);
            },
          ),
        ),
        content: _buildTaskList(context),
      ),
    );
  }

  // 构建操作菜单
  Widget _buildCommandBar(BuildContext context) {
    return CommandBarCard(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: CommandBar(
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
        primaryItems: [
          const CommandBarSeparator(),
          CommandBarButton(
            label: const Text('编辑'),
            icon: const Icon(FluentIcons.edit),
            onPressed: () => logic.editorController.setValue(true),
          ),
        ],
      ),
    ));
  }

  // 构建编辑操作菜单
  Widget _buildEditorCommandBar(BuildContext context) {
    return CommandBarCard(
      child: ValueListenableBuilder<List<int>>(
        valueListenable: logic.selectedController,
        builder: (_, selectList, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: CommandBar(
              overflowBehavior: CommandBarOverflowBehavior.noWrap,
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.back),
                  onPressed: () => logic.editorController.setValue(false),
                ),
                if (logic.hasSelected) ...[
                  const CommandBarSeparator(),
                  CommandBarButton(
                    icon: Icon(
                      FluentIcons.delete,
                      color: Colors.red,
                    ),
                    label: Text(
                      '(${selectList.length})',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: logic.deleteAllSelected,
                  ),
                  const CommandBarSeparator(),
                  CommandBarButton(
                    icon: const Icon(FluentIcons.clear_selection_mirrored),
                    onPressed: () => logic.editorController.setValue(false),
                  ),
                ],
                const CommandBarSeparator(),
                CommandBarButton(
                  icon: Checkbox(
                    checked: logic.hasPageAllSelected,
                    onChanged: (v) => logic.pageAllSelected(!(v ?? false)),
                  ),
                  onPressed: null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 构建任务列表
  Widget _buildTaskList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ValueListenableBuilder3<List<PackageModel>, List<int>, bool>(
        first: logic.taskListController,
        second: logic.selectedController,
        third: logic.editorController,
        builder: (_, recordList, selectList, isEdited, __) {
          return ListView.builder(
            itemExtent: 75,
            itemBuilder: (_, i) {
              final item = recordList[i];
              return MouseRightClickMenu(
                key: ObjectKey(item.package.id),
                menuItems: _getTaskItemMenus(context, item),
                child: _buildTaskListItem(context, item, isEdited, i),
              );
            },
            itemCount: recordList.length,
          );
        },
      ),
    );
  }

  // 构建打包任务列表子项
  Widget _buildTaskListItem(
      BuildContext context, PackageModel item, bool isEdited, int index) {
    final id = item.package.id;
    final project = item.projectInfo;
    final checked = logic.hasItemSelected(id);
    final env = project?.environment;
    return Column(
      children: [
        ListTile.selectable(
          leading: ProjectLogo(
            projectIcon: item.projectInfo?.projectIcon,
          ),
          title: project == null
              ? const Text(
                  '项目信息丢失',
                  style: TextStyle(color: Common.warningColor),
                )
              : Text('${project.showTitle}  ·  ${item.completeTime}'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                ..._buildTaskListItemInfo(
                    FluentIcons.bullseye, item.package.platform.name),
                ..._buildTaskListItemInfo(FluentIcons.timer, item.timeSpent),
                ..._buildTaskListItemInfo(
                    FluentIcons.classroom_logo, item.packageSize),
                if (env != null)
                  ..._buildTaskListItemInfo(
                      FluentIcons.device_run, 'v${env.flutter}'),
              ],
            ),
          ),
          trailing: Visibility(
            visible: isEdited,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 7),
              child: Checkbox(
                checked: checked,
                onChanged: (v) => logic.itemSelected(checked, id),
              ),
            ),
          ),
          selected: checked,
          onPressed: () => logic.itemSelected(checked, id),
        ),
        const SizedBox(height: 4),
        const ThicknessDivider(),
      ],
    );
  }

  // 构建任务列表子项的详细信息构造
  List<Widget> _buildTaskListItemInfo(IconData icon, String text) => [
        Icon(icon, size: 15),
        const SizedBox(width: 4),
        Text(text),
        const SizedBox(width: 14),
      ];

  // 打包任务列表子项右键菜单
  List<Widget> _getTaskItemMenus(BuildContext context, PackageModel item) => [
        // ListTile(
        //   leading: const Icon(FluentIcons.company_directory, size: 14),
        //   title: const Text('需要实现'),
        //   onPressed: () {
        //     /// 待实现
        //   },
        // ),
      ];
}

/*
* 打包任务页-逻辑
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackageTaskPageLogic extends BaseLogic {
  // 任务列表
  final taskListController = ListValueChangeNotifier<PackageModel>.empty();

  // 编辑状态记录
  final editorController = ValueChangeNotifier<bool>(false);

  // 所选记录表
  final selectedController =
      ListValueChangeNotifier<int>.empty(deduplication: true);

  // 流控制器
  late final StreamSubscription _subscription = dbManage
      .watchPackageTaskList(fireImmediately: true)
      .listen((_) => _loadTaskList());

  // 项目信息缓存加载回调
  final OnProjectCacheLoad _projectCacheLoad;

  _PackageTaskPageLogic(this._projectCacheLoad) {
    _subscription.resume();
    // 当编辑状态发生变化，则清空选择列表
    editorController.addListener(() {
      if (!editorController.value) {
        selectedController.clear();
      }
    });
    // 监听选择数据变化
    selectedController.addListener(() {
      final isEmpty = selectedController.isEmpty;
      editorController.setValue(!isEmpty);
    });
  }

  // 加载打包任务信息
  Future<void> _loadTaskList() async {
    final tmp = dbManage.loadPackageTaskList();
    final packages = <PackageModel>[];
    for (var it in tmp) {
      final p = await _projectCacheLoad(it.projectId);
      packages.add(PackageModel(package: it, projectInfo: p));
    }
    taskListController.setValue(packages);
  }

  // 本页全选/取消选择
  void pageAllSelected(bool checked) {
    final ids = taskListController.value.map((e) => e.package.id).toList();
    if (checked) {
      selectedController.removeValues(ids);
    } else {
      selectedController.addValues(ids);
    }
  }

  // 删除本页已选择内容
  Future<void> deleteAllSelected() async {
    try {
      final ids = selectedController.value;
      await dbManage.deletePackages(ids);
      selectedController.removeValues(ids);
      await _loadTaskList();
      editorController.setValue(false);
    } catch (e) {
      LogTool.e('删除打包任务记录失败', error: e);
    }
  }

  // 判断是否已全选
  bool get hasPageAllSelected {
    for (var it in taskListController.value) {
      if (!selectedController.contains(it.package.id)) return false;
    }
    return true;
  }

  // 判断本页是否存在已选中内容
  bool get hasSelected => selectedController.isNotEmpty;

  // 选择/取消一条数据
  void itemSelected(bool checked, int id) {
    if (checked) {
      selectedController.removeValue(id);
    } else {
      selectedController.addValue(id);
    }
  }

  // 判断是否已选择
  bool hasItemSelected(int id) => selectedController.contains(id);

  @override
  void dispose() {
    taskListController.dispose();
    selectedController.dispose();
    editorController.dispose();
    _subscription.cancel();
    super.dispose();
  }
}
