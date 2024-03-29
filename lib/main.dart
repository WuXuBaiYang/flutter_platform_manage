import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/common/route_path.dart';
import 'package:flutter_platform_manage/manager/cache.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/event.dart';
import 'package:flutter_platform_manage/manager/package_task.dart';
import 'package:flutter_platform_manage/manager/permission.dart';
import 'package:flutter_platform_manage/manager/router.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/event/theme.dart';
import 'package:flutter_platform_manage/pages/home.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化窗口管理
  await WindowManager.instance.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
      windowButtonVisibility: false);
  await windowManager.setSize(Common.windowSize);
  await windowManager.setMinimumSize(Common.windowMinimumSize);
  await windowManager.setMaximumSize(Common.windowMaximumSize);
  await windowManager.setPreventClose(true);
  await windowManager.setSkipTaskbar(false);
  await windowManager.show();
  // 初始化业务
  await dbManage.init();
  await cacheManage.init();
  await eventManage.init();
  await permissionManage.init();
  await packageTaskManage.init();
  // 启动应用
  runApp(const MyApp());
}

/*
* 应用入口
* @author wuxubaiyang
* @Time 5/18/2022 10:40 AM
*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeEvent>(
      initialData: ThemeEvent(
        themeType: themeManage.currentType,
        fontFamily: themeManage.currentFontFamily,
      ),
      stream: eventManage.on<ThemeEvent>(),
      builder: (_, snap) {
        final event = snap.data;
        return FluentApp(
          debugShowCheckedModeBanner: kDebugMode,
          navigatorKey: jRouter.navigateKey,
          routes: RoutePath.routeMap,
          theme: event?.themeType.getTheme(
            fontFamily: event.fontFamily.family,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
