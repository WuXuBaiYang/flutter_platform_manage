import 'package:fluent_ui/fluent_ui.dart';

/*
* 卡片样式的子项
* @author JTech JH
* @Time 2022-07-27 14:31:19
*/
class CardItem extends StatelessWidget {
  // 子元素内容
  final Widget child;

  const CardItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}
