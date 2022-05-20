// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends _Project with RealmEntity, RealmObject {
  Project(
    String primaryKey,
    String path,
    String environmentKey,
    int sourceType, {
    String? alias,
    GitSource? gitSource,
  }) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'alias', alias);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'environmentKey', environmentKey);
    RealmObject.set(this, 'sourceType', sourceType);
    RealmObject.set(this, 'gitSource', gitSource);
  }

  Project._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String? get alias => RealmObject.get<String>(this, 'alias') as String?;
  @override
  set alias(String? value) => RealmObject.set(this, 'alias', value);

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
  Stream<RealmObjectChanges<Project>> get changes =>
      RealmObject.getChanges<Project>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Project._);
    return const SchemaObject(Project, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('alias', RealmPropertyType.string, optional: true),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('environmentKey', RealmPropertyType.string),
      SchemaProperty('sourceType', RealmPropertyType.int),
      SchemaProperty('gitSource', RealmPropertyType.object,
          optional: true, linkTarget: 'GitSource'),
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
