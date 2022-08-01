import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import 'window_buttons.dart';

/*
* 应用页面组件
* @author JTech JH
* @Time 2022-07-22 13:40:59
*/
class AppPage extends StatelessWidget {
  // 标题
  final String title;

  // 是否显示后退按钮
  final bool showBack;

  // 标题前部元素
  final Widget? leading;

  // 页面内容
  final Widget content;

  // 导航菜单
  final NavigationPane? pane;

  const AppPage({
    Key? key,
    required this.title,
    required this.content,
    this.showBack = true,
    this.leading,
    this.pane,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: DragToMoveArea(
          child: Row(
            children: [
              Visibility(
                visible: showBack,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(FluentIcons.back),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
              ),
              leading ?? const SizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(title),
              )
            ],
          ),
        ),
        actions: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Spacer(), WindowButtons()],
        ),
      ),
      pane: pane,
      content: content,
    );
  }
}
