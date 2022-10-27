import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/model/platform/ios_platform.dart';
import 'package:flutter_platform_manage/pages/project/platform_pages/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/logo_file_image.dart';
import 'package:flutter_platform_manage/widgets/permission_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

/*
* ios平台分页
* @author wuxubaiyang
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
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformIosPageState extends BasePlatformPageState<PlatformIosPage> {
  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      buildBundleName(),
      buildPermissionManage(),
      buildBundleDisplayName(),
      buildAppLogo(),
    ];
  }

  // 构建应用名编辑项
  Widget buildBundleName() {
    final info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用名称（BundleName）',
        child: TextFormBox(
          initialValue: info.bundleName,
          inputFormatters: [
            FilteringTextInputFormatter(
              RegExp(r'[A-Za-z0-9_]'),
              allow: true,
            ),
          ],
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
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
    final info = widget.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '展示应用名称（BundleDisplayName）',
        child: TextFormBox(
          initialValue: info.bundleDisplayName,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
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
          children: [
            ListTile(
              leading: const Text('权限管理'),
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
                    child: const Text('添加权限'),
                    onPressed: () {
                      PermissionImportDialog.show(
                        context,
                        platformType: PlatformType.ios,
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
                    ? const Center(child: Text('还未添加任何权限哦~'))
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
                    item?.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(item?.value ?? ''),
                  const SizedBox(height: 4),
                  TextBox(
                    controller: TextEditingController(
                      text: item?.describe ?? '',
                    ),
                    placeholder: item?.hint ?? '请输入对该权限的描述',
                    onChanged: (v) => item?.describe = v,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: () => ImportantOptionDialog.show(
              context,
              message: '是否删除 ‘${item?.name ?? ''}’ 权限',
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
        child: ListTile(
          leading: LogoFileImage(
            File(info.projectIcon),
            size: 30,
          ),
          title: const Text('应用图标（立即生效）'),
          trailing: Button(
            child: const Text('批量替换'),
            onPressed: () {
              Utils.pickProjectLogo(minSize: const Size.square(1024)).then((v) {
                if (null != v) widget.platformInfo.modifyProjectIcon(v);
              }).catchError((e) {
                Utils.showSnack(context, e.toString());
              });
            },
          ),
          onPressed: () => _showLogoList(info.loadGroupIcons()),
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
                final it = groupIcons[i];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(it.length, (j) {
                    final k = it.keys.elementAt(j), v = it[k]!;
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
                              Text('${k.name}(${k.sizePx}x${k.sizePx})'),
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
