import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/platform/ios.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/permission_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'platform.dart';

/*
* ios平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformIosPage extends BasePlatformPage<IOSPlatform> {
  const PlatformIosPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformIosPageState();
}

/*
* ios平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformIosPageState
    extends BasePlatformPageState<PlatformIosPage, _PlatformIosPageLogic> {
  @override
  _PlatformIosPageLogic initLogic() =>
      _PlatformIosPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      _buildBundleName(),
      _buildPermissionManage(),
      _buildBundleDisplayName(),
      buildAppLogo(),
    ];
  }

  // 构建应用名编辑项
  Widget _buildBundleName() {
    final info = logic.platformInfo;
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
  Widget _buildBundleDisplayName() {
    final info = logic.platformInfo;
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

  // 构建权限管理项
  Widget _buildPermissionManage() {
    final info = logic.platformInfo;
    return ValueListenableBuilder<bool>(
      valueListenable: logic.permissionExpand,
      builder: (_, expanded, __) {
        return buildItem(
          times: expanded ? 6 : 4,
          child: FormField<List<PermissionItemModel>>(
            initialValue: info.permissions,
            onSaved: (v) => info.permissions = v ?? [],
            builder: (f) => Column(
              children: [
                _buildPermissionManageHeader(f, expanded),
                _buildPermissionManageList(f),
              ],
            ),
          ),
        );
      },
    );
  }

  // 构建权限管理头部
  Widget _buildPermissionManageHeader(
      FormFieldState<List<PermissionItemModel>> f, bool expanded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text('权限管理'),
          const Spacer(),
          IconButton(
            icon: Icon(expanded
                ? FluentIcons.chevron_fold10
                : FluentIcons.chevron_unfold10),
            onPressed: () => logic.permissionExpand.setValue(!expanded),
          ),
          const SizedBox(width: 8),
          Button(
            child: const Text('添加权限'),
            onPressed: () {
              PermissionImportDialog.show(
                context,
                platformType: PlatformType.ios,
                initialPermissions: f.value,
              ).then((v) {
                if (null != v) {
                  setState(() => logic.platformInfo.permissions = v);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // 构建权限管理列表
  Widget _buildPermissionManageList(
      FormFieldState<List<PermissionItemModel>> f) {
    return Expanded(
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
}

/*
* ios平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:59
*/
class _PlatformIosPageLogic extends BasePlatformPageLogic<IOSPlatform> {
  // 权限管理的展示倍数
  final permissionExpand = ValueChangeNotifier<bool>(false);

  _PlatformIosPageLogic(super.platformInfo);

  @override
  void dispose() {
    permissionExpand.dispose();
    super.dispose();
  }
}
