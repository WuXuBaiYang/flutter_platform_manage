/*
* 项目文件路径
* @author wuxubaiyang
* @Time 5/15/2022 10:30 AM
*/
import 'package:flutter_platform_manage/model/platform/platform.dart';

class ProjectFilePath {
  // pubspec.yaml
  static const String pubspec = 'pubspec.yaml';

  // flutter
  static const String flutter = 'bin/flutter';

  // android/build.gradle
  static const String androidBuildGradle = 'build.gradle';

  // android/app/build.gradle
  static const String androidAppBuildGradle = 'app/build.gradle';

  // android/app/src/main/AndroidManifest.xml
  static const String androidManifest = 'app/src/main/AndroidManifest.xml';

  // android/app/src/main/res/
  static const String androidRes = 'app/src/main/res';

  // ios/Runner/info.plist
  static const String iosInfoPlist = 'Runner/info.plist';

  // ios/Runner/Assets.xcassets/AppIcon.appiconset
  static const String iosAssetsAppIcon =
      'Runner/Assets.xcassets/AppIcon.appiconset';

  // macos/Runner/info.plist
  static const String macosInfoPlist = 'Runner/info.plist';

  // DebugProfile.entitlements
  static const String debugProfilePlist = 'Runner/DebugProfile.entitlements';

  // Release.entitlements
  static const String releasePlist = 'Runner/Release.entitlements';

  // macos/Runner/Assets.xcassets/AppIcon.appiconset
  static const String macosAssetsAppIcon =
      'Runner/Assets.xcassets/AppIcon.appiconset';

  // web/manifest.json
  static const String webManifest = 'manifest.json';

  // 项目打包输出目录
  static const String packageOutput = 'PlatformManager/outputs';

  // android打包输出文件路径
  static String getPlatformOutput(PlatformType platformType) => {
        PlatformType.android: 'build/app/outputs/apk/release/app-release.apk',
        PlatformType.ios: '',
        PlatformType.web: 'build/web',
        PlatformType.windows: 'build/windows',
        PlatformType.macos: '',
        PlatformType.linux: '',
      }[platformType]!;
}
