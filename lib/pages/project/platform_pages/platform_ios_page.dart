import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* ios平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformIosPage extends BasePlatformPage<IOSPlatform> {
  const PlatformIosPage({
    Key? key,
    required IOSPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

  @override
  State<StatefulWidget> createState() => _PlatformIosPageState();
}

/*
* ios平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformIosPageState extends BasePlatformPageState<PlatformIosPage> {
  @override
  List<Widget> get loadSettingList => [];
}
