// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends _Project with RealmEntity, RealmObjectBase, RealmObject {
  Project(
    String primaryKey,
    String alias,
    String path,
    String environmentKey,
    int order,
  ) {
    RealmObjectBase.set(this, 'primaryKey', primaryKey);
    RealmObjectBase.set(this, 'alias', alias);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'environmentKey', environmentKey);
    RealmObjectBase.set(this, 'order', order);
  }

  Project._();

  @override
  String get primaryKey =>
      RealmObjectBase.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) =>
      RealmObjectBase.set(this, 'primaryKey', value);

  @override
  String get alias => RealmObjectBase.get<String>(this, 'alias') as String;
  @override
  set alias(String value) => RealmObjectBase.set(this, 'alias', value);

  @override
  String get path => RealmObjectBase.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObjectBase.set(this, 'path', value);

  @override
  String get environmentKey =>
      RealmObjectBase.get<String>(this, 'environmentKey') as String;
  @override
  set environmentKey(String value) =>
      RealmObjectBase.set(this, 'environmentKey', value);

  @override
  int get order => RealmObjectBase.get<int>(this, 'order') as int;
  @override
  set order(int value) => RealmObjectBase.set(this, 'order', value);

  @override
  Stream<RealmObjectChanges<Project>> get changes =>
      RealmObjectBase.getChanges<Project>(this);

  @override
  Project freeze() => RealmObjectBase.freezeObject<Project>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Project._);
    return const SchemaObject(ObjectType.realmObject, Project, 'Project', [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('alias', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('environmentKey', RealmPropertyType.string),
      SchemaProperty('order', RealmPropertyType.int),
    ]);
  }
}
