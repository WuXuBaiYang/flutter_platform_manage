import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

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
class _PackageRecordPageState
    extends LogicState<PackageRecordPage, _PackageRecordPageLogic> {
  @override
  _PackageRecordPageLogic initLogic() => _PackageRecordPageLogic();

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(child: Text('功能开发中')),
    );
  }
}

/*
* 打包记录页-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 14:31
*/
class _PackageRecordPageLogic extends BaseLogic {}
