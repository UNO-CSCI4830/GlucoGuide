import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutritionixService {
  final String? appId = dotenv.env['API_ID'];
  final String? appKey = dotenv.env['API_KEY'];

  Future<List<dynamic>> searchFood(String query) async {
    if (appId == null || appKey == null) {
      throw Exception('API credentials are missing!');
    }

    final url = Uri.parse(
        'https://trackapi.nutritionix.com/v2/search/instant?query=$query');
    final headers = {
      'X-APP-ID': appId!,
      'X-APP-KEY': appKey!,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['common'] ?? []; // Return a list of common food items
    } else {
      throw Exception('Failed to search for food: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getFoodDetails(String itemId) async {
    if (appId == null || appKey == null) {
      throw Exception('API credentials are missing!');
    }

    final url = Uri.parse(
        'https://trackapi.nutritionix.com/v2/search/item?nix_item_id=$itemId');
    final headers = {
      'X-APP-ID': appId!,
      'X-APP-KEY': appKey!,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch food details: ${response.reasonPhrase}');
    }
  }
}
