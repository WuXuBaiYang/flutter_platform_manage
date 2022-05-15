// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends _Project with RealmEntity, RealmObject {
  Project(
    String primaryKey,
    String name,
    String path,
    String environmentKey,
    int sourceType, {
    GitSource? gitSource,
    PubspecFile? pubspecFile,
    AndroidPlatform? androidPlatform,
    IOSPlatform? iosPlatform,
    WebPlatform? webPlatform,
    LinuxPlatform? linuxPlatform,
    MacosPlatform? macosPlatform,
    WindowsPlatform? windowsPlatform,
  }) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'environmentKey', environmentKey);
    RealmObject.set(this, 'sourceType', sourceType);
    RealmObject.set(this, 'gitSource', gitSource);
    RealmObject.set(this, 'pubspecFile', pubspecFile);
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
  String get name => RealmObject.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObject.set(this, 'name', value);

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  String get environmentKey =>
      RealmObject.get<String>(this, 'environmentKey') as String;
  @override
  set environmentKey(String value) =>
      RealmObject.set(this, 'environmentKey', value);

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
  PubspecFile? get pubspecFile =>
      RealmObject.get<PubspecFile>(this, 'pubspecFile') as PubspecFile?;
  @override
  set pubspecFile(covariant PubspecFile? value) =>
      RealmObject.set(this, 'pubspecFile', value);

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
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('environmentKey', RealmPropertyType.string),
      SchemaProperty('sourceType', RealmPropertyType.int),
      SchemaProperty('gitSource', RealmPropertyType.object,
          optional: true, linkTarget: 'GitSource'),
      SchemaProperty('pubspecFile', RealmPropertyType.object,
          optional: true, linkTarget: 'PubspecFile'),
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

class PubspecFile extends _PubspecFile with RealmEntity, RealmObject {
  PubspecFile({
    String? version,
  }) {
    RealmObject.set(this, 'version', version);
  }

  PubspecFile._();

  @override
  String? get version => RealmObject.get<String>(this, 'version') as String?;
  @override
  set version(String? value) => RealmObject.set(this, 'version', value);

  @override
  Stream<RealmObjectChanges<PubspecFile>> get changes =>
      RealmObject.getChanges<PubspecFile>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(PubspecFile._);
    return const SchemaObject(PubspecFile, [
      SchemaProperty('version', RealmPropertyType.string, optional: true),
    ]);
  }
}

class AndroidPlatform extends _AndroidPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  AndroidPlatform({
    String path = "android",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<AndroidPlatform>({
        'path': "android",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  AndroidPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<AndroidPlatform>> get changes =>
      RealmObject.getChanges<AndroidPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(AndroidPlatform._);
    return const SchemaObject(AndroidPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
    ]);
  }
}

class IOSPlatform extends _IOSPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  IOSPlatform({
    String path = "ios",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<IOSPlatform>({
        'path': "ios",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  IOSPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<IOSPlatform>> get changes =>
      RealmObject.getChanges<IOSPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(IOSPlatform._);
    return const SchemaObject(IOSPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
    ]);
  }
}

class WebPlatform extends _WebPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  WebPlatform({
    String path = "web",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<WebPlatform>({
        'path': "web",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  WebPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<WebPlatform>> get changes =>
      RealmObject.getChanges<WebPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(WebPlatform._);
    return const SchemaObject(WebPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
    ]);
  }
}

class LinuxPlatform extends _LinuxPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  LinuxPlatform({
    String path = "linux",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<LinuxPlatform>({
        'path': "linux",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  LinuxPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<LinuxPlatform>> get changes =>
      RealmObject.getChanges<LinuxPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(LinuxPlatform._);
    return const SchemaObject(LinuxPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
    ]);
  }
}

class MacosPlatform extends _MacosPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  MacosPlatform({
    String path = "macos",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<MacosPlatform>({
        'path': "macos",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  MacosPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<MacosPlatform>> get changes =>
      RealmObject.getChanges<MacosPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(MacosPlatform._);
    return const SchemaObject(MacosPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
    ]);
  }
}

class WindowsPlatform extends _WindowsPlatform with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  WindowsPlatform({
    String path = "windows",
    bool exit = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<WindowsPlatform>({
        'path': "windows",
        'exit': false,
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
  }

  WindowsPlatform._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  Stream<RealmObjectChanges<WindowsPlatform>> get changes =>
      RealmObject.getChanges<WindowsPlatform>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(WindowsPlatform._);
    return const SchemaObject(WindowsPlatform, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
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
