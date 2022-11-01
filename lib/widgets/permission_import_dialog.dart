import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/permission.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/debouncer.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

/*
* 权限导入弹窗
* @author wuxubaiyang
* @Time 2022-08-01 17:10:15
*/
class PermissionImportDialog extends StatefulWidget {
  // 已导入权限集合
  final List<PermissionItemModel> initialPermissions;

  // 平台类型
  final PlatformType platformType;

  const PermissionImportDialog({
    Key? key,
    required this.initialPermissions,
    required this.platformType,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<List<PermissionItemModel>?> show(
    BuildContext context, {
    List<PermissionItemModel>? initialPermissions,
    required PlatformType platformType,
  }) {
    return showDialog<List<PermissionItemModel>>(
      context: context,
      builder: (_) => PermissionImportDialog(
        initialPermissions: initialPermissions ?? [],
        platformType: platformType,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _PermissionImportDialogState();
}

/*
* 权限导入弹窗-状态
* @author wuxubaiyang
* @Time 2022-08-01 17:11:57
*/
class _PermissionImportDialogState extends State<PermissionImportDialog> {
  // 逻辑管理
  late final _PermissionImportDialogLogic _logic =
      _PermissionImportDialogLogic(widget.initialPermissions);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxHeight: 450,
        maxWidth: 350,
      ),
      content: Column(
        children: [
          _buildFilterSearch(),
          Expanded(child: _buildPermissionList()),
        ],
      ),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          child: const Text('选择'),
          onPressed: () =>
              Navigator.pop(context, _logic.permissionListController.value),
        ),
      ],
    );
  }

  // 构建过滤搜索框
  Widget _buildFilterSearch() {
    return StatefulBuilder(
      builder: (_, state) {
        return InfoLabel(
          label: '权限列表过滤',
          child: TextBox(
            autofocus: true,
            controller: _logic.searchController,
            placeholder: '根据名称/描述/值进行过滤',
            onChanged: (v) {
              deBouncer(() => setState(() {}));
              state(() {});
            },
            onEditingComplete: () => setState(() {}),
            suffix: Visibility(
              visible: _logic.searchController.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () =>
                    setState(() => _logic.searchController.clear()),
              ),
            ),
            outsideSuffix: _buildFilterComboBox(),
          ),
        );
      },
    );
  }

  // 构建过滤下拉框
  Widget _buildFilterComboBox() {
    return ValueListenableBuilder<PermissionFilter>(
      valueListenable: _logic.filterController,
      builder: (_, filter, __) {
        return Container(
          padding: const EdgeInsets.only(left: 6),
          width: 100,
          child: ComboBox<PermissionFilter>(
            value: filter,
            onChanged: (v) {
              if (null != v) {
                _logic.filterController.setValue(v);
              }
            },
            items: List.generate(PermissionFilter.values.length, (i) {
              final it = PermissionFilter.values[i];
              return ComboBoxItem(
                value: it,
                child: Text(it.name),
              );
            }),
          ),
        );
      },
    );
  }

  // 构建权限列表
  Widget _buildPermissionList() {
    return ValueListenableBuilder(
      valueListenable: _logic.filterController,
      builder: (_, __, ___) {
        return FutureBuilder<List<PermissionItemModel>>(
          future: _logic.loadPermissionsItems(widget.platformType),
          builder: (_, snap) {
            if (snap.hasError) {
              return const Center(
                child: Text('权限列表加载失败，请关闭重试'),
              );
            }
            if (snap.hasData) {
              final list = snap.data!;
              return ValueListenableBuilder(
                valueListenable: _logic.permissionListController,
                builder: (_, __, ___) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, i) => const ThicknessDivider(
                      horizontalMargin: EdgeInsets.zero,
                    ),
                    itemBuilder: (_, i) => _buildPermissionListItem(list[i]),
                  );
                },
              );
            }
            return const Center(
              child: ProgressRing(),
            );
          },
        );
      },
    );
  }

  // 构建权限列表子项
  Widget _buildPermissionListItem(PermissionItemModel item) {
    final checked = _logic.hasPermission(item);
    return ListTile(
      title: Text(
        item.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.hint ?? item.describe ?? '',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Checkbox(
        checked: checked,
        onChanged: (v) => _logic.permissionSelected(checked, item),
      ),
      onPressed: () => _logic.permissionSelected(checked, item),
    );
  }
}

/*
* 权限导入弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 11:12
*/
class _PermissionImportDialogLogic extends BaseLogic {
  // 已选择权限集合
  final ListValueChangeNotifier<PermissionItemModel> permissionListController;

  // 记录当前过滤状态
  final filterController =
      ValueChangeNotifier<PermissionFilter>(PermissionFilter.all);

  // 过滤框控制器
  final searchController = TextEditingController();

  _PermissionImportDialogLogic(List<PermissionItemModel> permissionList)
      : permissionListController = ListValueChangeNotifier(permissionList);

  // 缓存所有权限集合
  List<PermissionItemModel>? _cachePermissionList;

  // 加载权限子项集合
  Future<List<PermissionItemModel>> loadPermissionsItems(
      PlatformType type) async {
    _cachePermissionList ??= permissionManage.getPermissionListByPlatform(type);
    var searchValue = searchController.text;
    return _cachePermissionList!.where((e) {
      switch (filterController.value) {
        case PermissionFilter.selected:
          if (!hasPermission(e)) return false;
          break;
        case PermissionFilter.unselected:
          if (hasPermission(e)) return false;
          break;
        case PermissionFilter.all:
          break;
      }
      return e.searchContains(searchValue);
    }).toList();
  }

  // 权限选中动作
  void permissionSelected(bool checked, PermissionItemModel item) {
    if (checked) {
      permissionListController.removeValue(item);
    } else {
      permissionListController.addValue([item]);
    }
  }

  // 判断是否已包含权限
  bool hasPermission(PermissionItemModel item) =>
      permissionListController.contains(item);
}

// 过滤状态枚举
enum PermissionFilter { all, selected, unselected }

// 过滤状态枚举扩展
extension PermissionFilterExtension on PermissionFilter {
  // 获取过滤名称
  String get name => {
        PermissionFilter.selected: '已选择',
        PermissionFilter.unselected: '未选择',
        PermissionFilter.all: '全部',
      }[this]!;
}
