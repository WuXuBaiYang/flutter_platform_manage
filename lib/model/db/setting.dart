import 'package:realm/realm.dart';

part 'setting.g.dart';

/*
* 应用设置对象
* @author wuxubaiyang
* @Time 5/12/2022 14:57
*/
@RealmModel()
class _Setting {
  // 主键key
  @PrimaryKey()
  late String primaryKey;

  // git仓库缓存路径
  late String gitRepositoryCachePath;
}
