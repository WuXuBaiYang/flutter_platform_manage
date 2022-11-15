import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/pages/package/index.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/gen_android_key_dialog.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

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
          commandBar: _buildCommandBar(),
        ),
        content: _buildTaskList(context),
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
  Widget _buildTaskList(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text('点击测试'),
        onPressed: () {
          GenAndroidKeyDialog.show(context).then((v) {
            Utils.showSnack(context, '生成的签名文件路径');
          });
        },
      ),
    );
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
class _PackageTaskPageLogic extends BaseLogic {
  // 项目信息缓存加载回调
  final OnProjectCacheLoad _projectCacheLoad;

  _PackageTaskPageLogic(this._projectCacheLoad) {}
}
