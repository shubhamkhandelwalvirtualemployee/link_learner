import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/instructor/provider/instructor_provider.dart';
import 'package:provider/provider.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstructorProvider>(
      builder: (context, provider, _) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: ColorConstants.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // ---- Header ----
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: ColorConstants.primaryTextColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Search Filter",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // ---- County ----
                          _buildSectionTitle("County"),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            hint: "Select County",
                            items: _irelandCounties,
                            value: provider.selectedCounty,
                            // 👈 show selected county
                            onChanged:
                                (value) =>
                                    provider.setSelectedCounty(value ?? ''),
                          ),
                          const SizedBox(height: 16),

                          // ---- City/Town ----
                          _buildSectionTitle("City/Town"),
                          const SizedBox(height: 8),
                          _buildTextField(
                            "e.g., Dublin",
                            onChanged: provider.setCityTown,
                            initialValue: provider.cityTown,
                          ),
                          const SizedBox(height: 16),

                          // ---- Minimum Rating ----
                          _buildSectionTitle("Minimum Rating"),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            hint: provider.selectedRating,
                            items: ["Any Rating", "1+", "2+", "3+", "4+", "5"],
                            onChanged:
                                (value) =>
                                    provider.setSelectedRating(value ?? ''),
                          ),
                          const SizedBox(height: 16),

                          // ---- Price ----
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle("Min Price (€ / hr)"),
                                    const SizedBox(height: 8),
                                    _buildTextField(
                                      "e.g., 30",
                                      onChanged: provider.setMinPrice,
                                      initialValue: provider.minPrice,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle("Max Price (€ / hr)"),
                                    const SizedBox(height: 8),
                                    _buildTextField(
                                      "e.g., 60",
                                      onChanged: provider.setMaxPrice,
                                      initialValue: provider.maxPrice,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ---- Sort By ----
                          _buildSectionTitle("Sort By"),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            hint: provider.selectedSortBy,
                            items: const [
                              "Highest Rated",
                              "Lowest Price",
                              "Highest Price",
                              "Closest Distance",
                            ],
                            onChanged:
                                (value) =>
                                    provider.setSelectedSortBy(value ?? ''),
                          ),
                          const SizedBox(height: 20),

                          // ---- Vehicle Type ----
                          _buildSectionTitle("Vehicle Type"),
                          const SizedBox(height: 10),
                          _buildToggleRow(
                            options: ["Manual", "Automatic"],
                            selectedValue: provider.selectedVehicleType,
                            onSelected: provider.setSelectedVehicleType,
                          ),
                          const SizedBox(height: 20),

                          // ---- Specializations ----
                          _buildSectionTitle("Specializations"),
                          const SizedBox(height: 10),
                          _buildSpecializationGrid(context),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // ---- Bottom Buttons ----
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => provider.clearAllFilters(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: ColorConstants.primaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await provider.getInstructorList(isRefresh: true);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Apply Filter",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------- UI Helper Widgets ----------
  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: ColorConstants.primaryTextColor,
    ),
  );

  Widget _buildTextField(
    String hint, {
    required ValueChanged<String> onChanged,
    String? initialValue,
  }) {
    final controller = TextEditingController(text: initialValue ?? "");
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorConstants.disabledColor,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value, // 👈 add this parameter
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.disabledColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint),
        icon: const Icon(Icons.keyboard_arrow_down),
        value: value == "" ? null : value,
        // 👈 show selected value if available
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildToggleRow({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Row(
      children:
          options.map((option) {
            final bool isSelected = option == selectedValue;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? ColorConstants.primaryColor
                              : ColorConstants.disabledColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : ColorConstants.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSpecializationGrid(BuildContext context) {
    final specs = [
      "Manual Transmission",
      "Automatic Transmission",
      "Pre-Test Preparation",
      "Motorway Driving",
      "City Driving",
      "EDT (Essential Driver Training)",
      "Nervous Drivers",
      "Defensive Driving",
      "Refresher Lessons",
      "Night Driving",
    ];

    return Consumer<InstructorProvider>(
      builder: (context, provider, _) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              specs.map((label) {
                final isSelected = provider.selectedSpecializations.contains(
                  label,
                );
                return FilterChip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : ColorConstants.primaryTextColor,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => provider.toggleSpecialization(label),
                  backgroundColor: ColorConstants.disabledColor.withOpacity(
                    0.15,
                  ),
                  selectedColor: ColorConstants.primaryColor,
                  checkmarkColor: Colors.white,
                );
              }).toList(),
        );
      },
    );
  }
}

// ---------- Constants ----------
const List<String> _irelandCounties = [
  "All Counties",
  "Dublin",
  "Cork",
  "Galway",
  "Limerick",
  "Waterford",
  "Kildare",
  "Meath",
  "Wicklow",
  "Kilkenny",
  "Wexford",
  "Louth",
  "Clare",
  "Kerry",
  "Tipperary",
  "Mayo",
  "Donegal",
  "Sligo",
  "Leitrim",
  "Roscommon",
  "Offaly",
  "Westmeath",
  "Laois",
  "Carlow",
  "Monaghan",
  "Cavan",
  "Longford",
];
