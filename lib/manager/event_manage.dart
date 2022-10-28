import 'dart:async';
import 'package:flutter_platform_manage/common/manage.dart';
import 'package:flutter_platform_manage/model/event/base_event.dart';
import 'package:flutter_platform_manage/utils/event_bus.dart';

/*
* 消息总线管理
* @author wuxubaiyang
* @Time 2022-07-30 15:54:25
*/
class EventManage extends BaseManage {
  static final EventManage _instance = EventManage._internal();

  factory EventManage() => _instance;

  EventManage._internal();

  // 消息总线对象管理
  late EventBus eventBus;

  @override
  Future<void> init() async {
    eventBus = EventBus();
  }

  // 注册消息监听
  Stream<T> on<T extends BaseEvent>() => eventBus.on<T>();

  // 发送消息
  void fire<T extends BaseEvent>(T event) => eventBus.fire(event);
}

//单例调用
final eventManage = EventManage();
