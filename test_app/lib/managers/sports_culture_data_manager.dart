import 'package:get/get.dart';
import 'package:test_app/clients/http_client.dart';
import 'package:test_app/dependencies_registrator.dart';
import 'package:test_app/models/channel_response_model.dart';
import 'package:test_app/models/culture_channels_response_model.dart';
import 'package:test_app/models/sports_channels_response_model.dart';
import 'package:test_app/utils/cancellation_token.dart';

class SportsAndCultureChannelsDataManager {
  final HttpClient _httpClient =
      DependenciesRegistrator.container.get<HttpClient>();

  RxBool isLoading = false.obs;
  RxList<ChannelResponseModel> channels = <ChannelResponseModel>[].obs;

  CancellationToken? _cancellationToken;

  List<ChannelResponseModel>? _previousSportsChannels;
  List<ChannelResponseModel>? _previousCultureChannels;

  Future<void> init() async {
    isLoading.value = true;
    try {
      await getChannels();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ChannelResponseModel>?> getChannels() async {
    _cancellationToken?.cancel();
    _cancellationToken = CancellationToken();
    var sportsChannelsFuture =
        _httpClient.getSportsChanels(cancellationToken: _cancellationToken);
    var cultureChannelsFuture =
        _httpClient.getCultureChanels(cancellationToken: _cancellationToken);

    var result =
        await Future.any([sportsChannelsFuture, cultureChannelsFuture]);

    if (result is SportsChannelsResponseModel) {
      var sportsChannels = await sportsChannelsFuture;
      if (sportsChannels != null) {
        _previousSportsChannels = sportsChannels.list;
        _setChannels();
      }
      var cultureChannels = await cultureChannelsFuture;
      if (cultureChannels != null) {
        _previousCultureChannels = cultureChannels.list;
        _setChannels();
      }
    } else if (result is CultureChannelsResponseModel) {
      var cultureChannels = await cultureChannelsFuture;
      if (cultureChannels != null) {
        _previousCultureChannels = cultureChannels.list;
        _setChannels();
      }
      var sportsChannels = await sportsChannelsFuture;
      if (sportsChannels != null) {
        _previousSportsChannels = sportsChannels.list;
        _setChannels();
      }
    }

    if (_previousSportsChannels != null && _previousCultureChannels != null) {
      var list = _previousCultureChannels!.toList();
      list.addAll(_previousCultureChannels!);
      return list;
    }

    return null;
  }

  Future<void> updateChannels() async {
    isLoading.value = true;
    try {
      await getChannels();
    } finally {
      isLoading.value = false;
    }
  }

  void _setChannels() {
    if (_previousSportsChannels != null && _previousCultureChannels != null) {
      var list = _previousCultureChannels!.toList();
      list.addAll(_previousCultureChannels!);
      channels.value = list;
    }
  }
}
