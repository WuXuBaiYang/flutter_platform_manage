import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/pages/setting/settings/project.dart';
import 'package:flutter_platform_manage/pages/setting/settings/system.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

/*
* 设置页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

/*
* 设置页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text('设置'),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            // 项目相关设置信息
            ProjectSettings(),
            // 系统相关设置
            SizedBox(height: 8),
            SystemSettings(),
          ],
        ),
      ),
    );
  }
}

/*
* 设置项子页面状态基类
* @author wuxubaiyang
* @Time 2022-07-26 09:17:26
*/
abstract class BaseSettingsState<T extends StatefulWidget,
    C extends BaseSettingsLogic> extends LogicState<T, C> {
  @override
  Widget build(BuildContext context) {
    final settingList = loadSettingList;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: settingList.length,
      separatorBuilder: (_, i) => const SizedBox(height: 8),
      itemBuilder: (_, i) => settingList[i],
    );
  }

  // 加载设置项集合
  List<Widget> get loadSettingList;

  // 构建设置项基础结构
  Widget buildItem({required Widget child}) {
    return CardItem(child: child);
  }
}

/*
* 设置基类-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:35
*/
abstract class BaseSettingsLogic extends BaseLogic {}
