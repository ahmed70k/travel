import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import '../../domain/entities/admin_flights_entity.dart';

class AdminFlightFilters extends StatefulWidget {
  final FlightFiltersEntity filters;
  final Function(String? tripType, String? category) onFilterChanged;

  const AdminFlightFilters({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  State<AdminFlightFilters> createState() => _AdminFlightFiltersState();
}

class _AdminFlightFiltersState extends State<AdminFlightFilters> {
  String? _selectedTripType;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trip Type
        const Text(
          'نوع الرحلة',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.filters.tripType.map((type) {
            final isSelected = _selectedTripType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTripType = selected ? type : null;
                });
                widget.onFilterChanged(_selectedTripType, _selectedCategory);
              },
              backgroundColor: Colors.white.withOpacity(0.05),
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.white70,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.1),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Categories
        const Text(
          'الفئات',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.filters.categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                    widget.onFilterChanged(_selectedTripType, _selectedCategory);
                  },
                  backgroundColor: Colors.white.withOpacity(0.05),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.white70,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
