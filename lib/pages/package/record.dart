import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/date_rang_picker_dialog.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/utils/date.dart';
import 'package:flutter_platform_manage/widgets/page_indicator.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:isar/isar.dart';

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
            Expanded(child: _buildRecordList()),
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
  Widget _buildRecordList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ValueListenableBuilder<List<Package>>(
        valueListenable: logic.recordListController,
        builder: (_, recordList, __) {
          return ListView.separated(
            itemBuilder: (_, i) => Text('第$i行'),
            separatorBuilder: (_, i) => Divider(),
            itemCount: 100,
          );
        },
      ),
    );
  }

  // 构建分页指示器
  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: StreamBuilder(
        stream: dbManage.watchPackageRecordList(
          fireImmediately: true,
        ),
        builder: (_, __) {
          final pageCount = dbManage.getPackageRecordPageCount();
          return ValueListenableBuilder<_OptionParams>(
            valueListenable: logic.optionController,
            builder: (_, option, __) {
              return PageIndicator(
                currentPage: option.pageIndex,
                currentSize: option.pageSize,
                pageCount: pageCount,
                onChange: logic.updatePagination,
              );
            },
          );
        },
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
  final recordListController = ListValueChangeNotifier<Package>.empty();

  _PackageRecordPageLogic() {
    // 监听操作参数变化，刷新列表
    optionController.addListener(() {
      final option = optionController.value;
      recordListController.setValue(dbManage.loadPackageRecordList(
          pageIndex: option.pageIndex,
          pageSize: option.pageSize,
          sort: option.sort,
          startTime: option.startTime,
          endTime: option.endTime,
          projectId: option.projectId));
    });
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
            ..resetPage()
            ..pageSize = pageSize)
          : option
        ..pageIndex = pageIndex,
      update: true,
    );
  }

  // 设置设置项目过滤
  void selectProject(int? projectId) {
    final option = optionController.value;
    optionController.setValue(
      option
        ..projectId = projectId
        ..resetPage(),
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
        ..resetPage(),
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

  // 重置页码
  void resetPage() => pageIndex = 1;
}
