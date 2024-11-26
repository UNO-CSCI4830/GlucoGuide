import 'package:flutter/material.dart';
import 'package:glucoguide/services/nutritionx_service.dart';

class FoodSearch extends StatefulWidget {
  const FoodSearch({super.key});

  @override
  State<FoodSearch> createState() => _FoodSearchState();
}

class _FoodSearchState extends State<FoodSearch> {
  final NutritionixService _service = NutritionixService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  void _searchFood() async {
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
            title: Text(details['food_name']),
            content: Text(
                'Calories: ${details['nf_calories']}\nProtein: ${details['nf_protein']}g'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  // Add to food log functionality
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
            suffixIcon: Icon(Icons.search),
          ),
          onSubmitted: (_) => _searchFood(),
        ),
        const SizedBox(height: 10),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        if (!_isLoading && _searchResults.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return ListTile(
                  title: Text(item['food_name']),
                  subtitle: Text(item['serving_unit']),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _viewFoodDetails(item['nix_item_id']),
                );
              },
            ),
          ),
      ],
    );
  }
}
