import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../model/booking_list_response.dart';

class ReviewScreen extends StatefulWidget {
  final String instructorName;
  final String lessonDate;
  final String bookingId;
  final Review? review;

  const ReviewScreen({
    super.key,
    required this.instructorName,
    required this.bookingId,
    required this.lessonDate,
    this.review,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController commentController = TextEditingController();

  late Map<String, int> ratings;
  late bool isViewOnly;
  bool isPublic = true; // 👈 default public

  @override
  void initState() {
    super.initState();

    isViewOnly = widget.review != null;

    ratings = {
      "Punctuality": widget.review?.punctualityRating ?? 0,
      "Communication": widget.review?.communicationRating ?? 0,
      "Teaching Quality": widget.review?.teachingQualityRating ?? 0,
      "Patience": widget.review?.patienceRating ?? 0,
      "Vehicle Condition": widget.review?.vehicleConditionRating ?? 0,
    };

    if (widget.review?.comment != null) {
      commentController.text = widget.review!.comment!;
    }
  }

  /// ✅ All ratings must be given
  bool get isFormValid => ratings.values.every((r) => r > 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.whiteColor,
        title: const Text(
          "Leave a Review",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ColorConstants.primaryTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _instructorHeader(),
            const SizedBox(height: 20),
            _ratingCard(),
            const SizedBox(height: 20),
            _commentSection(),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isPublic,
                  activeColor: ColorConstants.primaryColor,
                  onChanged: isViewOnly
                      ? null
                      : (value) {
                    setState(() {
                      isPublic = value ?? true;
                    });
                  },
                ),
                const Text(
                  "Make this review public",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConstants.primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _bottomActions(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _instructorHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: ColorConstants.primaryColor,
          child: Text(
            widget.instructorName
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.instructorName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Lesson on ${widget.lessonDate}",
              style: const TextStyle(
                fontSize: 14,
                color: ColorConstants.iconColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= RATING CARD =================

  Widget _ratingCard() {
    return Column(
      children: [
        _ratingSection(
            "Punctuality", "Arrived on time for lessons"),
        _divider(),
        _ratingSection(
            "Communication", "Clear and helpful explanations"),
        _divider(),
        _ratingSection(
            "Teaching Quality", "Effective teaching methods"),
        _divider(),
        _ratingSection(
            "Patience", "Patient and supportive throughout"),
        _divider(),
        _ratingSection(
            "Vehicle Condition", "Clean and well-maintained vehicle"),
      ],
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(height: 1),
  );

  Widget _ratingSection(String title, String subtitle) {
    final currentRating = ratings[title] ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: ColorConstants.iconColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            final filled = index < currentRating;

            return GestureDetector(
              onTap: isViewOnly
                  ? null
                  : () {
                setState(() {
                  ratings[title] = index + 1;
                });
              },
              child: Icon(
                filled ? Icons.star : Icons.star_border,
                color: filled
                    ? ColorConstants.ratingColor
                    : ColorConstants.disabledColor,
                size: 26,
              ),
            );
          }),
        ),
      ],
    );
  }

  // ================= COMMENT =================

  Widget _commentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comment (optional)",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        customTextField(
          controller: commentController,
          maxLines: 4,
          readOnly: isViewOnly,
          hintText: "Share your experience with this instructor...",
        )
      ],
    );
  }

  // ================= ACTIONS =================

  Widget _bottomActions() {
    return SizedBox(
      width: double.infinity,
      child: elevatedButton(
          onTap: isViewOnly
              ? () => Navigator.pop(context)
              : isFormValid
              ? () async {
            final provider =
            context.read<BookingProvider>();

            final success = await provider.submitReview(
              bookingId: widget.bookingId,
              punctualityRating: ratings["Punctuality"] ?? 0,
              communicationRating: ratings["Communication"] ?? 0,
              teachingQualityRating: ratings["Teaching Quality"] ?? 0,
              patienceRating: ratings["Patience"] ?? 0,
              vehicleConditionRating: ratings["Vehicle Condition"] ?? 0,
              comment: commentController.text.trim(),
              isPublic: isPublic,
            );

            if (success && context.mounted) {
              Navigator.pop(context);
            }
          }
              : () {},
          title: isViewOnly ? "Close" : "Submit Review",
        backgroundColor: ColorConstants.primaryColor
      ),
    );
  }
}
