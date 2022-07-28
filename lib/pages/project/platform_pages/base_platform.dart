import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:window_manager/window_manager.dart';

/*
* 平台状态基类
* @author JTech JH
* @Time 2022-07-26 17:54:08
*/
abstract class BasePlatformState<T extends StatefulWidget> extends State<T>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: loadSettingList,
      ),
    );
  }

  // 加载设置项集合
  List<Widget> get loadSettingList;

  // 构建平台参数设置项基础结构
  Widget buildItem(Widget child) {
    return Container(
      constraints: BoxConstraints(
        minWidth: Common.windowMinimumSize.width,
      ),
      child: child,
    );
  }

  @override
  void onWindowResize() {}

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
