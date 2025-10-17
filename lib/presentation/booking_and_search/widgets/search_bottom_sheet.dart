import 'package:flutter/material.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/outlined_button.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingSearchProvider>(
      builder: (context, bookingSearchProvider, _) {
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                          'Search Filter',
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
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        const SizedBox(height: 15),

                        _buildSectionTitle('Categories'),
                        const SizedBox(height: 10),
                        _buildChipGroup(
                          chips: bookingSearchProvider.categories,
                          selectedChip: bookingSearchProvider.selectedCategory,
                          onChipSelected: bookingSearchProvider.selectCategory,
                        ),
                        const SizedBox(height: 20),

                        _buildSectionTitle('Price'),
                        const SizedBox(height: 10),
                        RangeSlider(
                          values: bookingSearchProvider.priceRange,
                          min: bookingSearchProvider.minPrice,
                          max: bookingSearchProvider.maxPrice,
                          divisions:
                              (bookingSearchProvider.maxPrice -
                                      bookingSearchProvider.minPrice)
                                  .toInt(),
                          labels: RangeLabels(
                            '\$${bookingSearchProvider.priceRange.start.round()}',
                            '\$${bookingSearchProvider.priceRange.end.round()}',
                          ),
                          onChanged: bookingSearchProvider.updatePriceRange,
                          activeColor: ColorConstants.primaryColor,
                          inactiveColor: ColorConstants.disabledColor
                              .withOpacity(0.2),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${bookingSearchProvider.priceRange.start.round()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${bookingSearchProvider.priceRange.end.round()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildSectionTitle('Duration'),
                        const SizedBox(height: 10),
                        _buildChipGroup(
                          chips: bookingSearchProvider.durations,
                          selectedChip: bookingSearchProvider.selectedDuration,
                          onChipSelected: bookingSearchProvider.selectDuration,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // --- Action Buttons ---
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: outlinedButton(
                              onTap: bookingSearchProvider.clearFilters,
                              title: "Clear",
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: elevatedButton(
                              onTap: () {
                                // Apply logic or pop with result
                                Navigator.pop(context);
                              },
                              title: "Apply Filter",
                              backgroundColor: ColorConstants.primaryColor,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorConstants.primaryTextColor,
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> chips,
    String? selectedChip,
    required ValueChanged<String> onChipSelected,
  }) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children:
          chips.map((chipLabel) {
            final isSelected = selectedChip == chipLabel;
            return GestureDetector(
              onTap: () => onChipSelected(chipLabel),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? ColorConstants.primaryColor
                          : ColorConstants.disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  chipLabel,
                  style: TextStyle(
                    color:
                        isSelected
                            ? ColorConstants.whiteColor
                            : ColorConstants.primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
