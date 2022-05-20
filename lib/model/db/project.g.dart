// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends _Project with RealmEntity, RealmObject {
  Project(
    String primaryKey,
    String alias,
    String path,
    bool exit,
    String environmentKey,
    int sourceType, {
    String? name,
    String? version,
    GitSource? gitSource,
    AndroidPlatform? androidPlatform,
    IOSPlatform? iosPlatform,
    WebPlatform? webPlatform,
    LinuxPlatform? linuxPlatform,
    MacosPlatform? macosPlatform,
    WindowsPlatform? windowsPlatform,
  }) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'alias', alias);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
    RealmObject.set(this, 'environmentKey', environmentKey);
    RealmObject.set(this, 'version', version);
    RealmObject.set(this, 'sourceType', sourceType);
    RealmObject.set(this, 'gitSource', gitSource);
    RealmObject.set(this, 'androidPlatform', androidPlatform);
    RealmObject.set(this, 'iosPlatform', iosPlatform);
    RealmObject.set(this, 'webPlatform', webPlatform);
    RealmObject.set(this, 'linuxPlatform', linuxPlatform);
    RealmObject.set(this, 'macosPlatform', macosPlatform);
    RealmObject.set(this, 'windowsPlatform', windowsPlatform);
  }

  Project._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String? get name => RealmObject.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObject.set(this, 'name', value);

  @override
  String get alias => RealmObject.get<String>(this, 'alias') as String;
  @override
  set alias(String value) => RealmObject.set(this, 'alias', value);

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  String get environmentKey =>
      RealmObject.get<String>(this, 'environmentKey') as String;
  @override
  set environmentKey(String value) =>
      RealmObject.set(this, 'environmentKey', value);

  @override
  String? get version => RealmObject.get<String>(this, 'version') as String?;
  @override
  set version(String? value) => RealmObject.set(this, 'version', value);

  @override
  int get sourceType => RealmObject.get<int>(this, 'sourceType') as int;
  @override
  set sourceType(int value) => RealmObject.set(this, 'sourceType', value);

  @override
  GitSource? get gitSource =>
      RealmObject.get<GitSource>(this, 'gitSource') as GitSource?;
  @override
  set gitSource(covariant GitSource? value) =>
      RealmObject.set(this, 'gitSource', value);

  @override
  AndroidPlatform? get androidPlatform =>
      RealmObject.get<AndroidPlatform>(this, 'androidPlatform')
          as AndroidPlatform?;
  @override
  set androidPlatform(covariant AndroidPlatform? value) =>
      RealmObject.set(this, 'androidPlatform', value);

  @override
  IOSPlatform? get iosPlatform =>
      RealmObject.get<IOSPlatform>(this, 'iosPlatform') as IOSPlatform?;
  @override
  set iosPlatform(covariant IOSPlatform? value) =>
      RealmObject.set(this, 'iosPlatform', value);

  @override
  WebPlatform? get webPlatform =>
      RealmObject.get<WebPlatform>(this, 'webPlatform') as WebPlatform?;
  @override
  set webPlatform(covariant WebPlatform? value) =>
      RealmObject.set(this, 'webPlatform', value);

  @override
  LinuxPlatform? get linuxPlatform =>
      RealmObject.get<LinuxPlatform>(this, 'linuxPlatform') as LinuxPlatform?;
  @override
  set linuxPlatform(covariant LinuxPlatform? value) =>
      RealmObject.set(this, 'linuxPlatform', value);

  @override
  MacosPlatform? get macosPlatform =>
      RealmObject.get<MacosPlatform>(this, 'macosPlatform') as MacosPlatform?;
  @override
  set macosPlatform(covariant MacosPlatform? value) =>
      RealmObject.set(this, 'macosPlatform', value);

  @override
  WindowsPlatform? get windowsPlatform =>
      RealmObject.get<WindowsPlatform>(this, 'windowsPlatform')
          as WindowsPlatform?;
  @override
  set windowsPlatform(covariant WindowsPlatform? value) =>
      RealmObject.set(this, 'windowsPlatform', value);

  @override
  Stream<RealmObjectChanges<Project>> get changes =>
      RealmObject.getChanges<Project>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Project._);
    return const SchemaObject(Project, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('alias', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
      SchemaProperty('environmentKey', RealmPropertyType.string),
      SchemaProperty('version', RealmPropertyType.string, optional: true),
      SchemaProperty('sourceType', RealmPropertyType.int),
      SchemaProperty('gitSource', RealmPropertyType.object,
          optional: true, linkTarget: 'GitSource'),
      SchemaProperty('androidPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'AndroidPlatform'),
      SchemaProperty('iosPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'IOSPlatform'),
      SchemaProperty('webPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'WebPlatform'),
      SchemaProperty('linuxPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'LinuxPlatform'),
      SchemaProperty('macosPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'MacosPlatform'),
      SchemaProperty('windowsPlatform', RealmPropertyType.object,
          optional: true, linkTarget: 'WindowsPlatform'),
    ]);
  }
}

class AndroidPlatform extends _AndroidPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  AndroidPlatform({
    String name = "android",
    String? label,
    String? package,
    String? iconPath,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<AndroidPlatform>({
        'name': "android",
      });
    }
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'label', label);
    RealmObject.set(this, 'package', package);
    RealmObject.set(this, 'iconPath', iconPath);
  }

  AndroidPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  String? get label => RealmObject.get<String>(this, 'label') as String?;
  @override
  set label(String? value) => RealmObject.set(this, 'label', value);

  @override
  String? get package => RealmObject.get<String>(this, 'package') as String?;
  @override
  set package(String? value) => RealmObject.set(this, 'package', value);

  @override
  String? get iconPath => RealmObject.get<String>(this, 'iconPath') as String?;
  @override
  set iconPath(String? value) => RealmObject.set(this, 'iconPath', value);

  @override
  Stream<RealmObjectChanges<AndroidPlatform>> get changes =>
      RealmObject.getChanges<AndroidPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(AndroidPlatform._);
    return const SchemaObject(AndroidPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('label', RealmPropertyType.string, optional: true),
      SchemaProperty('package', RealmPropertyType.string, optional: true),
      SchemaProperty('iconPath', RealmPropertyType.string, optional: true),
    ]);
  }
}

class IOSPlatform extends _IOSPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  IOSPlatform({
    String name = "ios",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<IOSPlatform>({
        'name': "ios",
      });
    }
    RealmObject.set(this, 'name', name);
  }

  IOSPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<IOSPlatform>> get changes =>
      RealmObject.getChanges<IOSPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(IOSPlatform._);
    return const SchemaObject(IOSPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class WebPlatform extends _WebPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  WebPlatform({
    String name = "web",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<WebPlatform>({
        'name': "web",
      });
    }
    RealmObject.set(this, 'name', name);
  }

  WebPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<WebPlatform>> get changes =>
      RealmObject.getChanges<WebPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(WebPlatform._);
    return const SchemaObject(WebPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class LinuxPlatform extends _LinuxPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  LinuxPlatform({
    String name = "linux",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<LinuxPlatform>({
        'name': "linux",
      });
    }
    RealmObject.set(this, 'name', name);
  }

  LinuxPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<LinuxPlatform>> get changes =>
      RealmObject.getChanges<LinuxPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(LinuxPlatform._);
    return const SchemaObject(LinuxPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class MacosPlatform extends _MacosPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  MacosPlatform({
    String name = "macos",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<MacosPlatform>({
        'name': "macos",
      });
    }
    RealmObject.set(this, 'name', name);
  }

  MacosPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<MacosPlatform>> get changes =>
      RealmObject.getChanges<MacosPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(MacosPlatform._);
    return const SchemaObject(MacosPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class WindowsPlatform extends _WindowsPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  WindowsPlatform({
    String name = "windows",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<WindowsPlatform>({
        'name': "windows",
      });
    }
    RealmObject.set(this, 'name', name);
  }

  WindowsPlatform._();

  @override
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<WindowsPlatform>> get changes =>
      RealmObject.getChanges<WindowsPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(WindowsPlatform._);
    return const SchemaObject(WindowsPlatform, [
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }
}

class GitSource extends _GitSource with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  GitSource(
    String url, {
    int authType = 0,
    bool autoPull = true,
    String authHTTPSUsername = "",
    String authHTTPSPassword = "",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<GitSource>({
        'authType': 0,
        'autoPull': true,
        'authHTTPSUsername': "",
        'authHTTPSPassword': "",
      });
    }
    RealmObject.set(this, 'url', url);
    RealmObject.set(this, 'authType', authType);
    RealmObject.set(this, 'autoPull', autoPull);
    RealmObject.set(this, 'authHTTPSUsername', authHTTPSUsername);
    RealmObject.set(this, 'authHTTPSPassword', authHTTPSPassword);
  }

  GitSource._();

  @override
  String get url => RealmObject.get<String>(this, 'url') as String;
  @override
  set url(String value) => RealmObject.set(this, 'url', value);

  @override
  int get authType => RealmObject.get<int>(this, 'authType') as int;
  @override
  set authType(int value) => RealmObject.set(this, 'authType', value);

  @override
  bool get autoPull => RealmObject.get<bool>(this, 'autoPull') as bool;
  @override
  set autoPull(bool value) => RealmObject.set(this, 'autoPull', value);

  @override
  String get authHTTPSUsername =>
      RealmObject.get<String>(this, 'authHTTPSUsername') as String;
  @override
  set authHTTPSUsername(String value) =>
      RealmObject.set(this, 'authHTTPSUsername', value);

  @override
  String get authHTTPSPassword =>
      RealmObject.get<String>(this, 'authHTTPSPassword') as String;
  @override
  set authHTTPSPassword(String value) =>
      RealmObject.set(this, 'authHTTPSPassword', value);

  @override
  Stream<RealmObjectChanges<GitSource>> get changes =>
      RealmObject.getChanges<GitSource>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(GitSource._);
    return const SchemaObject(GitSource, [
      SchemaProperty('url', RealmPropertyType.string),
      SchemaProperty('authType', RealmPropertyType.int),
      SchemaProperty('autoPull', RealmPropertyType.bool),
      SchemaProperty('authHTTPSUsername', RealmPropertyType.string),
      SchemaProperty('authHTTPSPassword', RealmPropertyType.string),
    ]);
  }
}
