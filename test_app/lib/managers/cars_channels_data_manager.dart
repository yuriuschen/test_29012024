import 'package:get/get.dart';
import 'package:test_app/clients/http_client.dart';
import 'package:test_app/dependencies_registrator.dart';
import 'package:test_app/models/channel_response_model.dart';
import 'package:test_app/utils/cancellation_token.dart';

class CarsChannelsDataManager {
  final HttpClient _httpClient =
      DependenciesRegistrator.container.get<HttpClient>();

  RxBool isLoading = false.obs;
  RxList<ChannelResponseModel> channels = <ChannelResponseModel>[].obs;

  CancellationToken? _cancellationToken;

  Future<void> init() async {
    isLoading.value = true;
    try {
      var channels = await getChannels();
      _setChannels(channels);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ChannelResponseModel>?> getChannels() async {
    _cancellationToken?.cancel();
    _cancellationToken = CancellationToken();
    var channels =
        await _httpClient.getCarsChanels(cancellationToken: _cancellationToken);
    if (channels != null) {
      return channels;
    }

    return null;
  }

  Future<void> updateChannels() async {
    isLoading.value = true;
    try {
      var channels = await getChannels();
      _setChannels(channels);
    } finally {
      isLoading.value = false;
    }
  }

  void _setChannels(List<ChannelResponseModel>? channels) {
    if (channels != null) {
      this.channels.value = channels;
    }
  }
}
