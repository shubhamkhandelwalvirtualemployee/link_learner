import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/presentation/booking_and_search/widgets/search_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with AutomaticKeepAliveClientMixin<BookingScreen> {
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

  final List<String> filterChips = ['All', 'Upcoming', 'Completed'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<BookingProvider>(
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
                  'Your booking',
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
                      onTap: () {},
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

  Widget _buildFilterChips(BookingProvider bookingSearchProvider) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
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

                  Text(
                    "Booking type",
                    style: const TextStyle(
                      color: ColorConstants.disabledColor,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstants.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Cancelled',
                      style: TextStyle(
                        color: ColorConstants.errorColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "30 March 2020 | 16 hours",
                    style: const TextStyle(
                      color: ColorConstants.disabledColor,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorConstants.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
