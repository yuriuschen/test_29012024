import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/managers/sports_culture_data_manager.dart';
import 'package:test_app/models/channel_response_model.dart';
import 'package:test_app/widgets/channel_view.dart';

class SportAndCultureTab extends StatelessWidget {
  final SportsAndCultureChannelsDataManager dataManager;
  final Function(ChannelResponseModel)? onTap;

  const SportAndCultureTab({super.key, required this.dataManager, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: dataManager.channels.length,
        itemBuilder: (context, index) {
          var channel = dataManager.channels[index];
          return ChannelView(
            channel: channel,
            onTap: onTap,
          );
        },
      ),
    );
  }
}
