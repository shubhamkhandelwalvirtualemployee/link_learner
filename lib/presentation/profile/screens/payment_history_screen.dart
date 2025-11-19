import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {

  @override
  void initState() {
    super.initState();

    /// 🔥 Load payment history on page open
    Future.microtask(() {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.loadPaymentHistory();
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return ColorConstants.completedColor;
      case "FAILED":
        return ColorConstants.failedColor;
      case "PENDING":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final history = provider.paymentHistory;

        return Scaffold(
        backgroundColor:ColorConstants.whiteColor,
        appBar: AppBar(
            title: const Text("Payment History",style: TextStyle(fontSize: 24,
            fontWeight: FontWeight.w400),),
            backgroundColor:ColorConstants.whiteColor,
          ),

          body: provider.loadingPayments
              ? const Center(child: CircularProgressIndicator())

              : history == null || history.transactions.isEmpty
              ? const Center(
            child: Text(
              "No payment history available",
              style: TextStyle(fontSize: 16),
            ),
          )

              : ListView.builder(
            itemCount: history.transactions.length,
            itemBuilder: (_, index) {
              final tr = history.transactions[index];
              final date = DateFormat("dd MMM yyyy, h:mm a")
                  .format(DateTime.parse(tr.createdAt));

              return Padding(
                padding: const EdgeInsets.only(top:20.0,bottom: 20.0,left: 20,right: 20),
                child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants.boxShadowColor.withOpacity(0.20),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 9.0,top: 18,bottom: 7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount + Status Row
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "€${tr.amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Geist",
                                color: ColorConstants.textListColor
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _statusColor(tr.status)
                                    .withOpacity(0.15),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: Text(
                                tr.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _statusColor(tr.status),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          tr.description,
                          style: const TextStyle(
                            fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Geist",
                              color: ColorConstants.textListColor
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Stripe Payment ID:",
                              style: TextStyle(
                                  fontSize: 12, color: ColorConstants.textListColor,
                              fontWeight: FontWeight.w400),
                            ),
                            Text(
                              tr.stripePaymentId??"",
                              style: const TextStyle(
                                  fontSize: 12, color: ColorConstants.textListColor,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Date:",
                              style: TextStyle(
                                  fontSize: 12, color: ColorConstants.textListColor,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                  fontSize: 12, color: ColorConstants.textListColor,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
