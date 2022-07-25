import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/pages/setting/project_settings.dart';

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
        title: Text("设置"),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            // 项目相关设置信息
            ProjectSettings(),
          ],
        ),
      ),
    );
  }
}
