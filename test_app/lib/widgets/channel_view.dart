import 'package:flutter/widgets.dart';
import 'package:test_app/models/channel_response_model.dart';

class ChannelView extends StatelessWidget {
  final ChannelResponseModel channel;
  final Function(ChannelResponseModel)? onTap;

  const ChannelView({super.key, required this.channel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(channel),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(channel.title),
            Container(height: 8),
            Text(
              channel.description,
              maxLines: 3,
            )
          ],
        ),
      ),
    );
  }
}
