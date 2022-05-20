import 'package:fluent_ui/fluent_ui.dart';

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
    return const ScaffoldPage(
      content: Center(child: Text("正在开发")),
    );
  }
}
