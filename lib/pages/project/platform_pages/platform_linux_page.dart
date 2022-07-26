import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* linux平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformLinuxPage extends StatefulWidget {
  // 平台信息
  final LinuxPlatform platformInfo;

  const PlatformLinuxPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformLinuxPageState();
}

/*
* linux平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformLinuxPageState extends State<PlatformLinuxPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("开发中"),
    );
  }
}
