import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/models/channel_response_model.dart';
import 'package:test_app/models/culture_channels_response_model.dart';
import 'package:test_app/models/sports_channels_response_model.dart';
import 'package:test_app/utils/cancellation_token.dart';
import 'package:xml/xml.dart' as xml;

class HttpClient {
  static const String YNET_CARS_URL =
      'http://www.ynet.co.il/Integration/StoryRss550.xml';
  static const String YNET_SPORT_URL =
      'http://www.ynet.co.il/Integration/StoryRss3.xml';
  static const String YNET_CULTURE_URL =
      'http://www.ynet.co.il/Integration/StoryRss538.xml';

  final Map<String, String> _headers = {"Accept": "text/html,application/xml"};

  Future<List<ChannelResponseModel>?> getCarsChanels(
      {CancellationToken? cancellationToken}) async {
    final response =
        await http.get(Uri.parse(YNET_CARS_URL), headers: _headers);

    if (cancellationToken != null &&
        cancellationToken.isCancellationRequested) {
      return null;
    }

    if (response.statusCode == 200) {
      return _parceChannelsData(response.bodyBytes);
    }

    return null;
  }

  Future<SportsChannelsResponseModel?> getSportsChanels(
      {CancellationToken? cancellationToken}) async {
    final response =
        await http.get(Uri.parse(YNET_SPORT_URL), headers: _headers);

    if (cancellationToken != null &&
        cancellationToken.isCancellationRequested) {
      return null;
    }

    if (response.statusCode == 200) {
      var result = _parceChannelsData(response.bodyBytes);

      return result != null ? SportsChannelsResponseModel(result) : null;
    }

    return null;
  }

  Future<CultureChannelsResponseModel?> getCultureChanels(
      {CancellationToken? cancellationToken}) async {
    final response =
        await http.get(Uri.parse(YNET_CULTURE_URL), headers: _headers);

    if (cancellationToken != null &&
        cancellationToken.isCancellationRequested) {
      return null;
    }

    if (response.statusCode == 200) {
      var result = _parceChannelsData(response.bodyBytes);

      return result != null ? CultureChannelsResponseModel(result) : null;
    }

    return null;
  }

  List<ChannelResponseModel>? _parceChannelsData(Uint8List bodyBytes) {
    try {
      var body = utf8.decode(bodyBytes);
      var document = xml.XmlDocument.parse(body);

      final items = document.findAllElements('item');
      var list = <ChannelResponseModel>[];
      for (var itemNode in items) {
        final title = itemNode.findElements('title').first.text;
        final description = itemNode.findElements('description').first.text;
        final link = itemNode.findElements('link').first.text;
        list.add(ChannelResponseModel(
            title: title, description: description, url: link));
      }

      return list;
    } catch (e) {
      print('todo handle error');
    }

    return null;
  }
}
