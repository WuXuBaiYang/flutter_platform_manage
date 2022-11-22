import 'package:flutter/material.dart';
import 'package:flutter_platform_manage/common/manage.dart';

/*
* 路由管理类
* @author wuxubaiyang
* @Time 2022/3/17 14:19
*/
class JRouter extends BaseManage {
  static final JRouter _instance = JRouter._internal();

  factory JRouter() => _instance;

  //全局路由key
  final GlobalKey<NavigatorState> navigateKey;

  RouteTransitionsBuilder? _transitionsBuilder;

  JRouter._internal()
      : navigateKey = GlobalKey(debugLabel: 'JRouterNavigateKey');

  //获取路由对象
  NavigatorState? get navigator => navigateKey.currentState;

  //设置基础参数
  Future<void> setup({
    RouteTransitionsBuilder? transitionsBuilder,
  }) async {
    _transitionsBuilder = transitionsBuilder;
  }

  //获取页面参数
  V? findInMap<V>(BuildContext context, String key) {
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map) return arguments[key] as V;
    return null;
  }

  //页面跳转
  Future<T?>? push<T>(
    RoutePageBuilder builder, {
    String? name,
    Object? arguments,
    bool? opaque,
    Color? barrierColor,
    bool? barrierDismissible,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
    bool fullscreenDialog = false,
  }) {
    return navigator?.push<T>(_createPageRoute<T>(
      builder: builder,
      name: name,
      arguments: arguments,
      opaque: opaque,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: transitionsBuilder,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  //页面跳转
  Future<T?>? pushNamed<T>(String url, {Map<String, dynamic>? parameters}) {
    final uri = Uri.parse(url);
    return navigator?.pushNamed<T>(
      uri.path,
      arguments: {
        ...parameters ?? {},
        ...uri.queryParameters,
      },
    );
  }

  //页面跳转并移除到目标页面
  Future<T?>? pushAndRemoveUntil<T>(
    RoutePageBuilder builder, {
    required untilPath,
    String? name,
    Object? arguments,
    bool? opaque,
    Color? barrierColor,
    bool? barrierDismissible,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
    bool fullscreenDialog = false,
  }) {
    return navigator?.pushAndRemoveUntil<T>(
      _createPageRoute<T>(
        builder: builder,
        name: name,
        arguments: arguments,
        opaque: opaque,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        transitionsBuilder: transitionsBuilder,
        fullscreenDialog: fullscreenDialog,
      ),
      ModalRoute.withName(untilPath),
    );
  }

  //跳转页面并一直退出到目标页面
  Future<T?>? pushNamedAndRemoveUntil<T>(String url, {required untilPath}) {
    var uri = Uri.parse(url);
    return navigator?.pushNamedAndRemoveUntil<T>(
      uri.path,
      ModalRoute.withName(untilPath),
      arguments: uri.queryParameters,
    );
  }

  //跳转页面并一直退出到目标页面
  Future<T?>? pushReplacement<T, TO>(
    RoutePageBuilder builder, {
    String? name,
    Object? arguments,
    bool? opaque,
    Color? barrierColor,
    bool? barrierDismissible,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
    bool fullscreenDialog = false,
  }) {
    return navigator?.pushReplacement<T, TO>(_createPageRoute<T>(
      builder: builder,
      name: name,
      arguments: arguments,
      opaque: opaque,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: transitionsBuilder,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  //跳转并替换当前页面
  Future<T?>? pushReplacementNamed<T, TO>(String url, {TO? result}) {
    var uri = Uri.parse(url);
    return navigator?.pushReplacementNamed<T, TO>(
      uri.path,
      result: result,
      arguments: uri.queryParameters,
    );
  }

  //退出当前页面并跳转目标页面
  Future<T?>? popAndPushNamed<T, TO>(String url, {TO? result}) {
    var uri = Uri.parse(url);
    return navigator?.popAndPushNamed<T, TO>(
      uri.path,
      result: result,
      arguments: uri.queryParameters,
    );
  }

  //创建Material风格的页面路由对象
  PageRouteBuilder<T> _createPageRoute<T>({
    required RoutePageBuilder builder,
    String? name,
    Object? arguments,
    bool? opaque,
    Color? barrierColor,
    bool? barrierDismissible,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
    bool fullscreenDialog = false,
  }) {
    //默认值
    transitionsBuilder ??= _transitionsBuilder ?? _defTransitionsBuilderWidget;
    transitionDuration ??= const Duration(milliseconds: 350);
    reverseTransitionDuration ??= const Duration(milliseconds: 350);
    opaque ??= true;
    barrierDismissible ??= false;
    return PageRouteBuilder<T>(
      pageBuilder: builder,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      fullscreenDialog: fullscreenDialog,
      settings: RouteSettings(
        name: name,
        arguments: arguments,
      ),
    );
  }

  //默认页面过渡动画
  Widget _defTransitionsBuilderWidget(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    var begin = const Offset(0, 1);
    var end = Offset.zero;
    var curve = Curves.ease;
    var tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  //页面退出
  Future<bool>? maybePop<T>([T? result]) => navigator?.maybePop<T>(result);

  //页面退出
  void pop<T>([T? result]) => navigator?.pop<T>(result);

  //判断页面是否可退出
  bool? canPop() => navigator?.canPop();

  //页面连续退出
  void popUntil({required String untilPath}) =>
      navigator?.popUntil(ModalRoute.withName(untilPath));
}

//单例调用
final jRouter = JRouter();
