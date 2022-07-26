import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* win平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformWinPage extends StatefulWidget {
  // 平台信息
  final WindowsPlatform platformInfo;

  const PlatformWinPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformWinPageState();
}

/*
* win平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformWinPageState extends State<PlatformWinPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("开发中"),
    );
  }
}
