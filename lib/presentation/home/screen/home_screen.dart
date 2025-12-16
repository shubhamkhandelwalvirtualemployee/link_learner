import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/presentation/home/provider/home_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HomeProvider>().getDashboardStats();
      context.read<HomeProvider>().getProfile();

    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomNavProvider, HomeProvider>(
      builder: (context, bottomNavProvider, homeProvider, _) {
        final dashboard = homeProvider.dashboardResponse?.data;
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: RefreshIndicator(
            onRefresh: () async => homeProvider.getDashboardStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
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
                        Row(
                          children: [
                            Text(
                              "Hi, ${homeProvider.profileResponse?.data?.user?.firstName ?? ''}",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.whiteColor,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                AppRoutes.push(
                                    context, RouteNames.paymentFailedScreen);
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: ColorConstants.whiteColor,
                              ),
                            )
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DYNAMIC CARDS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _topSmallCard(
                          title: "Upcoming Bookings",
                          count: dashboard?.stats.upcomingBookingsCount
                              ?.toString() ??
                              "0",
                          buttonText: "View all bookings",
                          buttonColor: ColorConstants.primaryColor,
                          onTap: (){
                            bottomNavProvider.onItemTapped(1);
                          }
                        ),
                        const SizedBox(width: 12),
                        _topSmallCard(
                          title: "Active Instructors",
                          count: dashboard?.stats.activeInstructorsCount
                              ?.toString() ??
                              "0",
                          buttonText: "Find more instructors",
                          buttonColor: ColorConstants.primaryColor,
                          onTap: (){
                            bottomNavProvider.onItemTapped(2);
                          }
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // QUICK ACTIONS
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
                              AppRoutes.push(
                                  context, RouteNames.editProfileScreen);
                            }),
                            const SizedBox(width: 12),
                            _quickButton("Settings", () {
                              bottomNavProvider.onItemTapped(3);
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // RECENT ACTIVITY — DYNAMIC
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

                  if ((dashboard?.recentActivity ?? []).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No recent activity found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dashboard!.recentActivity.length,
                      itemBuilder: (context, index) {
                        final activity = dashboard.recentActivity[index];
                        return _recentActivityCard(activity);
                      },
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TOP CARD
  Widget _topSmallCard({
    required String title,
    required String count,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,   // 👈 added callback
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

            // BUTTON with onTap
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
                onPressed: onTap,   // 👈 added
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: ColorConstants.whiteColor,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  // QUICK BUTTON
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
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
  // RECENT ACTIVITY CARD
  Widget _recentActivityCard(activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
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
          Icon(
            activity.status == "COMPLETED"
                ? Icons.check_circle
                : Icons.access_time,
            color: activity.status == "COMPLETED"
                ? Colors.green
                : Colors.orange,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.status,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  "Session with ${activity.instructor.user.firstName} ${activity.instructor.user.lastName}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  formatDate(activity.scheduledAt),    // 👈 formatted date
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
