import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/cache_manage.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/pages/home/home_page.dart';
import 'package:window_manager/window_manager.dart';

// 记录debug状态
const bool debugMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化窗口管理
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(1280, 720));
    await windowManager.setMinimumSize(const Size(1280, 720));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
  });
  // 初始化业务
  await dbManage.init();
  await jCache.init();
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
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
