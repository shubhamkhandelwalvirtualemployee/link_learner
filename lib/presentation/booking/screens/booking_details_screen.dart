import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/date_format.dart';
import 'package:link_learner/widgets/network_images.dart';
import 'package:provider/provider.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingSearchProvider>(
      builder: (context, bookingSearchProvider, child) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: ColorConstants.whiteColor,

            backgroundColor: ColorConstants.whiteColor,
            title: Text(
              "Checkout",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),

          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ColorConstants.whiteColor,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.disabledColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 70,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  ColorConstants
                                      .containerAndFillColor, // background for no image
                              image:
                              // (courseDetailsProvider
                              //                 .courseDetailsResponseModel
                              //                 .data
                              //                 ?.image !=
                              //             null &&
                              //         courseDetailsProvider
                              //             .courseDetailsResponseModel
                              //             .data!
                              //             .image!
                              //             .isNotEmpty)
                              //     ?
                              DecorationImage(
                                image: networkImages(""),
                                fit: BoxFit.cover,
                              ),
                              // : null,
                            ),
                            child:
                            // (courseDetailsProvider
                            //                 .courseDetailsResponseModel
                            //                 .data
                            //                 ?.image ==
                            //             null ||
                            //         courseDetailsProvider
                            //             .courseDetailsResponseModel
                            //             .data!
                            //             .image!
                            //             .isEmpty)
                            //     ?
                            const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: ColorConstants.iconColor,
                              ),
                            ),
                            // : null,
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Booking Fee",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${20}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Lorem Ipsum",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 5),

                      // Date
                      Text(
                        formatDateWithTime("2025-10-07T09:36:29.007Z"),
                        style: const TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 5),

                      // Instructor Info
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorConstants.whiteColor,
                            radius: 16,
                            backgroundImage: networkImages(""),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Austin",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Text(
                  "BILLING DETAIL",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Address- 415 Victoria Street, Westminster Abbey, London, SW1E 5NT",
                  style: const TextStyle(
                    fontSize: 16,

                    color: ColorConstants.disabledColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "PAYMENT METHOD",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Credit Card",
                  style: const TextStyle(
                    fontSize: 16,

                    color: ColorConstants.disabledColor,
                  ),
                ),

                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: elevatedButton(
                          onTap: () {
                            AppRoutes.pop(context);
                          },
                          title: "Book More",
                          backgroundColor: ColorConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
