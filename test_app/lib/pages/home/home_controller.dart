import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/dependencies_registrator.dart';
import 'package:test_app/pages/channels/channels_page.dart';
import 'package:test_app/storages/session_storage.dart';

class HomeController extends GetxController {
  RxString dateTime = ''.obs;
  RxString lastOpenedChannelName = ''.obs;

  @override
  void onInit() {
    _setCurrentDateTime();

    SystemChannels.lifecycle.setMessageHandler((message) async {
      switch (message) {
        case 'AppLifecycleState.resumed':
          _setCurrentDateTime();
          break;
      }
      return null;
    });
    super.onInit();
  }

  Future<void> goToChannelsPage() async {
    await Get.to(ChannelsPage());
    _setCurrentDateTime();
    _updateLastOpenedChannelName();
  }

  void _setCurrentDateTime() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
    final String formatted = formatter.format(now);
    dateTime.value = formatted;
  }

  void _updateLastOpenedChannelName() {
    final sessionStorage =
        DependenciesRegistrator.container.get<SessionStorage>();

    lastOpenedChannelName.value = sessionStorage.lastOpenedChannelName ?? '';
    sessionStorage.lastOpenedChannelName = null;
  }
}
