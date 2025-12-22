import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:link_learner/presentation/booking/model/booking_Detail_response.dart';
import 'package:link_learner/presentation/booking/model/booking_list_response.dart';
import 'package:link_learner/services/api_calling.dart';

class BookingProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Booking> bookings = [];
  String selectedStatus = ""; // "" = All (no filter)
  String? paymentIntentError;
  String? stripePaymentError;
  String? clientSecret;
  String? paymentIntentId;
  BookingDetail? bookingDetail;

  /// Fetch Booking List
  Future<void> fetchBookings({String status = ""}) async {
    //try {
     // isLoading = true;
      notifyListeners();
      selectedStatus = status;
      final response = await ApiCalling().getBooking(status);
      print(response.bookings[0].instructor);
      bookings = response.bookings;
   /* } catch (e) {
      print("Booking error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }*/
  }

  Future<bool> createPaymentIntent(String bookingId) async {
    try {
      isLoading = true;
      paymentIntentError = null;
      notifyListeners();

      final response = await ApiCalling().createPaymentIntentForBooking(
        bookingId: bookingId!,
      );

      clientSecret = response.data.clientSecret;
      paymentIntentId = response.data.paymentIntentId;

      return true;
    } catch (e) {
      paymentIntentError = "Payment Intent Error: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // STEP 5 — STRIPE PAYMENT
  // ---------------------------------------------------------
  Future<bool> makePayment() async {
    try {
      stripePaymentError = null;

      if (clientSecret == null) {
        stripePaymentError = "Client secret missing";
        return false;
      }

      // 1. Initialize Stripe Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret!,
          merchantDisplayName: "Link Learner",
          style: ThemeMode.system,
        ),
      );

      // 2. Show Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      stripePaymentError = "Stripe Payment Failed: $e";
      return false;
    }
  }

  Future<void> fetchBookingDetail(String bookingId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiCalling().getBookingDetails(bookingId);
      bookingDetail = response.data;
    } catch (e) {
      print("❌ Booking detail error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitReview({
    required String bookingId,
    required int punctualityRating,
    required int communicationRating,
    required int teachingQualityRating,
    required int patienceRating,
    required int vehicleConditionRating,
    String? comment,
    required bool isPublic,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "bookingId": bookingId,
        "punctualityRating": punctualityRating,
        "communicationRating": communicationRating,
        "teachingQualityRating": teachingQualityRating,
        "patienceRating": patienceRating,
        "vehicleConditionRating": vehicleConditionRating,
        "comment": comment,
        "isPublic": isPublic,
      };

      await ApiCalling().submitReview(body);
      await fetchBookings();
      return true;
    } catch (e) {
      debugPrint("❌ Submit review error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {"reason": reason};

      await ApiCalling().cancelBooking(bookingId: bookingId, body: body);

      await fetchBookings(); // refresh list
      return true;
    } catch (e) {
      debugPrint("❌ Cancel booking error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
