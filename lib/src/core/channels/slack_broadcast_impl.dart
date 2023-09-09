import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_bus_exception/src/core/app_info.dart';
import 'package:event_bus_exception/src/core/broadcast_base.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';

class SlackBroadCastImpl implements BroadcastBase {
  final Dio _rest;
  String channel = '#exception';
  SlackBroadCastImpl({required Dio rest}) : _rest = rest;
  @override
  Future<bool> execute({required CriticalException exception, required AppInfos info}) async {
    const slackUrl = 'https://hooks.slack.com/services/xxxx/yyyyy/hhhhhhhhhhhh';
    final fields = <Map<String, String>>[];
    final lines = exception.stack.toString().split("\n");
    final stackList = lines.take(10).toList();
    fields.add({"name": 'device', "value": info.device.toString()});
    fields.add({"name": 'slack', "value": stackList.join("\n")});

    String text = exception.cause;

    text += fields.join("\n\n");
    Map payload = {};
    payload['channel'] = channel;
    payload['text'] = text;
    try {
      await _rest.post(slackUrl, data: {'payload': json.encode(payload)}, options: Options(contentType: 'application/x-www-form-urlencoded'));
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return false;
    }
    return true;
  }

  @override
  Future<void> configure(Map<String, dynamic> configs) async {
    if (configs.containsKey('channel')) {
      channel = "#${(configs['channel'] as String).replaceAll('#', '')}";
    }
  }
}
