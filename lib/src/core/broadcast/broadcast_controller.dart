import 'package:event_bus/event_bus.dart';
import 'package:event_bus_exception/src/core/app_info.dart';
import 'package:event_bus_exception/src/core/broadcast_base.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';

class BroadcastController {
  final EventBus _eventBus;

  final List<BroadcastBase> _channels;
  final AppInfos _info;

  BroadcastController({
    required EventBus eventBus,
    required List<BroadcastBase> channels,
    required AppInfos info,
  })  : _eventBus = eventBus,
        _channels = channels,
        _info = info;

  void init() {
    _eventBus.on<CriticalException>().listen((critical) {
      for (var channel in _channels) {
        channel.execute(exception: critical, info: _info);
      }
    });
  }

  void fire(CriticalException exception) {
    _eventBus.fire(exception);
  }
}
