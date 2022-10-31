import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/pages/setting/index.dart';

/*
* 系统相关设置
* @author wuxubaiyang
* @Time 2022-07-25 17:22:18
*/
class SystemSettings extends StatefulWidget {
  const SystemSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SystemSettingsState();
}

/*
* 系统相关设置-状态
* @author wuxubaiyang
* @Time 2022-07-25 17:22:43
*/
class _SystemSettingsState extends BaseSettingsState<SystemSettings> {
  @override
  List<Widget> get loadSettingList => [];
}
