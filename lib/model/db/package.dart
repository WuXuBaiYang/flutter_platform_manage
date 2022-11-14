import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:isar/isar.dart';

part 'package.g.dart';

@collection
class Package {
  // 主键id
  Id id = Isar.autoIncrement;

  // 项目id
  int projectId = 0;

  // 打包目标平台
  @enumerated
  PlatformType platform = PlatformType.android;

  // 状态
  @enumerated
  PackageStatus status = PackageStatus.stop;

  // 打包使用的脚本
  String script = '';

  // 完成时间
  @Index(type: IndexType.value)
  DateTime? completeTime;

  // 所用时间
  int? timeSpent;

  // 输入路径
  String? outputPath;

  // 打包大小
  int? packageSize;
}

// 打包状态枚举
enum PackageStatus { packing, prepare, stop, fail, completed }
