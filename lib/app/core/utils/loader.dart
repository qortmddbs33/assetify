import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../provider/api.dart';
import '../../provider/api_interface.dart';
import '../../services/credentials/service.dart';

class AppLoader {
  Future<void> load() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    setPathUrlStrategy();

    await dotenv.load(fileName: "env/.env", isOptional: true);

    await Get.putAsync<CredentialsService>(() => CredentialsService().init());

    Get.put<ApiProvider>(ProdApiProvider());

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await FlutterDisplayMode.setHighRefreshRate();
      }
    }

    FlutterNativeSplash.remove();
  }
}
