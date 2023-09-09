import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:event_bus_exception/main_controller.dart';
import 'package:event_bus_exception/src/core/app_info.dart';
import 'package:event_bus_exception/src/core/broadcast/broadcast_controller.dart';
import 'package:event_bus_exception/src/core/broadcast_base.dart';
import 'package:event_bus_exception/src/core/channels/discord_broadcast_impl.dart';
import 'package:event_bus_exception/src/core/channels/slack_broadcast_impl.dart';
import 'package:event_bus_exception/src/core/exceptions/critical_exception.dart';
import 'package:event_bus_exception/src/data/model/album_model.dart';
import 'package:event_bus_exception/src/data/model/album_model_error.dart';
import 'package:event_bus_exception/src/data/repository/api_call_impl.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_network/image_network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<Dio>(Dio(), signalsReady: true);
  GetIt.I.registerSingleton<AppInfos>(AppInfos()..init());
  GetIt.I.registerSingleton<BroadcastBase>(DiscordBroadcastImpl(rest: GetIt.I<Dio>())..configure({"channel": "#exceptions"}), instanceName: 'discord');
  GetIt.I.registerSingleton<BroadcastBase>(SlackBroadCastImpl(rest: GetIt.I<Dio>()), instanceName: 'slack');
  GetIt.I.registerLazySingleton<BroadcastController>(
    () => BroadcastController(info: GetIt.I<AppInfos>(), eventBus: EventBus(), channels: [
      GetIt.I<BroadcastBase>(instanceName: 'slack'),
      GetIt.I<BroadcastBase>(instanceName: 'discord'),
    ])
      ..init(),
  );
  GetIt.I.registerLazySingleton<ApiCallImpl>(() => ApiCallImpl(rest: GetIt.I<Dio>()));
  GetIt.I.registerLazySingleton<MainController>(() => MainController(repository: GetIt.I<ApiCallImpl>()));

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final MainController controller = GetIt.I();
  final albuns = <AlbumModel>[];
  final albunsError = <AlbumModelError>[];
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Visibility(
                  visible: !error,
                  replacement: const Center(
                      child: Text(
                    "OPS ERRO!!!",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  )),
                  child: ListView.builder(
                    itemBuilder: (_, i) {
                      final album = albuns[i];
                      return Card(
                          child: Column(
                        children: [
                          ImageNetwork(
                            image: album.thumbnailUrl,
                            height: 150,
                            width: 150,
                          ),
                          Text(album.id.toString()),
                        ],
                      ));
                    },
                    itemCount: albuns.length,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final albunsResponse = await controller.getAlbuns();
                      if (albunsResponse != null) {
                        setState(() {
                          albuns.addAll(albunsResponse);
                        });
                      }
                    },
                    child: const Text("API OK!"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await controller.getAlbunsError();
                      } on CriticalException catch (_) {
                        setState(() {
                          error = true;
                        });
                      }
                    },
                    child: const Text("API Falha de parse do objeto"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.getAlbuns(simulate: true);
                    },
                    child: const Text("API Falha servidor"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
