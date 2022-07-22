import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/pages/project/project_detail_page.dart';

/*
* 路由路径
* @author JTech JH
* @Time 2022-07-22 11:35:59
*/
class RoutePath {
  // 项目详情页
  static const String projectDetail = "/project/detail";

  // 获取路由表
  static Map<String, WidgetBuilder> get routeMap => {
        projectDetail: (_) => const ProjectDetailPage(),
      };
}
