import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/pages/package/record.dart';
import 'package:flutter_platform_manage/pages/package/task.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

/*
* 打包管理页
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<StatefulWidget> createState() => _PackagePageState();
}

/*
* 打包管理页-状态
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackagePageState extends LogicState<PackagePage, _PackagePageLogic> {
  @override
  _PackagePageLogic initLogic() => _PackagePageLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.navigationPaneTheme.backgroundColor,
      child: ValueListenableBuilder<int>(
        valueListenable: logic.pageIndexController,
        builder: (_, pageIndex, __) {
          return TabView(
            currentIndex: pageIndex,
            closeButtonVisibility: CloseButtonVisibilityMode.never,
            onChanged: (i) => logic.pageIndexController.setValue(i),
            tabs: const [
              Tab(
                text: Text('任务队列'),
                icon: Icon(FluentIcons.task_list),
                body: PackageTaskPage(),
              ),
              Tab(
                text: Text('历史记录'),
                icon: Icon(FluentIcons.history),
                body: PackageRecordPage(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/*
* 打包管理页-逻辑
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackagePageLogic extends BaseLogic {
  // 分页下标管理
  final pageIndexController = ValueChangeNotifier<int>(0);
}
