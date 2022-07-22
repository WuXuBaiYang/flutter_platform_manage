import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* android平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformAndroidPage extends StatefulWidget {
  // 平台信息
  final AndroidPlatform? platform;

  const PlatformAndroidPage({
    Key? key,
    required this.platform,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformAndroidPageState();
}

/*
* android平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformAndroidPageState extends State<PlatformAndroidPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.platform?.type.name ?? "平台不存在"),
    );
  }
}
