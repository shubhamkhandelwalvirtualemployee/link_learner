import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _inputField("First Name", nameCtrl),
            _inputField("Email", emailCtrl),
            _inputField("Description", descCtrl, maxLines: 4),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: elevatedButton(
                      onTap: () {
                        //  AppRoutes.pop(context);
                      },
                      title: "Submit",
                      backgroundColor: ColorConstants.primaryColor,
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

  Widget _inputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: customTextField(
        controller: controller,
        maxLines: maxLines,
        hintText: label,
        color: ColorConstants.primaryTextColor,
      ),
    );
  }
}
