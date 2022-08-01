import 'package:fluent_ui/fluent_ui.dart';

/*
* 超薄分割线
* @author JTech JH
* @Time 2022-08-01 16:44:46
*/
class ThicknessDivider extends StatelessWidget {
  // 分割线尺寸
  final double? size;

  // 分割线方向
  final Axis direction;

  const ThicknessDivider({
    Key? key,
    this.size,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      size: size,
      direction: direction,
      style: const DividerThemeData(
        thickness: 0.3,
        verticalMargin: EdgeInsets.all(8),
      ),
    );
  }
}
