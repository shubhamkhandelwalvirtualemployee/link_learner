import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:link_learner/presentation/booking_and_search/widgets/search_bottom_sheet.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BookingSearchScreen extends StatefulWidget {
  const BookingSearchScreen({super.key});

  @override
  State<BookingSearchScreen> createState() => _BookingSearchScreenState();
}

class _BookingSearchScreenState extends State<BookingSearchScreen>
    with AutomaticKeepAliveClientMixin<BookingSearchScreen> {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> bookings = [
    {
      'title': 'Product Design v1.0',
      'person': 'Robertson Connie',
      'price': 190,
      'hours': 16,
    },
    {
      'title': 'Java Development',
      'person': 'Nguyen Shane',
      'price': 190,
      'hours': 16,
    },
    {
      'title': 'Visual Design',
      'person': 'Bert Pullman',
      'price': 250,
      'hours': 14,
    },
  ];

  final List<String> filterChips = ['All', 'Popular', 'New'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<BookingSearchProvider>(
      builder: (context, bookingSearchProvider, _) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildImageCards(),
                const SizedBox(height: 20),
                const Text(
                  'Choice your booking',
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterChips(bookingSearchProvider),
                const SizedBox(height: 16),

                ListView.separated(
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        AppRoutes.push(context, RouteNames.buyBookingScreen);
                      },
                      child: _buildBookingListItem(
                        title: bookings[index]['title'],
                        person: bookings[index]['person'],
                        price: bookings[index]['price'],
                        hours: bookings[index]['hours'],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorConstants.containerAndFillColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: ColorConstants.iconColor),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find Booking',
                hintStyle: TextStyle(color: ColorConstants.disabledColor),
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SearchFilterBottomSheet(),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.containerAndFillColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.filter_list,
                color: ColorConstants.disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Lorem Ips',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Lorem Ip',
                  style: TextStyle(
                    color: ColorConstants.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(BookingSearchProvider bookingSearchProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            filterChips.map((chipLabel) {
              final isSelected =
                  bookingSearchProvider.selectedChip == chipLabel;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () => bookingSearchProvider.selectChip(chipLabel),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? ColorConstants.primaryColor
                              : ColorConstants.transparentColor,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          isSelected
                              ? null
                              : Border.all(
                                color: ColorConstants.transparentColor,
                              ),
                    ),
                    child: Text(
                      chipLabel,
                      style: TextStyle(
                        color:
                            isSelected
                                ? ColorConstants.whiteColor
                                : ColorConstants.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBookingListItem({
    required String title,
    required String person,
    required int price,
    required int hours,
  }) {
    return Card(
      elevation: 1,
      color: ColorConstants.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorConstants.disabledColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: ColorConstants.disabledColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          person,
                          style: const TextStyle(
                            color: ColorConstants.disabledColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstants.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '$hours hours',
                          style: TextStyle(
                            color: ColorConstants.errorColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
