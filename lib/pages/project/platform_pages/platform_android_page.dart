import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/manager/event_manage.dart';
import 'package:flutter_platform_manage/model/event/project_logo_change_event.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/logo_file_image.dart';

/*
* android平台分页
* @author JTech JH
* @Time 2022-07-22 17:48:47
*/
class PlatformAndroidPage extends BasePlatformPage<AndroidPlatform> {
  const PlatformAndroidPage({
    Key? key,
    required AndroidPlatform platformInfo,
  }) : super(key: key, platformInfo: platformInfo);

  @override
  State<StatefulWidget> createState() => _PlatformAndroidPageState();
}

/*
* android平台分页-状态
* @author JTech JH
* @Time 2022-07-22 17:49:51
*/
class _PlatformAndroidPageState
    extends BasePlatformPageState<PlatformAndroidPage> {
  @override
  List<Widget> get loadSettingList => [
        buildAppNameItem(),
        buildPackageNameItem(),
        buildAppLogoItem(),
      ];

  // 构建应用名称编辑项
  Widget buildAppNameItem() {
    var info = widget.platformInfo;
    return buildItem(
      InfoLabel(
        label: "应用名称（安装之后的名称）",
        child: TextFormBox(
          initialValue: info.label,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return "不能为空";
            }
            return null;
          },
          onChanged: (v) => info.label = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.label = v;
          },
        ),
      ),
    );
  }

  // 应用包名输入校验
  final packageNameRegExp = RegExp(r"[A-Z,a-z,0-9,.]");

  // 构建应用包名编辑项目
  Widget buildPackageNameItem() {
    var info = widget.platformInfo;
    return buildItem(
      InfoLabel(
        label: "应用包名",
        child: TextFormBox(
          initialValue: info.package,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return "不能为空";
            }
            return null;
          },
          onChanged: (v) => info.package = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.package = v;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(packageNameRegExp),
          ],
        ),
      ),
    );
  }

  // 构建应用图标编辑项目
  Widget buildAppLogoItem() {
    var info = widget.platformInfo;
    var iconsMap = info.loadIcons();
    return buildItem(
      Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Text("应用图标（立即生效）"),
            trailing: Button(
              child: const Text("批量替换"),
              onPressed: () => _pickLogoAndReplace(AndroidIconSize.values),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: iconsMap.length,
            separatorBuilder: (_, i) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              var type = iconsMap.keys.elementAt(i),
                  path = iconsMap[type] ?? "",
                  sizePx = type.sizePx.toInt();
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: LogoFileImage(
                        File(path),
                        size: type.showSize,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: Text("${type.name}(${sizePx}x$sizePx)"),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.edit),
                          onPressed: () => _pickLogoAndReplace([type]),
                        ),
                        IconButton(
                          icon: const Icon(FluentIcons.info),
                          onPressed: () =>
                              Utils.showSnackWithFilePath(context, path),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 选择附件
  Future<void> _pickLogoAndReplace(
    List<AndroidIconSize> iconSizes, {
    String suffix = ".png",
  }) async {
    var result = await FilePicker.platform.pickFiles(
      dialogTitle: "选择 .png 图片，尺寸 192px 至 1024px 正方形最佳",
      allowCompression: false,
      lockParentWindow: true,
      type: FileType.image,
    );
    if (null == result || result.count <= 0) return;
    var path = widget.platformInfo.platformPath;
    final rawImage = await File(result.paths.first ?? "").readAsBytes();
    for (var it in iconSizes) {
      var f = File("$path/${it.getAbsolutePath(
        widget.platformInfo.iconPath,
        suffix: suffix,
      )}");
      var imageSize = it.sizePx.toInt();
      var bytes = await _resizeImage(
        rawImage,
        height: imageSize,
        width: imageSize,
      );
      if (null == bytes) continue;
      f = await f.writeAsBytes(bytes.buffer.asInt8List());
      eventManage.fire(ProjectLogoChangeEvent(f.path));
    }
  }
}

// 修改图片尺寸并返回
Future<ByteData?> _resizeImage(Uint8List rawImage,
    {int? width, int? height}) async {
  final codec = await ui.instantiateImageCodec(rawImage,
      targetWidth: width, targetHeight: height);
  final resizedImage = (await codec.getNextFrame()).image;
  return resizedImage.toByteData(format: ui.ImageByteFormat.png);
}
