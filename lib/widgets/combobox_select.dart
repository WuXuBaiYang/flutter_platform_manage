import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 获取参数回调
typedef OnSelectGetValue<T> = T? Function(ProjectModel? v);

/*
* 项目选择下拉框
* @author wuxubaiyang
* @Time 2022/11/17 9:57
*/
class ProjectSelectComboBox<T> extends StatelessWidget {
  // 初始值
  final T? value;

  // 额外参数
  final List<ComboBoxItem<T>> additional;

  // 选择回调
  final ValueChanged<T?>? onChanged;

  // 获取参数值
  final OnSelectGetValue<T> getValue;

  // 是否展开
  final bool isExpanded;

  // 是否加载简易项目信息
  final bool simple;

  const ProjectSelectComboBox({
    Key? key,
    this.value,
    this.additional = const [],
    this.onChanged,
    this.isExpanded = false,
    this.simple = true,
    required this.getValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CacheFutureBuilder<List<ProjectModel>>(
      future: () => dbManage.loadAllProjectInfos(simple: simple),
      builder: (_, snap) {
        final projects = snap.data ?? [];
        return ComboBox<T>(
          isExpanded: isExpanded,
          value: value,
          items: projects.map(_buildProjectSelectItem).toList()
            ..addAll(additional),
          onChanged: onChanged,
        );
      },
    );
  }

  // 构建项目选择子项
  ComboBoxItem<T> _buildProjectSelectItem(ProjectModel e) {
    return ComboBoxItem<T>(
      value: getValue(e),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ProjectLogo.custom(
            projectIcon: e.projectIcon,
            size: const Size.square(15),
          ),
          const SizedBox(width: 8),
          Text(
            e.showTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/*
* 平台选择下拉框
* @author wuxubaiyang
* @Time 2022/11/17 10:39
*/
class PlatformSelectComboBox extends StatelessWidget {
  // 初始值
  final PlatformType? value;

  // 平台集合
  final List<PlatformType>? platforms;

  // 选择回调
  final ValueChanged<PlatformType?>? onChanged;

  // 是否展开
  final bool isExpanded;

  const PlatformSelectComboBox({
    Key? key,
    this.value,
    this.onChanged,
    this.platforms,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComboBox<PlatformType>(
      isExpanded: isExpanded,
      value: value,
      items: (platforms ?? PlatformType.values)
          .map(_buildPlatformSelectItem)
          .toList(),
      onChanged: onChanged,
    );
  }

  // 构建平台选择子项
  ComboBoxItem<PlatformType> _buildPlatformSelectItem(PlatformType e) {
    return ComboBoxItem<PlatformType>(
      value: e,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset(
            e.platformImage,
            color: Colors.white,
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 8),
          Text(
            e.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
