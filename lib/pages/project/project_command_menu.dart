import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 项目功能菜单
* @author JTech JH
* @Time 2022-07-28 15:50:43
*/
class ProjectCommandMenu {
  // 获取功能菜单列表
  static List<CommandBarItem> getCommandList(BuildContext context) => [
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
            Utils.showSnack(context, "开发中");
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
