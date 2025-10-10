import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/notifications/screens/notifications_tab_screen.dart';
import 'package:link_learner/widgets/asset_images.dart';

Widget buildNotificationList(List<NotificationItem> items) {
  if (items.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          assetImages(AppImages.noNotification, height: 150, width: 150),
          Text(
            'No Notifications yet!',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'We\'ll notify you once we have \nsomething for you',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: ColorConstants.disabledColor,
            ),
          ),
        ],
      ),
    );
  }
  return ListView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.only(top: 8.0),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return _buildNotificationCard(items[index]);
    },
  );
}

Widget _buildNotificationCard(NotificationItem item) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
    child: Card(
      color: ColorConstants.whiteColor,
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for the profile image (light green square)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.message,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_rounded,
                            size: 16,
                            color: ColorConstants.disabledColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            item.time,
                            style: TextStyle(
                              color: ColorConstants.disabledColor,

                              fontSize: 14,
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
        ],
      ),
    ),
  );
}
