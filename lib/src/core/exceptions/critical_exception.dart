import 'package:event_bus_exception/src/core/broadcast/broadcast_controller.dart';
import 'package:get_it/get_it.dart';

final class CriticalException implements Exception {
  String cause;
  StackTrace? stack;
  CriticalException(this.cause, {this.stack}) {
    GetIt.I<BroadcastController>().fire(this);
  }

  @override
  String toString() => cause;
}
