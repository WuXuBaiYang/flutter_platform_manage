import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/permission_manage.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/debouncer.dart';
import 'package:flutter_platform_manage/widgets/flyout_message.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

/*
* 权限导入弹窗
* @author JTech JH
* @Time 2022-08-01 17:10:15
*/
class PermissionImportDialog extends StatefulWidget {
  // 已导入权限集合
  final List<PermissionItemModel> permissions;

  // 平台类型
  final PlatformType platformType;

  const PermissionImportDialog({
    Key? key,
    required this.permissions,
    required this.platformType,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<List<PermissionItemModel>?> show(
    BuildContext context, {
    List<PermissionItemModel>? permissions,
    required PlatformType platformType,
  }) {
    return showDialog<List<PermissionItemModel>>(
      context: context,
      builder: (_) => PermissionImportDialog(
        permissions: permissions ?? [],
        platformType: platformType,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _PermissionImportDialogState();
}

/*
* 权限导入弹窗-状态
* @author JTech JH
* @Time 2022-08-01 17:11:57
*/
class _PermissionImportDialogState extends State<PermissionImportDialog> {
  // 记录当前过滤状态
  PermissionFilter filter = PermissionFilter.all;

  // 过滤框控制器
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxHeight: 450,
        maxWidth: 350,
      ),
      content: Column(
        children: [
          buildFilterSearch(),
          Expanded(child: buildPermissionList()),
        ],
      ),
      actions: [
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          child: const Text("选择"),
          onPressed: () => Navigator.pop(context, widget.permissions),
        ),
      ],
    );
  }

  // 构建过滤搜索框
  Widget buildFilterSearch() {
    return StatefulBuilder(
      builder: (_, state) {
        return InfoLabel(
          label: "权限列表过滤",
          child: TextBox(
            autofocus: true,
            controller: controller,
            placeholder: "根据名称/描述/值进行过滤",
            onChanged: (v) {
              deBouncer(() => setState(() {}));
              state(() {});
            },
            onEditingComplete: () => setState(() {}),
            suffix: Visibility(
              visible: controller.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () => setState(() => controller.clear()),
              ),
            ),
            outsideSuffix: buildFilterCombobox(),
          ),
        );
      },
    );
  }

  // 构建过滤下拉框
  Widget buildFilterCombobox() {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      width: 90,
      child: Card(
        elevation: 1,
        padding: EdgeInsets.zero,
        child: Combobox<PermissionFilter>(
          value: filter,
          onChanged: (v) {
            if (null != v) {
              setState(() => filter = v);
            }
          },
          items: List.generate(PermissionFilter.values.length, (i) {
            var it = PermissionFilter.values[i];
            return ComboboxItem(
              value: it,
              child: Text(it.name),
            );
          }),
        ),
      ),
    );
  }

  // 构建权限列表
  Widget buildPermissionList() {
    return FutureBuilder<List<PermissionItemModel>>(
      future: loadPermissionsItems(),
      builder: (_, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("权限列表加载失败，请关闭重试"),
          );
        }
        if (snap.hasData) {
          var list = snap.data!;
          return ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (_, i) => const ThicknessDivider(
              horizontalMargin: EdgeInsets.zero,
            ),
            itemBuilder: (_, i) {
              var item = list[i];
              var checked = widget.permissions.contains(item);
              return TappableListTile(
                isThreeLine: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                title: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item.describe,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Checkbox(
                  checked: checked,
                  onChanged: (v) => permissionSelected(checked, item),
                ),
                onTap: () => permissionSelected(checked, item),
              );
            },
          );
        }
        return const Center(
          child: ProgressRing(),
        );
      },
    );
  }

  // 权限选中动作
  void permissionSelected(bool checked, PermissionItemModel item) {
    return setState(() => checked
        ? widget.permissions.remove(item)
        : widget.permissions.add(item));
  }

  // 缓存所有权限集合
  List<PermissionItemModel>? permissionList;

  // 加载权限子项集合
  Future<List<PermissionItemModel>> loadPermissionsItems() async {
    permissionList ??= permissionManage.getPermissionsByPlatform(
      widget.platformType,
    );
    var searchValue = controller.text;
    return permissionList!.where((e) {
      switch (filter) {
        case PermissionFilter.selected:
          if (!widget.permissions.contains(e)) return false;
          break;
        case PermissionFilter.unselected:
          if (widget.permissions.contains(e)) return false;
          break;
        case PermissionFilter.all:
          break;
      }
      return e.searchContains(searchValue);
    }).toList();
  }
}

/*
* 过滤状态枚举
* @author JTech JH
* @Time 2022-08-01 17:45:32
*/
enum PermissionFilter { all, selected, unselected }

/*
* 过滤状态枚举扩展
* @author JTech JH
* @Time 2022-08-01 17:46:06
*/
extension PermissionFilterExtension on PermissionFilter {
  // 获取过滤名称
  String get name {
    switch (this) {
      case PermissionFilter.selected:
        return "已选择";
      case PermissionFilter.unselected:
        return "未选择";
      case PermissionFilter.all:
      default:
        return "全部";
    }
  }
}
