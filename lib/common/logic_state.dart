import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';

/*
* 带有逻辑管理结构的状态基类
* @author wuxubaiyang
* @Time 2022/11/2 11:19
*/
abstract class LogicState<T extends StatefulWidget, C extends BaseLogic>
    extends State<T> {
  // 初始化逻辑管理
  C initLogic();

  // 缓存逻辑管理对象
  C? _cacheLogic;

  // 获取逻辑对象
  C get logic => _cacheLogic ??= initLogic();

  @override
  void initState() {
    super.initState();
    logic.init();
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }
}
