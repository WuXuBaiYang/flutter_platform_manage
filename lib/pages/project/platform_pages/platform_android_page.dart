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
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildAppName(),
      buildPermissionManage(),
      buildPackageName(),
      buildAppLogo(),
    ];
  }

  // 构建应用名称编辑项
  Widget buildAppName() {
    final info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
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
    final info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
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

  // 权限管理的展示倍数
  bool _permissionExpand = false;

  // 构建权限管理项
  Widget buildPermissionManage() {
    final info = widget.platformInfo;
    return buildItem(
      times: _permissionExpand ? 6 : 4,
      child: FormField<List<PermissionItemModel>>(
        initialValue: info.permissions,
        onSaved: (v) => info.permissions = v ?? [],
        builder: (f) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text("权限管理"),
              trailing: Row(
                children: [
                  IconButton(
                    icon: Icon(_permissionExpand
                        ? FluentIcons.chevron_fold10
                        : FluentIcons.chevron_unfold10),
                    onPressed: () =>
                        setState(() => _permissionExpand = !_permissionExpand),
                  ),
                  const SizedBox(width: 8),
                  Button(
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
                ],
              ),
            ),
            Expanded(
              child: CardItem(
                child: f.value?.isEmpty ?? true
                    ? const Center(child: Text("还未添加任何权限哦~"))
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
    final item = f.value?[i];
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
    final info = widget.platformInfo;
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
              Utils.pickProjectLogo(minSize: const Size.square(192)).then((v) {
                if (null != v) widget.platformInfo.modifyProjectIcon(v);
              }).catchError((e) {
                Utils.showSnack(context, e.toString());
              });
            },
          ),
          onTap: () => _showLogoList(info.loadIcons(reversed: true)),
        ),
      ),
    );
  }

  // 展示图标弹窗
  void _showLogoList(Map<AndroidIcons, String> iconsMap) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ContentDialog(
          content: ListView.separated(
            shrinkWrap: true,
            itemCount: iconsMap.length,
            separatorBuilder: (_, i) => const SizedBox(height: 24),
            itemBuilder: (_, i) {
              final type = iconsMap.keys.elementAt(i),
                  path = iconsMap[type] ?? "",
                  sizePx = type.sizePx;
              return Row(
                children: [
                  Expanded(
                    child: LogoFileImage(
                      File(path),
                      size: type.showSize.toDouble(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${type.name}(${sizePx}x$sizePx)"),
                  ),
                  IconButton(
                    icon: const Icon(FluentIcons.info),
                    onPressed: () => Utils.showSnackWithFilePath(context, path),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
