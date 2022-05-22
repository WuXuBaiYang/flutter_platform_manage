// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Environment extends _Environment with RealmEntity, RealmObject {
  Environment(
    String primaryKey,
    String path,
    String flutter,
    String channel,
    String dart,
  ) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'flutter', flutter);
    RealmObject.set(this, 'channel', channel);
    RealmObject.set(this, 'dart', dart);
  }

  Environment._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  String get flutter => RealmObject.get<String>(this, 'flutter') as String;
  @override
  set flutter(String value) => RealmObject.set(this, 'flutter', value);

  @override
  String get channel => RealmObject.get<String>(this, 'channel') as String;
  @override
  set channel(String value) => RealmObject.set(this, 'channel', value);

  @override
  String get dart => RealmObject.get<String>(this, 'dart') as String;
  @override
  set dart(String value) => RealmObject.set(this, 'dart', value);

  @override
  Stream<RealmObjectChanges<Environment>> get changes =>
      RealmObject.getChanges<Environment>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Environment._);
    return const SchemaObject(Environment, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('flutter', RealmPropertyType.string),
      SchemaProperty('channel', RealmPropertyType.string),
      SchemaProperty('dart', RealmPropertyType.string),
    ]);
  }
}
