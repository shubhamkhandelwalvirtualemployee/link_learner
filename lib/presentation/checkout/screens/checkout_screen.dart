import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/checkout/model/package_credit_list_response.dart';
import 'package:link_learner/presentation/checkout/provider/checkout_provider.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final InstructorDetails instructor;
  final DateTime selectedDate;
  final AvailabilitySlot selectedSlot;

  const CheckoutPage({
    super.key,
    required this.instructor,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool useCredits = false;
  int selectedPackageIndex = 0;
  int selectedCreditIndex = -1;  // -1 = not using credits

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CheckoutProvider>(context, listen: false).calculatePrice(
        instructorId: widget.instructor.id,
        selectedDate: widget.selectedDate,
        startTime: widget.selectedSlot.startTime,
      );
      Provider.of<CheckoutProvider>(context, listen: false).getBookingCreditProvider(widget.instructor.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildInstructorCard(),
            const SizedBox(height: 16),

            _buildBookingSummary(),
            const SizedBox(height: 16),

            // PRICE SUMMARY VIA PROVIDER
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator()),

            if (!provider.isLoading && provider.calculatePriceError != null)
              Text(provider.calculatePriceError!,
                  style: const TextStyle(color: Colors.red)),

            if (!provider.isLoading &&
                provider.calculatePriceError == null &&
                provider.priceData != null)
              _buildPriceSummary(provider),

            const SizedBox(height: 20),
            if (provider.packageCreditListResponse != null &&
                provider.packageCreditListResponse!.data.isNotEmpty)
              _buildPaymentMethod(provider),
            const SizedBox(height: 20),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Instructor Card
  // -------------------------------------------------------------------
  Widget _buildInstructorCard() {
    final i = widget.instructor;
    final String initials = [
      if (i.user.firstName.isNotEmpty) i.user.firstName[0].toUpperCase() else "",
      (i.user.lastName.isNotEmpty)
          ? i.user.lastName[0].toUpperCase()
          : "",
    ].join("");
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: ColorConstants.disabledColor.withOpacity(0.2),
              shape: BoxShape.circle, // ✅ Make it circular
              border: Border.all(
                color: ColorConstants.disabledColor,
                width: 2, // ✅ nice border like you wanted
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.disabledColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${i.user.firstName} ${i.user.lastName}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Rating: ⭐ ${i.rating} (${i.totalReviews} reviews)"),
              Text("€${i.hourlyRate}/hour",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
            ]),
          )
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // Booking Summary
  // -------------------------------------------------------------------
  Widget _buildBookingSummary() {
    final formattedDate = DateFormat("dd MMM yyyy").format(widget.selectedDate);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Booking Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _row("Date", formattedDate),
          _row("Time", "${widget.selectedSlot.startTime} - ${widget.selectedSlot.endTime}"),

          const SizedBox(height: 12),
          const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: "Enter location",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),
          const Text("Notes (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Add any notes...",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // PRICE SUMMARY (provider-based)
  // -------------------------------------------------------------------
  Widget _buildPriceSummary(CheckoutProvider provider) {
    final data = provider.priceData!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Price Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        _row("Base Price", "€${data.basePrice.toStringAsFixed(2)}"),
        _row("Peak Surcharge", "€${data.peakSurcharge.toStringAsFixed(2)}"),
        _row("Weekend Surcharge", "€${data.weekendSurcharge.toStringAsFixed(2)}"),
        _row("Demand Surcharge", "€${data.demandSurcharge.toStringAsFixed(2)}"),

        const Divider(),
        _row("Final Price", "€${data.finalPrice.toStringAsFixed(2)}"),

        const SizedBox(height: 8),
        const Text("Breakdown:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),

        ...data.breakdown.map((line) => Text("- $line")),
      ]),
    );
  }

  Widget _buildPaymentMethod(CheckoutProvider provider) {
    final response = provider.packageCreditListResponse;

    if (response == null || response.data == null || response.data!.isEmpty) {
      return SizedBox();
    }

    final creditsList = response.data!;
    final priceData = provider.priceData;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          // ---------------- AVAILABLE CREDITS ----------------
          const Text("Available Credits",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),

          // ---------------- LIST OF CREDIT PACKAGES ----------------
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: creditsList.length,
            itemBuilder: (_, index) {
              final pkg = creditsList[index];
              final isSelected = useCredits && selectedCreditIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    useCredits = true;
                    selectedCreditIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? ColorConstants.primaryColor
                          : Colors.red.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? ColorConstants.primaryColor.withOpacity(0.1)
                        : Colors.red.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${pkg.lessonsIncluded} Sessions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textColor,
                          )),
                      SizedBox(height: 4),
                      Text(
                        "${pkg.lessonsRemaining} of ${pkg.lessonsIncluded} sessions remaining",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ---------------- PAY PER SESSION OPTION ----------------
          GestureDetector(
            onTap: () {
              setState(() {
                useCredits = false;
                selectedCreditIndex = -1;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !useCredits
                      ? ColorConstants.primaryColor
                      : Colors.red.shade200,
                  width: !useCredits ? 2 : 1,
                ),
                color: !useCredits
                    ? ColorConstants.primaryColor.withOpacity(0.1)
                    : Colors.red.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pay for session",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textColor)),
                  SizedBox(height: 4),
                  Text("€${priceData?.finalPrice ?? 0} per session",
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  // -------------------------------------------------------------------
  // Confirm Button (Next Step)
  // -------------------------------------------------------------------
  Widget _buildConfirmButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: elevatedButton(
          onTap: () async {
            final location = locationController.text.trim();

            if (location.length < 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please add a correct location (at least 5 characters) to help the instructor prepare.",
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            if(useCredits){
              final provider = Provider.of<CheckoutProvider>(context, listen: false);
              final credits = provider.packageCreditListResponse!.data.first;
              bool available = await provider.checkAvailability(
                instructorId: widget.instructor.id,
                selectedDate: widget.selectedDate,
                startTime: widget.selectedSlot.startTime,
              );
              if (!available) {
                final msg = provider.availabilityResponse?.data.message ?? "Slot unavailable";
                final conflicts = provider.availabilityResponse?.data.conflictingBookings ?? [];

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Instructor Not Available"),
                    content: Text("$msg\n\nConflicts: ${conflicts.join(", ")}"),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
                return;
              }
              bool bookingOK = await provider.createBookingCredits(
                instructorId: widget.instructor.id,
                selectedDate: widget.selectedDate,
                startTime: widget.selectedSlot.startTime,
                location: locationController.text,
                notes: notesController.text,
                packageId: credits.id,
                usePackageCredit: true,
              );

              if (!bookingOK) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.bookingError ?? "Booking Failed")),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking Completed Successfully!")),
              );
              AppRoutes.push(context, RouteNames.paymentSuccessScreen);
            }else{
            final provider = Provider.of<CheckoutProvider>(context, listen: false);

            // 1️⃣ Check Availability First
            bool available = await provider.checkAvailability(
              instructorId: widget.instructor.id,
              selectedDate: widget.selectedDate,
              startTime: widget.selectedSlot.startTime,
            );

            if (!available) {
              final msg = provider.availabilityResponse?.data.message ?? "Slot unavailable";
              final conflicts = provider.availabilityResponse?.data.conflictingBookings ?? [];

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Instructor Not Available"),
                  content: Text("$msg\n\nConflicts: ${conflicts.join(", ")}"),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
              return;
            }

            // 2️⃣ Slot Available — Create Booking
            bool bookingOK = await provider.createBooking(
              instructorId: widget.instructor.id,
              selectedDate: widget.selectedDate,
              startTime: widget.selectedSlot.startTime,
              location: locationController.text,
              notes: notesController.text,
            );

            if (!bookingOK) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.bookingError ?? "Booking Failed")),
              );
              return;
            }

            // 3️⃣ Create Payment Intent
            bool intentOK = await provider.createPaymentIntent();
            if (!intentOK) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.paymentIntentError ?? "Failed to create payment intent")),
              );
              return;
            }

            // 4️⃣ Show Stripe Payment Sheet
            bool paid = await provider.makePayment();
            if (!paid) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.stripePaymentError ?? "Payment Failed")),
              );
              AppRoutes.push(context, RouteNames.paymentFailedScreen);
              return;
            }

            // 5️⃣ Payment Success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment Completed Successfully!")),
            );
            AppRoutes.push(context, RouteNames.paymentSuccessScreen);
          }},
          title: "Confirm Booking",
          backgroundColor: ColorConstants.primaryColor,
        ),
      ),
    );
  }

  // Helper UI widgets
  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
  );

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
