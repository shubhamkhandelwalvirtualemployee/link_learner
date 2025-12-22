import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:link_learner/presentation/checkout/model/calculate_price_model.dart';
import 'package:link_learner/presentation/checkout/model/check_availablity_model.dart';
import 'package:link_learner/presentation/checkout/model/package_credit_list_response.dart';
import 'package:link_learner/services/api_calling.dart';

class CheckoutProvider extends ChangeNotifier {
  // ---------------------------------------------------------
  // Loading / Status
  // ---------------------------------------------------------
  bool isLoading = false;
  bool isCheckingAvailability = false;

  // ---------------------------------------------------------
  // Errors (each stage separate)
  // ---------------------------------------------------------
  String? availabilityError;
  String? bookingError;
  String? paymentIntentError;
  String? stripePaymentError;
  String? calculatePriceError;

  // ---------------------------------------------------------
  // Stored Data
  // ---------------------------------------------------------
  PriceData? priceData;
  CheckAvailabilityResponse? availabilityResponse;
  PackageCreditListResponse? packageCreditListResponse;
  String? bookingId;
  double? finalPrice;

  String? clientSecret;
  String? paymentIntentId;

  // ---------------------------------------------------------
  // STEP 1 — CALCULATE PRICE
  // ---------------------------------------------------------
  Future<void> calculatePrice({
    required String instructorId,
    required DateTime selectedDate,
    required String startTime,
    int duration = 60,
  }) async {
    try {
      isLoading = true;
      priceData = null;
      notifyListeners();

      final parts = startTime.split(":");

      final scheduledAt =
          DateTime.utc(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          ).toIso8601String();

      final response = await ApiCalling().calculatePrice(
        instructorId: instructorId,
        selectedDate: scheduledAt,
        duration: duration,
      );

      if (response.success) {
        priceData = response.data;
        finalPrice = response.data.finalPrice;
      } else {
        calculatePriceError = response.message;
      }
    } catch (e) {
      calculatePriceError = "Price Calculation Error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // STEP 2 — CHECK AVAILABILITY
  // ---------------------------------------------------------
  Future<bool> checkAvailability({
    required String instructorId,
    required DateTime selectedDate,
    required String startTime,
    int duration = 60,
  }) async {
    print(startTime);
    try {
      isCheckingAvailability = true;
      availabilityError = null;
      notifyListeners();

      final parts = startTime.split(":");

      final scheduledAt =
          DateTime.utc(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          ).toIso8601String();

      final res = await ApiCalling().checkAvailability(
        instructorId: instructorId,
        scheduledAt: scheduledAt,
        duration: duration,
      );

      availabilityResponse = res;

      return res.data.isAvailable;
    } catch (e) {
      availabilityError = "Availability Check Failed: $e";
      return false;
    } finally {
      isCheckingAvailability = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // STEP 3 — CREATE BOOKING
  // ---------------------------------------------------------
  Future<bool> createBooking({
    required String instructorId,
    required DateTime selectedDate,
    required String startTime,
    required String location,
    required String notes,
    int duration = 60,
  }) async {
    try {
      isLoading = true;
      bookingError = null;
      notifyListeners();
      final parts = startTime.split(":");

      final scheduledAt =
          DateTime.utc(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          ).toIso8601String();

      final res = await ApiCalling().createBooking(
        instructorId: instructorId,
        scheduledAt: scheduledAt,
        duration: duration,
        location: location,
        notes: notes,
      );

      bookingId = res.data.id;
      finalPrice = (res.data.finalPrice as num).toDouble();

      return true;
    } catch (e) {
      bookingError = "Create Booking Failed: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBookingCredits({
    required String instructorId,
    required DateTime selectedDate,
    required String startTime,
    required String location,
    required String notes,
    required String packageId,
    required bool usePackageCredit,
    int duration = 60,
  }) async {
    try {
      print(startTime);
      isLoading = true;
      bookingError = null;
      notifyListeners();
      final parts = startTime.split(":");

      final scheduledAt =
          DateTime.utc(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          ).toIso8601String();

      final res = await ApiCalling().createBookingForCredits(
        instructorId: instructorId,
        scheduledAt: scheduledAt,
        duration: duration,
        location: location,
        notes: notes,
        packageId: packageId,
        usePackageCredit: usePackageCredit,
      );

      bookingId = res.data.id;
      finalPrice = (res.data.finalPrice as num).toDouble();

      return true;
    } catch (e) {
      print(e);
      bookingError = "Create Booking Failed: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // STEP 4 — CREATE PAYMENT INTENT (BACKEND)
  // ---------------------------------------------------------
  Future<bool> createPaymentIntent() async {
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

  Future<void> getBookingCreditProvider(String instructorId) async {
    try {
      final res = await ApiCalling().getBookingCredits(instructorId);
      packageCreditListResponse = res;
    } catch (e) {
      debugPrint("Error fetching instructor detail: $e");
    }
    notifyListeners();
  }
}
