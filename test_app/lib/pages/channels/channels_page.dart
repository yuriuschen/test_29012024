import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/enums/channels_tabs.dart';
import 'package:test_app/pages/channels/channels_controller.dart';
import 'package:test_app/pages/channels/tabs/cars_tab.dart';
import 'package:test_app/pages/channels/tabs/sports_culture_tab.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChannelsController controller = Get.put(ChannelsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels Page'),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: [
            Tab(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Cars'),
                    Container(
                      width: 8,
                    ),
                    Obx(() => Visibility(
                        visible: controller.carsDataManager.isLoading.value,
                        child: Container(
                          height: 12,
                          width: 12,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )))
                  ],
                ),
              ),
            ),
            Tab(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sports & Culture'),
                    Container(
                      width: 8,
                    ),
                    Obx(() => Visibility(
                        visible: controller.sportsAndCultureChannelsDataManager
                            .isLoading.value,
                        child: Container(
                          height: 12,
                          width: 12,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: controller.tabs.map((ChannelTabs tab) {
          switch (tab) {
            case ChannelTabs.cars:
              return CarsTab(
                dataManager: controller.carsDataManager,
                onTap: controller.onChannelTap,
              );
            case ChannelTabs.sportsAndCulture:
              return SportAndCultureTab(
                dataManager: controller.sportsAndCultureChannelsDataManager,
                onTap: controller.onChannelTap,
              );
          }
        }).toList(),
      ),
    );
  }
}
