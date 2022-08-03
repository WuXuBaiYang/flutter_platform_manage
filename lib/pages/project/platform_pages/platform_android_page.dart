import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/manager/event_manage.dart';
import 'package:flutter_platform_manage/model/event/project_logo_change_event.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/android_platform.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/logo_file_image.dart';
import 'package:flutter_platform_manage/widgets/permission_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

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
        buildAppName(),
        buildPackageName(),
        buildPermissionManage(),
        buildAppLogo(),
      ];

  // 构建应用名称编辑项
  Widget buildAppName() {
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

  // 构建应用包名编辑项
  Widget buildPackageName() {
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

  // 构建权限管理项
  Widget buildPermissionManage() {
    var info = widget.platformInfo;
    return buildItem(
      FormField<List<PermissionItemModel>>(
        initialValue: info.permissions,
        onSaved: (v) => info.permissions = v ?? [],
        builder: (f) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text("权限管理"),
              trailing: Button(
                child: const Text("添加权限"),
                onPressed: () {
                  PermissionImportDialog.show(
                    context,
                    platformType: PlatformType.android,
                    permissions: f.value,
                  ).then((v) {
                    if (null != v) {
                      setState(() => widget.platformInfo.permissions = v);
                    }
                  });
                },
              ),
            ),
            CardItem(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 275,
                ),
                child: f.value?.isEmpty ?? true
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("还未添加任何权限哦~", textAlign: TextAlign.center),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: f.value?.length ?? 0,
                        separatorBuilder: (_, i) => const ThicknessDivider(),
                        itemBuilder: (_, i) => _buildPermissionManageItem(f, i),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建权限管理列表子项
  Widget _buildPermissionManageItem(
      FormFieldState<List<PermissionItemModel>> f, int i) {
    var item = f.value?[i];
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12, color: Color(0xff333333)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(item?.describe ?? ""),
                  Text(item?.value ?? ""),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: () => ImportantOptionDialog.show(
              context,
              message: "是否删除 ‘${item?.name ?? ""}’ 权限",
              onConfirmTap: () => f.didChange(f.value?..remove(item)),
            ),
          ),
        ],
      ),
    );
  }

  // 构建应用图标编辑项
  Widget buildAppLogo() {
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
            itemBuilder: (_, i) => _buildAppLogoItem(iconsMap, i),
          ),
        ],
      ),
    );
  }

  // 构建应用图标列表子项
  Widget _buildAppLogoItem(Map<AndroidIconSize, String> iconsMap, int i) {
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
                onPressed: () => Utils.showSnackWithFilePath(context, path),
              ),
            ],
          ),
        ),
      ],
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
      var bytes = await Utils.resizeImage(
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
