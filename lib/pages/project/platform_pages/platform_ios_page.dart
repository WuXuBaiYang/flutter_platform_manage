import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* ios平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformIosPage extends StatefulWidget {
  // 平台信息
  final IOSPlatform? platform;

  const PlatformIosPage({
    Key? key,
    required this.platform,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformIosPageState();
}

/*
* ios平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformIosPageState extends State<PlatformIosPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.platform?.type.name ?? "平台不存在"),
    );
  }
}
