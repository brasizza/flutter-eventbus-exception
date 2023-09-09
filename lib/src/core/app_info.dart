import 'package:device_info_plus/device_info_plus.dart';

class AppInfos {
  String infoDevice = '';
  String get device {
    return infoDevice;
  }

  void init() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    IosDeviceInfo? iosInfo;
    AndroidDeviceInfo? androidInfo;
    WebBrowserInfo? webBrowserInfo;
    try {
      androidInfo = await deviceInfoPlugin.androidInfo;
      infoDevice = androidInfo.model;
    } catch (_) {}
    try {
      iosInfo = await deviceInfoPlugin.iosInfo;
      infoDevice = iosInfo.utsname.machine;
    } catch (_) {}
    try {
      webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      infoDevice = webBrowserInfo.userAgent ?? 'WEB';
    } catch (_) {}
  }
}
