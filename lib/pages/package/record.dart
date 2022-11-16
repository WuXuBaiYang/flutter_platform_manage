import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/package/index.dart';
import 'package:flutter_platform_manage/utils/cache_future_builder.dart';
import 'package:flutter_platform_manage/utils/file.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/dialog/date_rang_picker.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/utils/date.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/page_indicator.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/value_listenable_builder.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* 打包记录页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class PackageRecordPage extends StatefulWidget {
  // 加载项目信息缓存回调
  final OnProjectCacheLoad onProjectCacheLoad;

  const PackageRecordPage({
    Key? key,
    required this.onProjectCacheLoad,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PackageRecordPageState();
}

/*
* 打包记录页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _PackageRecordPageState
    extends LogicState<PackageRecordPage, _PackageRecordPageLogic> {
  @override
  _PackageRecordPageLogic initLogic() => _PackageRecordPageLogic(
        widget.onProjectCacheLoad,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.scaffoldBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          title: StreamBuilder(
            stream: dbManage.watchPackageRecordList(
              fireImmediately: true,
            ),
            builder: (_, snap) {
              final count = dbManage.getPackageRecordCount();
              return Text('共 $count 条记录');
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildRecordList(context)),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  // 构建操作菜单
  Widget _buildCommandBar(BuildContext context) {
    return CommandBarCard(
      child: ValueListenableBuilder<_OptionParams>(
        valueListenable: logic.optionController,
        builder: (_, option, __) {
          return CommandBar(
            overflowBehavior: CommandBarOverflowBehavior.noWrap,
            primaryItems: [
              CommandBarButton(
                label: Text(option.sortStatus),
                icon: Icon(option.sortStatusIcon),
                onPressed: logic.switchSort,
              ),
              const CommandBarSeparator(),
              CommandBarButton(
                label: Text(option.timeTitle),
                icon: const Icon(FluentIcons.date_time),
                onPressed: () => _showDateRangPicker(
                  context,
                  start: option.startTime,
                  end: option.endTime,
                ),
              ),
              const CommandBarSeparator(),
              CommandBarButton(
                icon: _buildProjectSelect(option.projectId),
                onPressed: null,
              ),
              const CommandBarSeparator(),
              CommandBarButton(
                label: const Text('重置'),
                icon: const Icon(FluentIcons.reset),
                onPressed: logic.resetFilter,
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

  // 构建编辑操作菜单
  Widget _buildEditorCommandBar(BuildContext context) {
    return CommandBarCard(
      child: ValueListenableBuilder2<List<int>, _OptionParams>(
        first: logic.selectedController,
        second: logic.optionController,
        builder: (_, selectList, option, __) {
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

  // 构建记录列表
  Widget _buildRecordList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ValueListenableBuilder3<List<PackageModel>, List<int>, bool>(
        first: logic.recordListController,
        second: logic.selectedController,
        third: logic.editorController,
        builder: (_, recordList, selectList, isEdited, __) {
          return ListView.builder(
            itemExtent: 75,
            itemBuilder: (_, i) {
              final last = i > 0 ? recordList[i - 1] : null;
              final item = recordList[i];
              return MouseRightClickMenu(
                key: ObjectKey(item.package.id),
                menuItems: _getRecordItemMenus(context, item),
                child: _buildRecordListItem(context, item, last, isEdited, i),
              );
            },
            itemCount: recordList.length,
          );
        },
      ),
    );
  }

  // 构建打包记录列表子项
  Widget _buildRecordListItem(
    BuildContext context,
    PackageModel item,
    PackageModel? last,
    bool isEdited,
    int index,
  ) {
    final id = item.package.id;
    final project = item.projectInfo;
    final checked = logic.hasItemSelected(id);
    return Row(
      children: [
        _buildRecordListItemTimeline(
          item.package.completeTime,
          last?.package.completeTime,
          index <= 0,
        ),
        Expanded(
          child: Column(
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
                      const Icon(FluentIcons.bullseye, size: 15),
                      const SizedBox(width: 4),
                      Text(item.package.platform.name),
                      const SizedBox(width: 14),
                      const Icon(FluentIcons.timer, size: 15),
                      const SizedBox(width: 4),
                      Text(item.timeSpent),
                      const SizedBox(width: 14),
                      const Icon(FluentIcons.classroom_logo, size: 15),
                      const SizedBox(width: 4),
                      Text(item.packageSize),
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
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }

  // 构建记录列表子项时间轴
  Widget _buildRecordListItemTimeline(
    DateTime? curr,
    DateTime? last,
    bool first,
  ) {
    return SizedBox(
      width: 35,
      child: Column(
        children: [
          Visibility(
            visible: first ||
                (curr != null &&
                    last != null &&
                    curr.difference(last).inDays >= 1),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  '${curr?.year}\n${curr?.format('MM/dd')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: themeManage.currentTheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  // 打包记录列表子项右键菜单
  List<Widget> _getRecordItemMenus(BuildContext context, PackageModel item) => [
        ListTile(
          leading: const Icon(
            FluentIcons.company_directory,
            size: 14,
          ),
          title: const Text('打开输出目录'),
          onPressed: () {
            Navigator.pop(context);
            logic.openOutputDir(item.package.outputPath ?? '').then((v) {
              if (!v) Utils.showSnack(context, '目录打开失败');
            });
          },
        ),
        ListTile(
          leading: const Icon(
            FluentIcons.save_as,
            size: 14,
          ),
          title: const Text('文件另存为'),
          onPressed: () {
            Navigator.pop(context);
            logic.fileSaveAs(item.package.outputPath ?? '').then((v) {
              if (!v) Utils.showSnack(context, '文件另存为失败');
            });
          },
        ),
      ];

  // 构建分页指示器
  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: StreamBuilder(
        stream: dbManage.watchPackageRecordList(
          fireImmediately: true,
        ),
        builder: (_, __) => ValueListenableBuilder<_OptionParams>(
          valueListenable: logic.optionController,
          builder: (_, option, __) {
            return PageIndicator(
              currentPage: option.pageIndex,
              currentSize: option.pageSize,
              pageCount: dbManage.getPackageRecordPageCount(
                pageSize: option.pageSize,
              ),
              onChange: logic.updatePagination,
            );
          },
        ),
      ),
    );
  }

  // 构建项目选择组件
  Widget _buildProjectSelect(int? projectId) {
    projectId ??= -1;
    const resetChild = ComboBoxItem(
      value: -1,
      child: Text('全部项目'),
    );
    return CacheFutureBuilder<List<ProjectModel>>(
      future: dbManage.loadAllProjectInfos,
      builder: (_, snap) {
        final projects = snap.data ?? [];
        return ComboBox<int>(
          value: projectId,
          items: projects.map(_buildProjectSelectItem).toList()
            ..add(resetChild),
          onChanged: (v) {
            if (v != null && v <= 0) v = null;
            logic.selectProject(v);
          },
        );
      },
    );
  }

  // 构建项目选择子项
  ComboBoxItem<int> _buildProjectSelectItem(ProjectModel e) {
    return ComboBoxItem(
      value: e.project.id,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ProjectLogo.custom(
            projectIcon: e.projectIcon,
            size: const Size.square(15),
          ),
          const SizedBox(width: 8),
          Text(
            e.showTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 展示日期区间选择
  Future<void> _showDateRangPicker(
    BuildContext context, {
    required DateTime? start,
    required DateTime? end,
  }) {
    final initialDate = JDateRangPicker(
      start: start,
      end: end,
    );
    return JDateRangPickerDialog.show(
      context,
      initialDate: initialDate,
    ).then((result) {
      if (result != null) {
        logic.selectDate(result.start, result.end);
      }
    });
  }
}

/*
* 打包记录页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 14:31
*/
class _PackageRecordPageLogic extends BaseLogic {
  // 操作参数控制器
  final optionController = ValueChangeNotifier<_OptionParams>(_OptionParams());

  // 记录列表
  final recordListController = ListValueChangeNotifier<PackageModel>.empty();

  // 编辑状态记录
  final editorController = ValueChangeNotifier<bool>(false);

  // 所选记录表
  final selectedController =
      ListValueChangeNotifier<int>.empty(deduplication: true);

  // 项目信息缓存加载回调
  final OnProjectCacheLoad _projectCacheLoad;

  _PackageRecordPageLogic(this._projectCacheLoad) {
    // 初始化加载
    _loadRecordList();
    // 监听操作参数变化，刷新列表
    optionController.addListener(_loadRecordList);
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

  // 加载打包记录信息
  Future<void> _loadRecordList() async {
    final option = optionController.value;
    final tmp = dbManage.loadPackageRecordList(
        pageIndex: option.pageIndex,
        pageSize: option.pageSize,
        sort: option.sort,
        startTime: option.startTime,
        endTime: option.endTime,
        projectId: option.projectId);
    final packages = <PackageModel>[];
    for (var it in tmp) {
      final p = await _projectCacheLoad(it.projectId);
      packages.add(PackageModel(
        package: it,
        projectInfo: p,
      ));
    }
    recordListController.setValue(packages);
  }

  // 切换排序状态
  void switchSort() {
    final option = optionController.value;
    final sort = option.sort == Sort.asc ? Sort.desc : Sort.asc;
    optionController.setValue(
      option..sort = sort,
      update: true,
    );
  }

  // 更新分页信息
  void updatePagination(int pageIndex, int pageSize) {
    final option = optionController.value;
    optionController.setValue(
      option.pageSize != pageSize
          ? (option
            ..pageIndex = 1
            ..pageSize = pageSize)
          : (option..pageIndex = pageIndex),
      update: true,
    );
  }

  // 设置设置项目过滤
  void selectProject(int? projectId) {
    final option = optionController.value;
    optionController.setValue(
      option
        ..projectId = projectId
        ..pageIndex = 1,
      update: true,
    );
  }

  // 设置设置时间区间过滤
  void selectDate(DateTime? startTime, DateTime? endTime) {
    final option = optionController.value;
    optionController.setValue(
      option
        ..startTime = startTime
        ..endTime = endTime
        ..pageIndex = 1,
      update: true,
    );
  }

  // 重置过滤器
  void resetFilter() {
    final option = optionController.value;
    optionController.setValue(
      // 保持部分参数不变
      _OptionParams()..pageSize = option.pageSize,
    );
  }

// 打开输出目录
  Future<bool> openOutputDir(String filePath) async {
    try {
      if (filePath.isEmpty) return false;
      final f = File(filePath);
      if (!f.parent.existsSync()) return false;
      final uri = Uri.parse('file:${f.parent.path}');
      return launchUrl(uri);
    } catch (e) {
      LogTool.e('打包任务记录，打开输出目录失败', error: e);
      return false;
    }
  }

  // 文件另存为
  Future<bool> fileSaveAs(String filePath) async {
    try {
      if (filePath.isEmpty) return false;
      final f = File(filePath);
      if (!f.existsSync()) return false;
      final path = await FilePicker.platform.saveFile(
        dialogTitle: '请选择要保存的目录',
        fileName: f.name,
      );
      if (path != null) f.copySync(path);
    } catch (e) {
      LogTool.e('打包任务记录，文件另存为失败', error: e);
      return false;
    }
    return true;
  }

  // 本页全选/取消选择
  void pageAllSelected(bool checked) {
    final ids = recordListController.value.map((e) => e.package.id).toList();
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
      final option = optionController.value;
      final pageCount = dbManage.getPackageRecordPageCount(
        pageSize: option.pageSize,
      );
      if (option.pageIndex > pageCount) {
        final index = option.pageIndex - 1;
        option.pageIndex = index <= 1 ? 1 : index;
      }
      await _loadRecordList();
      editorController.setValue(false);
    } catch (e) {
      LogTool.e('删除打包任务记录失败', error: e);
    }
  }

  // 判断是否已全选
  bool get hasPageAllSelected {
    for (var it in recordListController.value) {
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
    optionController.dispose();
    recordListController.dispose();
    super.dispose();
  }
}

/*
* 操作参数实体
* @author wuxubaiyang
* @Time 2022/11/10 17:47
*/
class _OptionParams {
  // 分页下标
  int pageIndex = 1;

  // 分页单页数据量
  int pageSize = 20;

  // 排序方式
  Sort sort = Sort.asc;

  // 开始时间
  DateTime? startTime;

  // 结束时间
  DateTime? endTime;

  // 项目id
  int? projectId;

  // 获取排序的状态
  String get sortStatus => sort == Sort.asc ? '正序' : '逆序';

  // 获取排序状态图标
  IconData get sortStatusIcon =>
      sort == Sort.asc ? FluentIcons.sort_up : FluentIcons.sort_down;

  // 获取时间范围缩写
  String get timeTitle {
    var st = startTime?.format(DatePattern.fullDate) ?? '开始';
    final et = endTime?.format(DatePattern.fullDate) ?? '至今';
    return '$st - $et';
  }
}
