import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import '../../domain/entities/admin_hotels_entity.dart';

class AdminHotelFilters extends StatefulWidget {
  final HotelFiltersEntity filters;
  final Function(String? guestsCount, String? category) onFilterChanged;

  const AdminHotelFilters({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  State<AdminHotelFilters> createState() => _AdminHotelFiltersState();
}

class _AdminHotelFiltersState extends State<AdminHotelFilters> {
  String? _selectedGuestsCount;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Guests Count
        const Text(
          'Guests Count',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.filters.guestsCount.map((count) {
            final isSelected = _selectedGuestsCount == count;
            return ChoiceChip(
              label: Text(count),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGuestsCount = selected ? count : null;
                });
                widget.onFilterChanged(_selectedGuestsCount, _selectedCategory);
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
          'Categories',
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
                    widget.onFilterChanged(_selectedGuestsCount, _selectedCategory);
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
