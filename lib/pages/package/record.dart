import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/common/route_path.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/router.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/cache_future_builder.dart';
import 'package:flutter_platform_manage/utils/file.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/date_rang_picker_dialog.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/utils/date.dart';
import 'package:flutter_platform_manage/widgets/mouse_right_click_menu.dart';
import 'package:flutter_platform_manage/widgets/page_indicator.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* 打包记录页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class PackageRecordPage extends StatefulWidget {
  const PackageRecordPage({Key? key}) : super(key: key);

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
  _PackageRecordPageLogic initLogic() => _PackageRecordPageLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.scaffoldBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          commandBar: _buildCommandBar(context),
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
            ],
          );
        },
      ),
    );
  }

  // 构建记录列表
  Widget _buildRecordList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ValueListenableBuilder<List<PackageModel>>(
        valueListenable: logic.recordListController,
        builder: (_, recordList, __) {
          return ListView.separated(
            itemBuilder: (_, i) {
              final last = i > 0 ? recordList[i - 1] : null;
              return _buildRecordListItem(context, recordList[i], last);
            },
            separatorBuilder: (_, i) => const Divider(),
            itemCount: recordList.length,
          );
        },
      ),
    );
  }

  // 构建打包记录列表子项
  Widget _buildRecordListItem(
      BuildContext context, PackageModel item, PackageModel? last) {
    final project = item.projectInfo;
    final title = project == null
        ? const Text(
            '项目信息已丢失',
            style: TextStyle(color: Common.warningColor),
          )
        : Text(
            '${item.completeTime} 完成 ${project.showTitle} 项目打包任务',
          );
    return MouseRightClickMenu(
      key: ObjectKey(item.package.id),
      menuItems: _getRecordItemMenus(context, item),
      child: ListTile.selectable(
        title: title,
        subtitle: Text('打包平台 ${item.package.platform.name}  ·  '
            '耗时 ${item.timeSpent}'),
        onPressed: () {},
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

  _PackageRecordPageLogic() {
    // 初始化加载
    _loadRecordList();
    // 监听操作参数变化，刷新列表
    optionController.addListener(_loadRecordList);
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
      final p = await _loadProjectInfo(it.projectId);
      packages.add(PackageModel(
        package: it,
        projectInfo: p,
      ));
    }
    recordListController.setValue(packages);
  }

  // 缓存加载过的项目表
  final _cacheProjectInfo = <int, ProjectModel?>{};

  // 获取项目信息
  Future<ProjectModel?> _loadProjectInfo(int id) async {
    if (_cacheProjectInfo.containsKey(id)) {
      return _cacheProjectInfo[id];
    }
    final t = dbManage.loadProject(id);
    if (t == null) return null;
    final p = ProjectModel(project: t);
    if (await p.update(simple: true)) {
      return _cacheProjectInfo[id] = p;
    }
    return null;
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

  @override
  void dispose() {
    optionController.dispose();
    recordListController.dispose();
    super.dispose();
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
