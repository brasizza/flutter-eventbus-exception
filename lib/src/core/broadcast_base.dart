import 'package:event_bus_exception/src/core/app_info.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';

abstract interface class BroadcastBase {
  Future<bool> execute({required CriticalException exception, required AppInfos info});
  Future<void> configure(Map<String, dynamic> configs);
}
