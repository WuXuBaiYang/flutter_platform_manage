import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
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
          title: Text('共 0 条记录'),
          commandBar: _buildCommandBar(),
        ),
        content: _buildRecordList(),
      ),
    );
  }

  // 构建操作菜单
  Widget _buildCommandBar() {
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
              )
            ],
          );
        },
      ),
    );
  }

  // 构建记录列表
  Widget _buildRecordList() {
    return ValueListenableBuilder<List<Package>>(
      valueListenable: logic.recordListController,
      builder: (_, recordList, __) {
        return SizedBox();
      },
    );
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
        projectId: option.projectId,
      ));
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

  // 页面切换
  void switchPage(int page) {
    final option = optionController.value;
    optionController.setValue(
      option..pageIndex = page,
      update: true,
    );
  }

  // 设置设置项目过滤
  void selectProject(Id? projectId) {
    final option = optionController.value;
    optionController.setValue(
      option..projectId = projectId,
      update: true,
    );
  }

  // 设置设置时间区间过滤
  void selectDate(DateTime? startTime, DateTime? endTime) {
    final option = optionController.value;
    optionController.setValue(
      option
        ..startTime = startTime
        ..endTime = endTime,
      update: true,
    );
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
  int pageSize = 15;

  // 排序方式
  Sort sort = Sort.asc;

  // 开始时间
  DateTime? startTime;

  // 结束时间
  DateTime? endTime;

  // 项目id
  Id? projectId;

  // 获取排序的状态
  String get sortStatus => sort == Sort.asc ? '正序' : '逆序';

  // 获取排序状态图标
  IconData get sortStatusIcon =>
      sort == Sort.asc ? FluentIcons.sort_up : FluentIcons.sort_down;
}
