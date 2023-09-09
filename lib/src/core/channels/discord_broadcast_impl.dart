import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_bus_exception/src/core/app_info.dart';
import 'package:event_bus_exception/src/core/broadcast_base.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';

class DiscordBroadcastImpl implements BroadcastBase {
  final Dio _rest;
  DiscordBroadcastImpl({required Dio rest}) : _rest = rest;
  @override
  Future<bool> execute({required CriticalException exception, required AppInfos info}) async {
    const discordUrl = 'https://discord.com/api/webhooks/1149391587772727469/MlQ7l2cjOqAoOvFRn3nPb3AiigrATDC-TPFlvsilV7_Tp2q27pYG_Gcc6acreyXnLUKV';
    final fields = <Map<String, String>>[];
    final lines = exception.stack.toString().split("\n");
    final stackList = lines.take(10).toList();
    fields.add({"name": 'device', "value": info.device.toString()});
    fields.add({"name": 'slack', "value": stackList.join("\n")});

    final data = {
      "username": 'Critical exception',
      "embeds": [
        {
          'timestamp': DateTime.now().toIso8601String(),
          "description": exception.toString(),
          "fields": fields,
        }
      ]
    };

    try {
      await _rest.post(discordUrl, data: data);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return false;
    }
    return true;
  }

  @override
  Future<void> configure(Map<String, dynamic> configs) async {}
}
