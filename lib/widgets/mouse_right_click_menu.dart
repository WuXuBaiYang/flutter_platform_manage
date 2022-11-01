import 'package:contextmenu/contextmenu.dart';
import 'package:fluent_ui/fluent_ui.dart';

/*
* 鼠标右键点击弹出菜单
* @author wuxubaiyang
* @Time 2022-07-22 10:59:58
*/
class MouseRightClickMenu extends StatelessWidget {
  // 菜单子项集合
  final List<Widget> menuItems;

  // 内容元素
  final Widget child;

  // 纵向元素间距
  final double verticalPadding;

  // 菜单宽度
  final double width;

  const MouseRightClickMenu({
    Key? key,
    required this.menuItems,
    required this.child,
    this.verticalPadding = 8.0,
    this.width = 180.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => showContextMenu(
        details.globalPosition,
        context,
        (_) => menuItems,
        verticalPadding,
        width,
      ),
      child: child,
    );
  }
}
