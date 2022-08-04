import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/model/platform/ios_platform.dart';
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
  List<Widget> loadItemList(BuildContext context) {
    return [];
  }

  // 构建应用名编辑项
  Widget buildBundleName() {
    var info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: "应用名称（BundleName）",
        child: TextFormBox(
          initialValue: info.bundleName,
          inputFormatters: [
            FilteringTextInputFormatter(RegExp(r'[A-Z,a-z,0-9,_]'),
                allow: true),
          ],
          validator: (v) {
            if (null == v || v.isEmpty) {
              return "不能为空";
            }
            return null;
          },
          onChanged: (v) => info.bundleName = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.bundleName = v;
          },
        ),
      ),
    );
  }

  // 构建展示应用名编辑项
  Widget buildBundleDisplayName() {
    var info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: "展示应用名称（BundleDisplayName）",
        child: TextFormBox(
          initialValue: info.bundleDisplayName,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return "不能为空";
            }
            return null;
          },
          onChanged: (v) => info.bundleDisplayName = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.bundleDisplayName = v;
          },
        ),
      ),
    );
  }
}
