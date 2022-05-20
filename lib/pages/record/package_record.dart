import 'package:fluent_ui/fluent_ui.dart';

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
  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Text("正在开发"),
    );
  }
}
