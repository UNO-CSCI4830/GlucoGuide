import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionixService {
  final String appId = '<APP_ID>';
  final String appKey = '<APP_KEY>';

  Future<List<dynamic>> searchFood(String query) async {
    final url = Uri.parse(
        'https://trackapi.nutritionix.com/v2/search/instant?query=$query');
    final headers = {
      'X-APP-ID': appId,
      'X-APP-KEY': appKey,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['common'] ?? []; // Return a list of common food items
    } else {
      throw Exception('Failed to search for food: ${response.reasonPhrase}');
    }
  }
}
