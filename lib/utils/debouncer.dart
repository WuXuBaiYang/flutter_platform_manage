import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';

/*
* 输入防抖
* @author JTech JH
* @Time 2022-08-02 09:29:43
*/
class DeBouncer {
  final int milliseconds;
  Timer? _timer;

  DeBouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

// 防抖方法定义
DeBouncer? _deBouncer;
/*
* 输入防抖快捷方法
* @author JTech JH
* @Time 2022-08-02 09:31:26
*/
void deBouncer(VoidCallback action) {
  _deBouncer ??= DeBouncer(milliseconds: 300);
  return _deBouncer?.run(action);
}
