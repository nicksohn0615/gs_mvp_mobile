import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataProvider {
  static final DataProvider instance = DataProvider._internal();
  // factory RealtimeDataProvider() => instance;
  factory DataProvider() {
    return instance;
  }
  DataProvider._internal();

  List<int>? yesterdayPriceList;
  List<int>? todayPriceList;

  final String baseUrl = 'http://121.169.212.87:8001/mobile/';
  // final wsUrl = Uri.parse('ws://121.169.212.87:8001/mobile/realtime');

  Future<void> getGasPice() async {
    Uri targetUrl = Uri.parse(baseUrl + 'gas-price');
    http.Response response = await http.get(targetUrl);
    if (response.statusCode == 200) {
      debugPrint('get Gas Price result : ${response.body}');
      Map<String, dynamic> contents = jsonDecode(response.body);
      Map<String, dynamic> yesterday = contents['yesterday'];
      Map<String, dynamic> today = contents['today'];
      yesterdayPriceList = [
        yesterday['gas']!,
        yesterday['die']!,
        yesterday['gas+']!
      ];
      todayPriceList = [today['gas']!, today['die']!, today['gas+']!];
      // yesterdayPriceList = [
      // contents['yesterday']['gas'],
      //   response.body['yesterday']['die'],
      //   response.body['yesterday']['gas+'],
      // ];
    }
  }
}
