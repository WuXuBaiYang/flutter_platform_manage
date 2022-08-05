import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/model/platform/ios_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/logo_file_image.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';

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
    return [
      buildBundleName(),
      buildBundleDisplayName(),
      buildAppLogo(),
    ];
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

  // 构建应用图标编辑项
  Widget buildAppLogo() {
    var info = widget.platformInfo;
    return buildItem(
      child: CardItem(
        child: TappableListTile(
          leading: LogoFileImage(
            File(info.projectIcon),
            size: 30,
          ),
          title: const Text("应用图标（立即生效）"),
          trailing: Button(
            child: const Text("批量替换"),
            onPressed: () {
              Utils.pickProjectLogo(minSize: const Size.square(1024)).then((v) {
                if (null != v) widget.platformInfo.modifyProjectIcon(v);
              }).catchError((e) {
                Utils.showSnack(context, e.toString());
              });
            },
          ),
          onTap: () => _showLogoList(info.loadGroupIcons()),
        ),
      ),
    );
  }

  // 展示图标弹窗
  void _showLogoList(List<Map<IOSIcons, String>> groupIcons) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ContentDialog(
          constraints: const BoxConstraints(
            maxWidth: 425,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(groupIcons.length, (i) {
                var it = groupIcons[i];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(it.length, (j) {
                    var k = it.keys.elementAt(j), v = it[k]!;
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          LogoFileImage(
                            File(v),
                            size: k.showSize.toDouble(),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text("${k.name}(${k.sizePx}x${k.sizePx})"),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: IconButton(
                                  icon: const Icon(FluentIcons.info),
                                  onPressed: () {
                                    Utils.showSnackWithFilePath(context, v);
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
