import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/inapp/dark.dart';
import 'app/core/theme/inapp/light.dart';
import 'app/core/utils/loader.dart';
import 'app/routes/pages.dart';
import 'app/routes/routes.dart';

void main() async {
  await AppLoader().load();
  runApp(
    GetMaterialApp(
      title: 'Assetify',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      initialRoute: kReleaseMode ? Routes.HOME : Routes.TEST,
      getPages: AppPages.pages,
    ),
  );
}
