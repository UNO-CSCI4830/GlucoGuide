import 'package:flutter/material.dart';
import '../services/nutritionx_service.dart';
import 'package:glucoguide/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FoodSearchWidget extends StatefulWidget {
  const FoodSearchWidget({Key? key}) : super(key: key);

  @override
  State<FoodSearchWidget> createState() => _FoodSearchWidgetState();
}

class _FoodSearchWidgetState extends State<FoodSearchWidget> {
  final NutritionixService _service = NutritionixService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  void _searchFood() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _service.searchFood(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _viewFoodDetails(String itemId) async {
    try {
      final details = await _service.getFoodDetails(itemId);

      // Extract food details into variables
      final foodName = details['food_name'] ?? 'Unknown';
      final calories = details['nf_calories'] ?? 0;
      final protein = details['nf_protein'] ?? 0;
      final carbohydrates = details['nf_total_carbohydrate'] ?? 0;
      final fat = details['nf_total_fat'] ?? 0;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(foodName),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Calories: $calories kcal'),
                Text('Protein: $protein g'),
                Text('Carbohydrates: $carbohydrates g'),
                Text('Fat: $fat g'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  final foodLog = {
                    'time': DateTime.now().toString(),
                    'food_name': foodName,
                    'calories': calories,
                    'protein': protein,
                    'carbohydrates': carbohydrates,
                    'fat': fat,
                  };

                  // Log food entry
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);

                  // Retrieve and update food logs
                  final currentLogs = List<Map<String, dynamic>>.from(
                      userProvider.userProfile?.foodLogs ?? []);
                  currentLogs.add(foodLog);

                  // Update profile
                  userProvider.updateUserProfile({'foodLogs': currentLogs});

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Food added to tracking log!')),
                  );
                },
                child: const Text('Add to Log'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search Food',
            hintText: 'Enter food name',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _searchFood(),
        ),
        const SizedBox(height: 10),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_searchResults.isEmpty)
          const Center(
            child: Text(
              'No results found. Try a different search term.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return Card(
                  child: ListTile(
                    title: Text(item['food_name'] ?? 'Unknown Food'),
                    subtitle:
                        Text(item['serving_unit'] ?? 'Unknown Serving Unit'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _viewFoodDetails(item['nix_item_id'] ?? ''),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
