import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/project_rename_dialog.dart';

/*
* 项目功能菜单
* @author JTech JH
* @Time 2022-07-28 15:50:43
*/
class ProjectCommandMenu {
  // 获取功能菜单列表
  static List<CommandBarItem> getCommandList(
    BuildContext context,
    CacheFutureBuilderController<ProjectModel> controller,
  ) =>
      [
        CommandBarButton(
          icon: const Icon(FluentIcons.access_logo),
          label: const Text("打包"),
          onPressed: () {
            Utils.showSnack(context, "开发中");
          },
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.access_logo),
          label: const Text("修改名称"),
          onPressed: () {
            if (null == controller.value) return;
            ProjectReNameDialog.show(
              context,
              projectInfo: controller.value!,
            ).then((v) {
              if (null != v) controller.refreshValue();
            });
          },
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.access_logo),
          label: const Text("添加权限"),
          onPressed: () {
            Utils.showSnack(context, "开发中");
          },
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.access_logo),
          label: const Text("替换图标"),
          onPressed: () {
            Utils.showSnack(context, "开发中");
          },
        ),
        CommandBarButton(
          icon: const Icon(FluentIcons.access_logo),
          label: const Text("修改版本号"),
          onPressed: () {
            Utils.showSnack(context, "开发中");
          },
        ),
      ];
}
