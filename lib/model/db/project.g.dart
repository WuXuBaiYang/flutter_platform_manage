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
  }) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'name', name);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'environmentKey', environmentKey);
    RealmObject.set(this, 'sourceType', sourceType);
    RealmObject.set(this, 'gitSource', gitSource);
    RealmObject.set(this, 'pubspecFile', pubspecFile);
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
    ]);
  }
}

class PubspecFile extends _PubspecFile with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  PubspecFile(
    bool exit,
    String version, {
    String path = "pubspec.yaml",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<PubspecFile>({
        'path': "pubspec.yaml",
      });
    }
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'exit', exit);
    RealmObject.set(this, 'version', version);
  }

  PubspecFile._();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  bool get exit => RealmObject.get<bool>(this, 'exit') as bool;
  @override
  set exit(bool value) => RealmObject.set(this, 'exit', value);

  @override
  String get version => RealmObject.get<String>(this, 'version') as String;
  @override
  set version(String value) => RealmObject.set(this, 'version', value);

  @override
  Stream<RealmObjectChanges<PubspecFile>> get changes =>
      RealmObject.getChanges<PubspecFile>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(PubspecFile._);
    return const SchemaObject(PubspecFile, [
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('exit', RealmPropertyType.bool),
      SchemaProperty('version', RealmPropertyType.string),
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
