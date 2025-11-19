import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';

class Lesson {
  final int number;
  final String title;
  final bool isCompleted;
  final bool isLocked;

  Lesson({
    required this.number,
    required this.title,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

class BuyBookingScreen extends StatelessWidget {
  BuyBookingScreen({super.key});

  // Mock Lesson Data
  final List<Lesson> lessons = [
    Lesson(number: 1, title: 'This is another booking', isCompleted: true),
    Lesson(number: 2, title: 'This is another booking', isCompleted: false),
    Lesson(number: 3, title: 'This is another booking', isLocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.transparentColor,
        surfaceTintColor: ColorConstants.transparentColor,
      ),
      body: Stack(
        children: [
          _buildHeader(context),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 120,
            child: _buildContentCard(context),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   bottom: 0,
        //   right: -50,
        //   child: SizedBox(
        //     height: 250,
        //     child: assetImages(AppImages.noNotification),
        //   ),
        // ),
        const Positioned(
          top: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BestsellerBadge(),
              SizedBox(height: 8),
              Text(
                'ProductDesign v1.0',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the main white content card with all the text and lessons.
  Widget _buildContentCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.primaryTextColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Title and Price
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Product Design v1.0',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryTextColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '\$74.00',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '6h ago · Lorem Ipsum',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorConstants.disabledColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // About this booking section
              const Text(
                'About this booking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,',
                style: TextStyle(
                  fontSize: 15,
                  color: ColorConstants.disabledColor,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              ...lessons.map((lesson) => _buildLessonItem(lesson)),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            lesson.number.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: ColorConstants.disabledColor,
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Click to add',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (lesson.isCompleted)
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.check_circle,
                          color: ColorConstants.primaryColor,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color:
                  lesson.isLocked
                      ? ColorConstants.disabledColor
                      : ColorConstants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              lesson.isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
              color:
                  lesson.isLocked
                      ? ColorConstants.whiteColor
                      : ColorConstants.whiteColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.disabledColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: ColorConstants.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.star_border_rounded,
                color: ColorConstants.errorColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: SizedBox(
                height: 50,
                child: elevatedButton(
                  onTap: () {
                   // AppRoutes.push(context, RouteNames.checkoutScreen);
                  },
                  title: "Buy Now",
                  backgroundColor: ColorConstants.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestsellerBadge extends StatelessWidget {
  const _BestsellerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD100),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'BESTSELLER',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
