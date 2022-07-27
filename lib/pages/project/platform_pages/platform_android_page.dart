import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* android平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformAndroidPage extends StatefulWidget {
  // 平台信息
  final AndroidPlatform platformInfo;

  const PlatformAndroidPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformAndroidPageState();
}

/*
* android平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformAndroidPageState extends BasePlatformState<PlatformAndroidPage> {
  @override
  List<Widget> get loadSettingList => [];
}
