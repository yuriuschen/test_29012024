import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Yuri Uschenchik',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Obx(
                () => Text(
                  '${controller.dateTime}',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Obx(
                () => Text(
                  '${controller.lastOpenedChannelName}',
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextButton(
                    onPressed: controller.goToChannelsPage,
                    child: const Text('Open channels page')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
