import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';

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
          TextBox(
            autofocus: true,
            controller: controller,
            placeholder: "根据名称/描述/值进行过滤",
            onChanged: (v) => setState(() {}),
            suffix: Visibility(
              visible: controller.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () => setState(() => controller.clear()),
              ),
            ),
            outsideSuffix: Container(
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
            ),
          ),
          FutureBuilder<List<PermissionItemModel>>(
            future: loadPermissionsItems(),
            builder: (_, snap) {
              return SizedBox();
            },
          )
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

  // 加载权限子项集合
  Future<List<PermissionItemModel>> loadPermissionsItems() async {
    return [];
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
