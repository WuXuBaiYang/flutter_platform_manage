import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';

/*
* 打包记录页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class PackageRecordPage extends StatefulWidget {
  const PackageRecordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PackageRecordPageState();
}

/*
* 打包记录页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _PackageRecordPageState extends State<PackageRecordPage> {
  // 逻辑管理
  final _logic = _PackageRecordPageLogic();

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(child: Text('功能开发中')),
    );
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }
}

/*
* 打包记录页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 14:31
*/
class _PackageRecordPageLogic extends BaseLogic {}
