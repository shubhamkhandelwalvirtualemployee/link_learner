import 'package:dio/dio.dart';
import 'package:link_learner/core/constants/stripe_Constant.dart';

class StripeServices {
  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      var response = await Dio().post(
        'https:api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StripeConstants.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      return response.data;
    } catch (err) {
      throw Exception('Create Payment Intent Error: $err');
    }
  }

  Future<String?> fetchChargeId(String paymentIntentId) async {
    try {
      final response = await Dio().get(
        'https:api.stripe.com/v1/payment_intents/$paymentIntentId',
        options: Options(
          headers: {'Authorization': 'Bearer ${StripeConstants.secretKey}'},
        ),
      );
      print(response.data.toString());
      final charges = response.data["latest_charge"];
      if (charges != null && charges.isNotEmpty) {
        return charges;
      }
    } catch (e) {
      print("Error fetching charge ID: $e");
    }
    return null;
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
