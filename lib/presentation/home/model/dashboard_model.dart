class DashboardResponse {
  final bool success;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardData {
  final DashboardStats stats;
  final List<RecentActivity> recentActivity;

  DashboardData({required this.stats, required this.recentActivity});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: DashboardStats.fromJson(json['stats'] ?? {}),
      recentActivity:
          (json['recentActivity'] as List<dynamic>? ?? [])
              .map((e) => RecentActivity.fromJson(e))
              .toList(),
    );
  }
}

class DashboardStats {
  final int upcomingBookingsCount;
  final int completedSessionsCount;
  final int activeInstructorsCount;

  DashboardStats({
    required this.upcomingBookingsCount,
    required this.completedSessionsCount,
    required this.activeInstructorsCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      upcomingBookingsCount: json['upcomingBookingsCount'] ?? 0,
      completedSessionsCount: json['completedSessionsCount'] ?? 0,
      activeInstructorsCount: json['activeInstructorsCount'] ?? 0,
    );
  }
}

class RecentActivity {
  final String id;
  final String status;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Instructor instructor;

  RecentActivity({
    required this.id,
    required this.status,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.instructor,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      instructor: Instructor.fromJson(json['instructor'] ?? {}),
    );
  }
}

class Instructor {
  final String id;
  final User user;

  Instructor({required this.id, required this.user});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
