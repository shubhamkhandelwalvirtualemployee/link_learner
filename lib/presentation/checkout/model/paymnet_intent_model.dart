class PaymentIntentResponse {
  final bool success;
  final String message;
  final PaymentIntentData data;

  PaymentIntentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentIntentResponse(
      success: json['success'],
      message: json['message'],
      data: PaymentIntentData.fromJson(json['data']),
    );
  }
}

class PaymentIntentData {
  final String clientSecret;
  final String paymentIntentId;
  final double amount;

  PaymentIntentData({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
  });

  factory PaymentIntentData.fromJson(Map<String, dynamic> json) {
    return PaymentIntentData(
      clientSecret: json['clientSecret'],
      paymentIntentId: json['paymentIntentId'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
