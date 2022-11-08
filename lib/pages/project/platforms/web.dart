import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/model/platform/web.dart';
import 'package:flutter_platform_manage/widgets/color_picker_dialog.dart';
import 'platform.dart';

/*
* web平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformWebPage extends BasePlatformPage<WebPlatform> {
  const PlatformWebPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformWebPageState();
}

/*
* web平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformWebPageState
    extends BasePlatformPageState<PlatformWebPage, _PlatformWebPageLogic> {
  @override
  _PlatformWebPageLogic initLogic() =>
      _PlatformWebPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      _buildAppName(),
      _buildShortAppName(),
      _buildStartUrl(),
      _buildDescription(),
      buildAppLogo(),
      _buildDisplayMode(),
      _buildBackgroundColor(),
      _buildThemeColor(),
      _buildPreferRelatedApplications(),
    ];
  }

  // 构建应用名称
  Widget _buildAppName() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用名称',
        child: TextFormBox(
          initialValue: info.name,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
            }
            return null;
          },
          onChanged: (v) => info.name = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.name = v;
          },
        ),
      ),
    );
  }

  // 构建应用短名称
  Widget _buildShortAppName() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用短名称',
        child: TextFormBox(
          initialValue: info.shortName,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
            }
            return null;
          },
          onChanged: (v) => info.shortName = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.shortName = v;
          },
        ),
      ),
    );
  }

  // 应用起始页输入类型正则
  final _startUrlRegExp = RegExp(r'[A-Za-z0-9._/-]');

  // 构建应用包名编辑项
  Widget _buildStartUrl() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '起始页',
        child: TextFormBox(
          initialValue: info.startUrl,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
            }
            return null;
          },
          onChanged: (v) => info.startUrl = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.startUrl = v;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(_startUrlRegExp),
          ],
        ),
      ),
    );
  }

  // 构建应用描述
  Widget _buildDescription() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用描述',
        child: TextFormBox(
          initialValue: info.description,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
            }
            return null;
          },
          onChanged: (v) => info.description = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.description = v;
          },
        ),
      ),
    );
  }

  // 构建推荐应用开关
  Widget _buildPreferRelatedApplications() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<bool>(
        initialValue: info.preferRelatedApplications,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.preferRelatedApplications = v;
        },
        builder: (f) {
          return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  const Text('应用推荐'),
                  const Spacer(),
                  ToggleSwitch(
                    checked: f.value ?? false,
                    onChanged: (v) => f.didChange(v),
                  ),
                ],
              ),
            ),
            onTap: () {
              final v = f.value ?? false;
              f.didChange(!v);
            },
          );
        },
      ),
    );
  }

  // 构建背景色选择
  Widget _buildBackgroundColor() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<Color>(
        initialValue: info.backgroundColor,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.backgroundColor = v;
        },
        builder: (f) => _buildColorPicker(f, '背景色'),
      ),
    );
  }

  // 构建主题色选择
  Widget _buildThemeColor() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<Color>(
        initialValue: info.themeColor,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.themeColor = v;
        },
        builder: (f) => _buildColorPicker(f, '主题色'),
      ),
    );
  }

  // 构建颜色选择
  Widget _buildColorPicker(FormFieldState<Color> f, String title) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: [
            Text(title),
            const Spacer(),
            ClipOval(
              child: Container(
                width: 25,
                height: 25,
                color: f.value,
              ),
            ),
          ],
        ),
      ),
      onTap: () => ColorPickerDialog.show(
        context,
        initialColor: f.value,
        enableAlpha: false,
        enableInput: false,
      ).then((v) {
        if (v != null) f.didChange(v);
      }),
    );
  }

  // 构建启动模式选择框
  Widget _buildDisplayMode() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<WebDisplayMode>(
        initialValue: info.display,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.display = v;
        },
        builder: (f) {
          return Card(
            child: Row(
              children: [
                const Text('启动模式'),
                const Spacer(),
                ComboBox<WebDisplayMode>(
                  value: f.value,
                  items: WebDisplayMode.values
                      .map((e) => ComboBoxItem<WebDisplayMode>(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (v) => f.didChange(v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
* web平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformWebPageLogic extends BasePlatformPageLogic<WebPlatform> {
  _PlatformWebPageLogic(super.platformInfo);
}
