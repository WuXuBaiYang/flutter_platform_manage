// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Environment extends _Environment
    with RealmEntity, RealmObjectBase, RealmObject {
  Environment(
    String primaryKey,
    String path,
    String flutter,
    String channel,
    String dart,
  ) {
    RealmObjectBase.set(this, 'primaryKey', primaryKey);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'flutter', flutter);
    RealmObjectBase.set(this, 'channel', channel);
    RealmObjectBase.set(this, 'dart', dart);
  }

  Environment._();

  @override
  String get primaryKey =>
      RealmObjectBase.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) =>
      RealmObjectBase.set(this, 'primaryKey', value);

  @override
  String get path => RealmObjectBase.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObjectBase.set(this, 'path', value);

  @override
  String get flutter => RealmObjectBase.get<String>(this, 'flutter') as String;
  @override
  set flutter(String value) => RealmObjectBase.set(this, 'flutter', value);

  @override
  String get channel => RealmObjectBase.get<String>(this, 'channel') as String;
  @override
  set channel(String value) => RealmObjectBase.set(this, 'channel', value);

  @override
  String get dart => RealmObjectBase.get<String>(this, 'dart') as String;
  @override
  set dart(String value) => RealmObjectBase.set(this, 'dart', value);

  @override
  Stream<RealmObjectChanges<Environment>> get changes =>
      RealmObjectBase.getChanges<Environment>(this);

  @override
  Environment freeze() => RealmObjectBase.freezeObject<Environment>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Environment._);
    return const SchemaObject(
        ObjectType.realmObject, Environment, 'Environment', [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('flutter', RealmPropertyType.string),
      SchemaProperty('channel', RealmPropertyType.string),
      SchemaProperty('dart', RealmPropertyType.string),
    ]);
  }
}
