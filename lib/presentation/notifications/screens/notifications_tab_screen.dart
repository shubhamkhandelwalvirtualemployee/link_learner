import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/notifications/screens/notification_screen.dart';
import 'package:link_learner/presentation/notifications/screens/waiting_list_screen.dart';

class NotificationItem {
  final String senderName;
  final bool isOnline;
  final String time;
  final String message;
  final Color? backgroundColor;

  NotificationItem({
    required this.senderName,
    required this.isOnline,
    required this.time,
    required this.message,
    this.backgroundColor,
  });
}

class NotificationsTabScreen extends StatefulWidget {
  const NotificationsTabScreen({super.key});

  @override
  State<NotificationsTabScreen> createState() => _NotificationsTabScreenState();
}

class _NotificationsTabScreenState extends State<NotificationsTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Mock Data ---
  final List<NotificationItem> _waitingList = [
    NotificationItem(
      senderName: 'Bert Pullman',
      isOnline: true,
      time: '04:32 pm',
      message:
          'Congratulations on completing the first lesson, keep up the good work!',
    ),
    NotificationItem(
      senderName: 'Daniel Lawson',
      isOnline: true,
      time: '04:32 pm',
      message:
          'Your course has been updated, you can check the new course in your study course.',
      backgroundColor: const Color(0xFFFFDDE6), // The light pink background
    ),
    NotificationItem(
      senderName: 'Nguyen Shane',
      isOnline: false,
      time: '12:00 am',
      message: 'Congratulations, you have completed your ...',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide back button if not needed
        backgroundColor: ColorConstants.whiteColor,
        elevation: 0,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Align(alignment: Alignment.centerLeft, child: _buildTabBar()),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorConstants.whiteColor,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildWaitingList(_waitingList),
                  buildNotificationList(_waitingList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: ColorConstants.primaryTextColor,
      unselectedLabelColor: ColorConstants.disabledColor,
      indicatorColor: ColorConstants.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3.0,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      labelStyle: const TextStyle(fontSize: 18),
      unselectedLabelStyle: const TextStyle(fontSize: 18),
      tabs: [
        const Tab(text: 'waiting list'),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('notification'),
              const SizedBox(width: 4),
              // Small orange dot for new notifications
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: ColorConstants.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a single notification card item.
}
