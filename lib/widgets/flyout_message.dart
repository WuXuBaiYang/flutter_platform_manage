import 'package:fluent_ui/fluent_ui.dart';

/*
* 用于展示消息的flyout组件
* @author JTech JH
* @Time 2022-08-02 10:12:16
*/
class FlyoutMessage extends StatelessWidget {
  // 消息内容
  final String message;

  // 包裹元素
  final Widget child;

  const FlyoutMessage({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flyout(
      openMode: FlyoutOpenMode.press,
      child: child,
      content: (_) => FlyoutContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 8),
            Button(
              child: const Text('确定'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
