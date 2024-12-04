import 'package:flutter/material.dart';
import '../services/nutritionx_service.dart';

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
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(details['food_name'] ?? 'Unknown'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Calories: ${details['nf_calories'] ?? 'N/A'} kcal'),
                Text('Protein: ${details['nf_protein'] ?? 'N/A'} g'),
                Text(
                    'Carbohydrates: ${details['nf_total_carbohydrate'] ?? 'N/A'} g'),
                Text('Fat: ${details['nf_total_fat'] ?? 'N/A'} g'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
