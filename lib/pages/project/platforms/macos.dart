import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/macos.dart';

import 'platform.dart';

/*
* macos平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformMacOSPage extends BasePlatformPage<MacOSPlatform> {
  const PlatformMacOSPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformMacOSPageState();
}

/*
* macos平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformMacOSPageState
    extends BasePlatformPageState<PlatformMacOSPage, _PlatformMacOSPageLogic> {
  @override
  _PlatformMacOSPageLogic initLogic() =>
      _PlatformMacOSPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildAppLogo(),
      _buildSandboxDebug(),
      _buildSandboxRelease(),
    ];
  }

  // 构建沙盒模式-开发
  Widget _buildSandboxDebug() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<bool>(
        initialValue: info.sandBoxDebug,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.sandBoxDebug = v;
        },
        builder: (f) {
          return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  const Text('沙盒模式-开发'),
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

  // 构建沙盒模式-发布
  Widget _buildSandboxRelease() {
    final info = logic.platformInfo;
    return buildItem(
      child: FormField<bool>(
        initialValue: info.sandBoxRelease,
        validator: (v) {
          if (null == v) {
            return '不能为空';
          }
          return null;
        },
        onSaved: (v) {
          if (null == v) return;
          info.sandBoxRelease = v;
        },
        builder: (f) {
          return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  const Text('沙盒模式-发布'),
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
}

/*
* macos平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:13
*/
class _PlatformMacOSPageLogic extends BasePlatformPageLogic<MacOSPlatform> {
  _PlatformMacOSPageLogic(super.platformInfo);
}
