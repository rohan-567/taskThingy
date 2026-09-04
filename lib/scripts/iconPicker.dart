import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';

class Iconpicker {
  static final Map<String, IconData> iconMap = {
    "Home": Icons.home,
    "Person": Icons.person,
    "Food": Icons.food_bank,
    "Groceries": Icons.shopping_cart,
    "Gym": Icons.fitness_center_rounded,
    "Health": Icons.health_and_safety,
    "Shopping": Icons.shopping_bag,
    "Travel": Icons.airplanemode_active_rounded,
    "Entertainment": Icons.movie,
    "Fitness": Icons.fitness_center,
    "Education": Icons.school,
    "Pet": Icons.pets,
    "Football": Icons.sports_soccer,
    "Basketball": Icons.sports_basketball,
    "Tennis": Icons.sports_tennis,
    "Laundry": Icons.cleaning_services,
    "Garden": Icons.grass,
    "Books": Icons.book,
    "Music": Icons.music_note,

    "TV Shows": Icons.tv,
    "Coffee": Icons.local_cafe,
    "Dining Out": Icons.restaurant,
  };

  static IconData pickIcon(String title, String description) {
    BestMatch bestMatch = StringSimilarity.findBestMatch(
      title,
      iconMap.keys.toList(),
    );

    double highestSimilarity = bestMatch.bestMatch.rating ?? 0;

    if (highestSimilarity > 0.1) {
      return iconMap.values.elementAt(bestMatch.bestMatchIndex);
    }

    return Icons.check_box_rounded;
  }
}
