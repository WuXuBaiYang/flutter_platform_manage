import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/cache_future_builder.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_rename_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_version_dialog.dart';

/*
* 项目功能菜单
* @author JTech JH
* @Time 2022-07-28 15:50:43
*/
class ProjectCommandMenu {
  // 获取功能菜单列表
  static Widget getProjectCommands(
    BuildContext context,
    ProjectModel projectModel,
    CacheFutureBuilderController<ProjectModel> controller,
  ) {
    return Column(
      children: [
        CommandBar(
          mainAxisAlignment: MainAxisAlignment.start,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text("打包"),
              onPressed: () {
                Utils.showSnack(context, "开发中");
              },
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text("版本号"),
              onPressed: () => ProjectVersionDialog.show(
                context,
                projectModel: projectModel,
              ).then((v) {
                if (null != v) controller.refreshValue();
              }),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.access_logo),
              label: const Text("修改名称"),
              onPressed: () => ProjectReNameDialog.show(
                context,
                projectModel: projectModel,
              ).then((v) {
                if (null != v) controller.refreshValue();
              }),
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
          ],
        ),
        CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.refresh),
              label: const Text("刷新"),
              onPressed: () {
                controller.refreshValue();
                Utils.showSnack(context, "项目信息已刷新");
              },
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.app_icon_default_edit),
              label: const Text("编辑"),
              onPressed: () => ProjectImportDialog.show(
                context,
                project: projectModel.project,
              ).then((v) {
                if (null != v) controller.refreshValue();
              }),
            ),
            CommandBarButton(
              icon: Icon(FluentIcons.delete, color: Colors.red),
              label: Text("删除", style: TextStyle(color: Colors.red)),
              onPressed: () => ImportantOptionDialog.show(
                context,
                message: "是否删除该项目 ${projectModel.getShowTitle()}",
                confirm: "删除",
                onConfirmTap: () {
                  dbManage.delete(projectModel.project);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
