class PaymentHistoryResponse {
  final bool success;
  final String message;
  final List<TransactionData> transactions;
  final Pagination pagination;

  PaymentHistoryResponse({
    required this.success,
    required this.message,
    required this.transactions,
    required this.pagination,
  });

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponse(
      success: json['success'],
      message: json['message'],
      transactions: (json['transactions'] as List)
          .map((t) => TransactionData.fromJson(t))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class TransactionData {
  final String id;
  final String learnerId;
  final String type;
  final String description;
  final String? bookingId;
  final String? packagePurchaseId;
  final String? relatedBookingId;
  final double amount;
  final String currency;
  final String status;
  final String? stripePaymentId;     // 👈 FIXED
  final String? metadata;            // 👈 FIXED
  final String createdAt;
  final String? processedAt;         // 👈 FIXED
  final String? failedAt;            // 👈 FIXED
  final String? refundedAt;          // 👈 FIXED

  TransactionData({
    required this.id,
    required this.learnerId,
    required this.type,
    required this.description,
    required this.bookingId,
    required this.packagePurchaseId,
    required this.relatedBookingId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.stripePaymentId,
    required this.metadata,
    required this.createdAt,
    required this.processedAt,
    required this.failedAt,
    required this.refundedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] ?? "",
      learnerId: json['learnerId'] ?? "",
      type: json['type'] ?? "",
      description: json['description'] ?? "",
      bookingId: json['bookingId'],
      packagePurchaseId: json['packagePurchaseId'],
      relatedBookingId: json['relatedBookingId'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? "",
      status: json['status'] ?? "",
      stripePaymentId: json['stripePaymentId'],       // nullable
      metadata: json['metadata'],                     // nullable
      createdAt: json['createdAt'] ?? "",
      processedAt: json['processedAt'],               // nullable
      failedAt: json['failedAt'],                     // nullable
      refundedAt: json['refundedAt'],                 // nullable
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
}
