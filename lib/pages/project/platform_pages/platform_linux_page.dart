import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/linux_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';

/*
* linux平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformLinuxPage extends BasePlatformPage<LinuxPlatform> {
  const PlatformLinuxPage({
    Key? key,
    required LinuxPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

  @override
  State<StatefulWidget> createState() => _PlatformLinuxPageState();
}

/*
* linux平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformLinuxPageState extends BasePlatformPageState<PlatformLinuxPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }
}
