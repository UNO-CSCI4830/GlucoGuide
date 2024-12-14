import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutritionixService {
  final String? appId = dotenv.env['API_ID'];
  final String? appKey = dotenv.env['API_KEY'];

  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    if (appId == null || appKey == null) {
      throw Exception('API credentials are missing!');
    }

    final url = Uri.parse(
        'https://trackapi.nutritionix.com/v2/search/instant?query=$query');
    final headers = {
      'X-APP-ID': appId!,
      'X-APP-KEY': appKey!,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return (data['branded'] as List<dynamic>? ?? []).map((item) {
          return {
            'food_name': item['brand_name_item_name'] ?? 'Unknown',
            'serving_unit': item['serving_unit'] ?? 'Unknown',
            'nix_item_id': item['nix_item_id'] ?? 'Unknown',
          };
        }).toList();
      } else {
        throw Exception('Failed to search for food: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during searchFood API call: $e');
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

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final item = data['foods'][0];

        return {
          'food_name': item['food_name'] ?? 'Unknown',
          'nf_calories': item['nf_calories'] ?? 0,
          'nf_protein': item['nf_protein'] ?? 0,
          'nf_total_carbohydrate': item['nf_total_carbohydrate'] ?? 0,
          'nf_total_fat': item['nf_total_fat'] ?? 0,
        };
      } else if (response.statusCode == 404) {
        throw Exception('Food item not found. Please check the itemId.');
      } else {
        throw Exception(
            'Failed to fetch food details: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during getFoodDetails API call: $e');
    }
  }
}
