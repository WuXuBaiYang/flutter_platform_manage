import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/android.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/dialog/android_build_guide.dart';
import 'package:flutter_platform_manage/widgets/dialog/gen_android_key.dart';
import 'package:flutter_platform_manage/widgets/dialog/important_option.dart';
import 'package:flutter_platform_manage/widgets/dialog/permission_import.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';
import 'platform.dart';

/*
* android平台分页
* @author wuxubaiyang
* @Time 2022-07-22 17:48:47
*/
class PlatformAndroidPage extends BasePlatformPage<AndroidPlatform> {
  const PlatformAndroidPage({
    super.key,
    required super.platformInfo,
  });

  @override
  State<StatefulWidget> createState() => _PlatformAndroidPageState();
}

/*
* android平台分页-状态
* @author wuxubaiyang
* @Time 2022-07-22 17:49:51
*/
class _PlatformAndroidPageState extends BasePlatformPageState<
    PlatformAndroidPage, _PlatformAndroidPageLogic> {
  @override
  _PlatformAndroidPageLogic initLogic() =>
      _PlatformAndroidPageLogic(widget.platformInfo);

  @override
  List<Widget> loadItemList(BuildContext context) {
    return [
      _buildAppName(),
      _buildPermissionManage(),
      _buildPackageName(),
      buildAppLogo(),
      buildPackage(actions: [
        TextButton(
          child: const Text('生成签名'),
          onPressed: () => GenAndroidKeyDialog.show(context),
        ),
        TextButton(
          child: const Text('引导'),
          onPressed: () => AndroidBuildGuideDialog.show(context),
        ),
      ]),
    ];
  }

  // 构建应用名称编辑项
  Widget _buildAppName() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用名称（安装之后的名称）',
        child: TextFormBox(
          initialValue: info.label,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
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
  final _packageNameRegExp = RegExp(r'[A-Za-z0-9.]');

  // 构建应用包名编辑项
  Widget _buildPackageName() {
    final info = logic.platformInfo;
    return buildItem(
      child: InfoLabel(
        label: '应用包名',
        child: TextFormBox(
          initialValue: info.package,
          validator: (v) {
            if (null == v || v.isEmpty) {
              return '不能为空';
            }
            return null;
          },
          onChanged: (v) => info.package = v,
          onSaved: (v) {
            if (null == v || v.isEmpty) return;
            info.package = v;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(_packageNameRegExp),
          ],
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
                Expanded(child: _buildPermissionManageList(f)),
              ],
            ),
          ),
        );
      },
    );
  }

  // 构建权限管理项头部
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
                platformType: PlatformType.android,
                initialPermissions: f.value,
              ).then((v) {
                if (null != v) f.didChange(v);
              });
            },
          ),
        ],
      ),
    );
  }

  // 构建权限管理项列表
  Widget _buildPermissionManageList(
      FormFieldState<List<PermissionItemModel>> f) {
    return CardItem(
      child: f.value?.isEmpty ?? true
          ? const Center(child: Text('还未添加任何权限哦~'))
          : ListView.separated(
              shrinkWrap: true,
              itemCount: f.value?.length ?? 0,
              separatorBuilder: (_, i) => const ThicknessDivider(),
              itemBuilder: (_, i) => _buildPermissionManageItem(f, i),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.name ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(item?.describe ?? ''),
                Text(item?.value ?? ''),
              ],
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
* android平台-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 16:09
*/
class _PlatformAndroidPageLogic extends BasePlatformPageLogic<AndroidPlatform> {
  // 权限管理的展示倍数
  final permissionExpand = ValueChangeNotifier<bool>(false);

  _PlatformAndroidPageLogic(super.platformInfo);

  @override
  void dispose() {
    permissionExpand.dispose();
    super.dispose();
  }
}
