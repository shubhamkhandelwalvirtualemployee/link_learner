class ApiEndpoint {
  static const String register = "/v1/auth/register";
  static const String login = "/v1/auth/login";
  static const String getProfile = "/v1/users/profile";
  static const String updateProfile = "/v1/users/profile/learner";
  static const String resetPassword = "/v1/auth/request-password-reset";
  static const String changePassword = "/v1/auth/password";
  static const String instructorList = "/v1/instructors";
  static const String logout = "/v1/auth/logout";
  static const String calculatePrice = "/v1/bookings/calculate-price";
  static const String createBooking = "/v1/bookings";
  static const String paymentForBooking = "/v1/payments/booking";
  static const String paymentHistory = "/v1/payments/history";
  static const String checkAvailability = "/v1/bookings/check-availability";
  static const String refreshToken = "/v1/auth/refresh";
  static const String bookingsCredits = "/v1/bookings/credits";
  static const String paymentForPackage = "/v1/payments/package";
}
