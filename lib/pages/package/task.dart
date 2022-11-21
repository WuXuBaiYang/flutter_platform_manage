import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/package_task.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/pages/package/index.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/widgets/dialog/package_log.dart';
import 'package:flutter_platform_manage/widgets/dialog/project_package.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'package:flutter_platform_manage/widgets/value_listenable_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          commandBar: _buildCommandBar(context),
        ),
        content: _buildTaskList(context),
      ),
    );
  }

  // 构建操作菜单
  Widget _buildCommandBar(BuildContext context) {
    return CommandBarCard(
      child: ValueListenableBuilder2<bool, List<int>>(
        first: logic.editorController,
        second: logic.selectedController,
        builder: (_, isEditor, selectList, __) {
          return CommandBar(
            overflowBehavior: CommandBarOverflowBehavior.noWrap,
            primaryItems: isEditor
                ? [
                    CommandBarButton(
                      icon: const Icon(FluentIcons.back),
                      onPressed: () => logic.editorController.setValue(false),
                    ),
                    if (logic.hasSelected) ...[
                      const CommandBarSeparator(),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.download),
                        onPressed: () =>
                            packageTaskManage.startTask(ids: selectList),
                      ),
                      const CommandBarSeparator(),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.pause),
                        onPressed: () =>
                            packageTaskManage.stopTask(ids: selectList),
                      ),
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
                        icon: const Icon(FluentIcons.broom),
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
                  ]
                : [
                    CommandBarButton(
                      label: const Text('全部开始'),
                      icon: const Icon(FluentIcons.play),
                      onPressed: () => packageTaskManage.startTask(),
                    ),
                    const CommandBarSeparator(),
                    CommandBarButton(
                      label: const Text('全部暂停'),
                      icon: const Icon(FluentIcons.pause),
                      onPressed: () => packageTaskManage.stopTask(),
                    ),
                    const CommandBarSeparator(),
                    CommandBarButton(
                      label: const Text('添加'),
                      icon: const Icon(FluentIcons.add),
                      onPressed: () => ProjectPackageDialog.show(context),
                    ),
                    const CommandBarSeparator(),
                    CommandBarButton(
                      label: const Text('编辑'),
                      icon: const Icon(FluentIcons.edit),
                      onPressed: () => logic.editorController.setValue(true),
                    ),
                  ],
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
          if (recordList.isEmpty) {
            return Center(
              child: NoticeBox.empty(
                message: '右上角 ‘添加’ 打包任务',
              ),
            );
          }
          return ListView.builder(
            itemExtent: 75,
            itemBuilder: (_, i) {
              final item = recordList[i];
              return _buildTaskListItem(context, item, isEdited, i);
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
    return Column(
      children: [
        ListTile.selectable(
          leading: _buildTaskListItemHeader(item),
          title: project == null
              ? const Text(
                  '项目信息丢失',
                  style: TextStyle(color: Common.warningColor),
                )
              : Text(project.showTitle),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text('v${project?.version}  ·  '
                    'Flutter ${project?.environment?.flutter}  ·  '
                    '${item.package.status.nameCN}'),
              ],
            ),
          ),
          trailing: _buildTaskListItemOptions(
              context, item.package, isEdited, checked),
          selected: checked,
          onPressed: () => logic.itemSelected(checked, id),
        ),
        const SizedBox(height: 4),
        const ThicknessDivider(),
      ],
    );
  }

  // 构建任务列表子项头部
  Widget _buildTaskListItemHeader(PackageModel item) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ProjectLogo(
          projectIcon: item.projectInfo?.projectIcon,
        ),
        CircleAvatar(
          radius: 12,
          child: SvgPicture.asset(
            item.package.platform.platformImage,
            color: Colors.white,
            width: 15,
            height: 15,
          ),
        ),
      ],
    );
  }

  // 构建任务列表子项得操作按钮
  Widget _buildTaskListItemOptions(
      BuildContext context, Package package, bool isEdited, bool checked) {
    final id = package.id;
    final status = package.status;
    final doWork = const [
      PackageStatus.prepare,
      PackageStatus.packing,
    ].contains(status);
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 7),
      child: Row(
        children: [
          if (status == PackageStatus.fail)
            IconButton(
              icon: Icon(FluentIcons.warning, color: Colors.red),
              onPressed: () =>
                  PackageLogDialog.show(context, logs: package.errors),
            ),
          const SizedBox(width: 8),
          if (isEdited)
            Checkbox(
              checked: checked,
              onChanged: (v) => logic.itemSelected(checked, id),
            ),
          if (!isEdited || status != PackageStatus.stopping)
            IconButton(
              icon: Icon(
                doWork ? FluentIcons.pause : FluentIcons.play,
                size: 16,
              ),
              onPressed: () => doWork
                  ? packageTaskManage.stopTask(ids: [id])
                  : packageTaskManage.startTask(ids: [id]),
            ),
        ],
      ),
    );
  }
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
      await packageTaskManage.removeTask(ids: ids);
      selectedController.removeValues(ids);
      await _loadTaskList();
      editorController.setValue(false);
    } catch (e) {
      LogTool.e('删除打包任务失败', error: e);
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
