import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:link_learner/widgets/network_images.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
  }

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
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: 30, right: 20, left: 20),
            height: 80,
            color: ColorConstants.whiteColor,
            alignment: Alignment.topCenter,
            child:
            // courseDetailsProvider
            //         .courseDetailsResponseModel
            //         .data!
            //         .isPurchased!
            //     ? Center(
            //       child: Text(
            //         "Registered",
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //           color: ColorConstants.primaryColor,
            //         ),
            //       ),
            //     )
            //     :
            SizedBox(
              width: double.infinity,
              height: 100,
              child: elevatedButton(
                title: 'Pay \$${20}',
                backgroundColor: ColorConstants.primaryColor,
                onTap: () {
                  AppRoutes.push(context, RouteNames.paymentFailedScreen);
                },
              ),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ColorConstants.whiteColor,
            padding: EdgeInsets.all(20),
            child:
            // courseDetailsProvider.isLoading
            //     ? Center(child: progressIndicator())
            //     :
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BOOKING DETAIL",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

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
                          formatDate("adssdasddsdsa"),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount to Pay',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\$${20}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "BILLING DETAIL",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Full Address",
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorConstants.disabledColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  customTextField(
                    controller: bookingSearchProvider.addressController,
                    maxLines: 4,
                    fillColor: ColorConstants.containerAndFillColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String formatDate(String dateTimeString) {
  try {
    final dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat(
      "d MMMM y",
    ).format(dateTime); // e.g., 7 May 2025
    return formattedDate;
  } catch (e) {
    return "Invalid date";
  }
}
