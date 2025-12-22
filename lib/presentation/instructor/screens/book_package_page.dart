import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../model/instructor_package_model.dart'; // adjust as per your file
import '../provider/instructor_provider.dart';

class BookInstructorPackageScreen extends StatefulWidget {
  final InstructorUser instructor;
  final String instructorId;
  final double ratings;
  final int hourlyRate;

  const BookInstructorPackageScreen({
    super.key,
    required this.instructor,
    required this.instructorId,
    required this.ratings,
    required this.hourlyRate,
  });

  @override
  State<BookInstructorPackageScreen> createState() =>
      _BookInstructorPackageScreenState();
}

class _BookInstructorPackageScreenState
    extends State<BookInstructorPackageScreen> {
  String? selectedPackageId;

  @override
  void initState() {
    super.initState();
    Provider.of<InstructorProvider>(
      context,
      listen: false,
    ).getInstructorPackage(widget.instructorId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InstructorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Package",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ColorConstants.whiteColor,

      body:
          provider.isInstructorPackageLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _instructorCard(widget.instructor),

                    const SizedBox(height: 20),

                    ...provider.instructorPackagesResponse!.data
                        .map((pkg) => _packageCard(pkg))
                        .toList(),
                  ],
                ),
              ),
    );
  }

  Widget _instructorCard(instructor) {
    final String initials = [
      if (instructor.firstName.isNotEmpty)
        instructor.firstName[0].toUpperCase()
      else
        "",
      (instructor.lastName.isNotEmpty)
          ? instructor.lastName[0].toUpperCase()
          : "",
    ].join("");
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.primaryTextColor.withOpacity(0.25),
            // Shadow color with opacity
            spreadRadius: 0,
            // How wide the shadow spreads
            blurRadius: 4,
            // How soft the shadow looks
            offset: const Offset(0, 4), // x and y offset (move shadow)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: ColorConstants.disabledColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorConstants.disabledColor,
                  width: 2,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${instructor.firstName} ${instructor.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        size: 12,
                        color: ColorConstants.textColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        instructor.email,
                        style: const TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16),
                      Text(
                        " ${widget.ratings}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "\$${widget.hourlyRate}/session",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageCard(InstructorPackage pkg) {
    bool isSelected = selectedPackageId == pkg.id;
    final provider = Provider.of<InstructorProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => setState(() => selectedPackageId = pkg.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${pkg.name}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.textColor,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.green, size: 26),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              pkg.description,
              style: const TextStyle(
                fontSize: 12,
                color: ColorConstants.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBox("Lessons", "${pkg.lessonCount}"),
                _infoBox("Duration", "${pkg.duration} min"),
                _infoBox("Price / lesson", "\$${pkg.pricePerLesson}"),
                _infoBox("Validity", "${pkg.validityDays} days"),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Total: \$${pkg.totalPrice}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.textColor,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => selectedPackageId = pkg.id);
                    bool intentOK = await provider.createPaymentIntent(
                      widget.instructorId,
                      pkg.id,
                    );
                    if (!intentOK) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            provider.paymentIntentError ??
                                "Failed to create payment intent",
                          ),
                        ),
                      );
                      return;
                    }

                    // 4️⃣ Show Stripe Payment Sheet
                    bool paid = await provider.makePayment();
                    if (!paid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            provider.stripePaymentError ?? "Payment Failed",
                          ),
                        ),
                      );
                      AppRoutes.push(context, RouteNames.paymentFailedScreen);
                      return;
                    }

                    // 5️⃣ Payment Success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment Completed Successfully!"),
                      ),
                    );
                    AppRoutes.push(context, RouteNames.paymentSuccessScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book Package",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ColorConstants.whiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ColorConstants.backgroundTextFormFieldColor,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorConstants.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorConstants.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: ColorConstants.whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: ColorConstants.primaryTextColor.withOpacity(0.25),
          // Shadow color with opacity
          spreadRadius: 0,
          // How wide the shadow spreads
          blurRadius: 4,
          // How soft the shadow looks
          offset: const Offset(0, 4), // x and y offset (move shadow)
        ),
      ],
    );
  }
}
