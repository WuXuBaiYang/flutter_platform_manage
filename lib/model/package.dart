import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/date.dart';

/*
* 打包信息包装
* @author wuxubaiyang
* @Time 2022/11/11 21:06
*/
class PackageModel {
  // 打包信息
  final Package package;

  // 项目信息
  final ProjectModel? projectInfo;

  PackageModel({
    required this.package,
    required this.projectInfo,
  });

  // 获取完成时间
  String get completeTime {
    final date = package.completeTime;
    if (date == null) return '项目尚未完成';
    return date.format(DatePattern.fullDateTime);
  }

  // 打包所用时间
  String get timeSpent {
    final time = package.timeSpent;
    if (time == null) return '项目尚未完成';
    return Duration(milliseconds: time).format(DurationPattern.fullTime);
  }
}
