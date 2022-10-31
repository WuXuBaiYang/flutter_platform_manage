import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/event.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/event/theme.dart';
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
  List<Widget> get loadSettingList => [
        _buildAppTheme(),
      ];

  // 构建应用主题颜色
  Widget _buildAppTheme() {
    return StreamBuilder<ThemeEvent>(
      initialData: ThemeEvent(
        themeType: themeManage.currentType,
      ),
      stream: eventManage.on<ThemeEvent>(),
      builder: (_, snap) {
        final themeType = snap.data?.themeType;
        final isDayLight = themeType?.isDayLight ?? true;
        return buildItem(
          child: Button(
            style: ButtonStyle(
              padding: ButtonState.all(
                const EdgeInsets.all(14),
              ),
            ),
            child: Row(
              children: [
                Text(themeType?.nameCN ?? ''),
                const Spacer(),
                ToggleSwitch(
                  checked: isDayLight,
                  onChanged: (v) {
                    final type = v ? ThemeType.light : ThemeType.dark;
                    themeManage.switchTheme(type);
                  },
                ),
              ],
            ),
            onPressed: () {
              final type = !isDayLight ? ThemeType.light : ThemeType.dark;
              themeManage.switchTheme(type);
            },
          ),
        );
      },
    );
  }
}
