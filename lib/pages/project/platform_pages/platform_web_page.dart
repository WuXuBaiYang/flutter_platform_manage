import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* web平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformWebPage extends StatefulWidget {
  // 平台信息
  final WebPlatform platformInfo;

  const PlatformWebPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformWebPageState();
}

/*
* web平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformWebPageState extends State<PlatformWebPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("开发中"),
    );
  }
}
