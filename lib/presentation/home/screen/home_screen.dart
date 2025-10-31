import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, bottomNavProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔴 RED HEADER
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Title
                      Row(
                        children: [
                          const Text(
                            "Hi, Kristin",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.whiteColor,
                            ),
                          ),
                          Spacer(),
                          IconButton(onPressed: (){
                            AppRoutes.push(context, RouteNames.paymentFailedScreen);
                          }, icon: Icon(Icons.notifications, color: ColorConstants.whiteColor,))
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Let's start learning",
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorConstants.whiteColor,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ✅ My Session Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color:  ColorConstants.whiteColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Book Session Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "My Session",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Book Session",
                                  style: TextStyle(
                                    color: ColorConstants.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Session Time
                            Row(
                              children: const [
                                Text(
                                  "46min",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " / 60min",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: 46 / 60,
                                minHeight: 6,
                                color: ColorConstants.primaryColor,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Upcoming & Instructor Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _topSmallCard(
                        title: "Upcoming Bookings",
                        count: "06",
                        buttonText: "View all bookings",
                        buttonColor: ColorConstants.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      _topSmallCard(
                        title: "Active Instructors",
                        count: "06",
                        buttonText: "Find more instructors",
                        buttonColor: ColorConstants.primaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ✅ Quick Actions Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ✅ Quick Actions Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _quickButton("Find Instructors", () {
                            bottomNavProvider.onItemTapped(2);
                          }),
                          const SizedBox(width: 12),
                          _quickButton("My Booking", () {
                            bottomNavProvider.onItemTapped(1);
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _quickButton("View Profile", () {
                            print("Find Instructors tapped");
                            AppRoutes.push(context, RouteNames.editProfileScreen);
                            // Navigate or perform action
                          }),
                          const SizedBox(width: 12),
                          _quickButton("Settings", () {
                            bottomNavProvider.onItemTapped(3);
                          }),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Recent Activity
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:  ColorConstants.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Booking Confirmed",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Your session with John Smith has been confirmed for tomorrow at 2:00 PM",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "2 hours ago",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Top Small Cards
  Widget _topSmallCard({
    required String title,
    required String count,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  buttonText,
                  style: const TextStyle(color:  ColorConstants.whiteColor, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ✅ Quick Action Button
  Widget _quickButton(String text, Function() onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: ColorConstants.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
