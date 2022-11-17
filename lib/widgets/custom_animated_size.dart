import 'package:fluent_ui/fluent_ui.dart';

/*
* 自定义尺寸动画
* @author wuxubaiyang
* @Time 2022/11/17 11:38
*/
class CustomAnimatedSize extends StatelessWidget {
  // 子元素
  final Widget child;

  const CustomAnimatedSize({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}
