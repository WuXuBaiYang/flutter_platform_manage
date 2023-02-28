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
class _SystemSettingsState
    extends BaseSettingsState<SystemSettings, _SystemSettingsLogic> {
  @override
  _SystemSettingsLogic initLogic() => _SystemSettingsLogic();

  @override
  List<Widget> get loadSettingList => [
        _buildAppTheme(),
      ];

  // 构建应用主题颜色
  Widget _buildAppTheme() {
    return StreamBuilder<ThemeEvent>(
      initialData: ThemeEvent(
        themeType: themeManage.currentType,
        fontFamily: ThemeFontFamily.alibabaSans,
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
                  onChanged: (v) => logic.switchTheme(v),
                ),
              ],
            ),
            onPressed: () => logic.switchTheme(!isDayLight),
          ),
        );
      },
    );
  }
}

/*
* 系统设置相关-逻辑
* @author wuxubaiyang
* @Time 2022/11/9 13:13
*/
class _SystemSettingsLogic extends BaseSettingsLogic {
  // 切换样式
  Future<bool> switchTheme(bool isDayLight) {
    final type = isDayLight ? ThemeType.light : ThemeType.dark;
    return themeManage.switchTheme(type);
  }
}
