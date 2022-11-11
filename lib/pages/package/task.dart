import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

/*
* 打包任务页
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class PackageTaskPage extends StatefulWidget {
  const PackageTaskPage({super.key});

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
  _PackageTaskPageLogic initLogic() => _PackageTaskPageLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.scaffoldBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          commandBar: _buildCommandBar(),
        ),
        content: _buildTaskList(),
      ),
    );
  }

  // 构建操作菜单
  Widget _buildCommandBar() {
    return CommandBarCard(
      child: CommandBar(
        overflowBehavior: CommandBarOverflowBehavior.noWrap,
        primaryItems: [],
      ),
    );
  }

  // 构建任务列表
  Widget _buildTaskList() {
    return StreamBuilder<List<Package>>(
      stream: dbManage.watchPackageTaskList(
        fireImmediately: true,
      ),
      builder: (_, taskList) {
        return SizedBox();
      },
    );
  }
}

/*
* 打包任务页-逻辑
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackageTaskPageLogic extends BaseLogic {}
