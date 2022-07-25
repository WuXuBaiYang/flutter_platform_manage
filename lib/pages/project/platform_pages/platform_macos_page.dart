import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* macos平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformMacOSPage extends StatefulWidget {
  // 平台信息
  final MacOSPlatform platformInfo;

  const PlatformMacOSPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformMacOSPageState();
}

/*
* macos平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformMacOSPageState extends State<PlatformMacOSPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("macos"),
    );
  }
}
