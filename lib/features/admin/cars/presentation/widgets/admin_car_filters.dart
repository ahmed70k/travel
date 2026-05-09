import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import '../../domain/entities/admin_cars_entity.dart';

class AdminCarFilters extends StatefulWidget {
  final CarFiltersEntity filters;
  final Function(String? carType, String? category) onFilterChanged;

  const AdminCarFilters({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  State<AdminCarFilters> createState() => _AdminCarFiltersState();
}

class _AdminCarFiltersState extends State<AdminCarFilters> {
  String? _selectedCarType;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Car Types
        const Text(
          'أنواع السيارات',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.filters.carTypes.map((type) {
            final isSelected = _selectedCarType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCarType = selected ? type : null;
                });
                widget.onFilterChanged(_selectedCarType, _selectedCategory);
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
                    widget.onFilterChanged(_selectedCarType, _selectedCategory);
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
