import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/dependencies_registrator.dart';
import 'package:test_app/enums/channels_tabs.dart';
import 'package:test_app/managers/cars_channels_data_manager.dart';
import 'package:test_app/managers/sports_culture_data_manager.dart';
import 'package:test_app/models/channel_response_model.dart';
import 'package:test_app/storages/session_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const int TIMER_DELAY = 5;

  final List<ChannelTabs> tabs = <ChannelTabs>[
    ChannelTabs.cars,
    ChannelTabs.sportsAndCulture,
  ];

  final SessionStorage _sessionStorage =
      DependenciesRegistrator.container.get<SessionStorage>();
  final CarsChannelsDataManager carsDataManager = CarsChannelsDataManager();
  final SportsAndCultureChannelsDataManager
      sportsAndCultureChannelsDataManager =
      SportsAndCultureChannelsDataManager();

  late TabController tabController;

  Timer? _timer;
  ChannelTabs _currentTab = ChannelTabs.cars;

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: tabs.length);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        _currentTab = tabs[tabController.index];
      }
    });

    carsDataManager.init();
    sportsAndCultureChannelsDataManager.init();

    _timer = Timer.periodic(const Duration(seconds: TIMER_DELAY), _updateData);

    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  Future<void> onChannelTap(ChannelResponseModel channel) async {
    _sessionStorage.lastOpenedChannelName = channel.title;

    var uri = Uri.tryParse(channel.url);
    if (uri != null && uri.host.isNotEmpty && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _updateData(Timer timer) {
    switch (_currentTab) {
      case ChannelTabs.cars:
        carsDataManager.updateChannels();
        break;
      case ChannelTabs.sportsAndCulture:
        sportsAndCultureChannelsDataManager.updateChannels();
        break;
    }
  }
}
