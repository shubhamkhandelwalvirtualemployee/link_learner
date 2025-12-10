import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/checkout/provider/checkout_provider.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/presentation/instructor/provider/instructor_provider.dart';
import 'package:link_learner/presentation/login_signup/widgets/hourly_widget.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class InstructorDetailScreen extends StatefulWidget {
  final String instructorId;

  const InstructorDetailScreen({super.key, required this.instructorId});

  @override
  State<InstructorDetailScreen> createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<InstructorProvider>(context, listen: false);
      provider.getInstructorDetailProvider(widget.instructorId);
      provider.getWeeklyAvailabilityProvider(widget.instructorId);
      final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
      provider.getAvailableSlotsProvider(widget.instructorId, today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstructorProvider>(
      builder: (context, provider, _) {
        if (provider.isAvailabilityLoading ||
            provider.instructorDetailResponse == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final instructor = provider.instructorDetailResponse!.data.instructor;
        final availability = provider.weeklyAvailability?.data ?? {};

        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Instructor Details",style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.w400),),
            leading: BackButton(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileCard(instructor),
                const SizedBox(height: 16),

                _buildSpecializations(instructor.specializations),
                const SizedBox(height: 16),

                _buildVehicleCard(instructor.vehicleDetails),
                const SizedBox(height: 16),

                _buildAvailabilitySection(availability),
                const SizedBox(height: 20),

                _buildBookNowButton(provider, instructor),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔥 BOOK NOW BUTTON
  Widget _buildBookNowButton(
    InstructorProvider provider,
    InstructorDetails instructor,
  ) {
    return SizedBox(
      width: 236,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {

          final checkOutProvider = Provider.of<CheckoutProvider>(context, listen: false);

          if (provider.selectedDate == null || provider.selectedSlot == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a date & time")),
            );
            return;
          }

          final selectedDate = provider.selectedDate!;
          final selectedSlot = provider.selectedSlot!;

          // FIRST: Check availability BEFORE navigation
          bool isAvailable = await checkOutProvider.checkAvailability(
            instructorId: instructor.id,
            selectedDate: selectedDate,
            startTime: selectedSlot.startTime,
            duration: 60,
          );
          print(isAvailable);

          if (!isAvailable) {
            // Show proper conflict dialog
            final message = checkOutProvider.availabilityResponse?.data.message ??
                "This time slot is not available.";

            final conflicts = checkOutProvider.availabilityResponse?.data.conflictingBookings ?? [];

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ❌ Warning Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 42,
                            color: Colors.redAccent,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Title
                        const Text(
                          "Instructor Not Available",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Message
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Conflicting bookings section
                        if (conflicts.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            "Conflicting Bookings:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...conflicts.map(
                                (id) => Text(
                              "• $id",
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Choose Another Time Slot",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            return; // ⛔ STOP — do NOT navigate
          }

          // If available → navigate to Checkout Page
          AppRoutes.push(
            context,
            RouteNames.checkoutPage,
            arguments: {
              "instructor": instructor,
              "selectedDate": selectedDate,
              "selectedSlot": selectedSlot,
            },
          );
        },
        child: const Text("Book Now", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // ---------------- PROFILE CARD ----------------
  Widget _buildProfileCard(InstructorDetails instructor) {
    final String initials = [
      if (instructor.user.firstName.isNotEmpty)
        instructor.user.firstName[0].toUpperCase()
      else
        "",
      (instructor.user.lastName.isNotEmpty)
          ? instructor.user.lastName[0].toUpperCase()
          : "",
    ].join("");
    return Container(
      decoration: _boxDecoration(),
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
                    "${instructor.user.firstName} ${instructor.user.lastName}",
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
                        instructor.user.email,
                        style: const TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: ColorConstants.textColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        instructor.address,
                        style: const TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "License Number: ",
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorConstants.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: instructor.rsaLicenseNumber,
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorConstants.textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Expiry: ",
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorConstants.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat('dd MMM yyyy')
                                  .format(DateTime.parse(instructor.licenseExpiryDate)),
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorConstants.textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor.bio,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16,color: ColorConstants.detailIconColor,),
                      Text(
                        " ${instructor.rating} (${instructor.totalReviews} reviews)",
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorConstants.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "\$${instructor.hourlyRate}/session",
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

  // ---------------- SPECIALIZATIONS ----------------
  Widget _buildSpecializations(List<String> specs) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: _boxDecoration(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Specializations",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,color: ColorConstants.textColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specs.map(
                  (e) => Chip(
                backgroundColor: ColorConstants.specializationColor, // chip background
                label: Text(
                  e,
                  style: const TextStyle(
                    color: ColorConstants.textColor, // text color
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide( // NO BORDER
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ).toList(),
          )
        ],
      ),
    );
  }

  // ---------------- VEHICLE CARD ----------------
  Widget _buildVehicleCard(VehicleDetails vehicle) {
    return Container(
      decoration: _boxDecoration(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Details",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,color: ColorConstants.textColor),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Make: ${vehicle.make}",style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,color: ColorConstants.textColor
                    ),),
                    Text("Model: ${vehicle.model}",style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,color: ColorConstants.textColor
                    ),),
                    Text("Year: ${vehicle.year}",style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,color: ColorConstants.textColor
                    ),),
                    Text("Transmission: ${vehicle.transmission}",style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,color: ColorConstants.textColor
                    ),),
                  ],
                ),
              ),
              Image.asset("assets/images/car.png", width: 120),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- AVAILABILITY SECTION ----------------
  // ------------------ MAIN AVAILABILITY SECTION ------------------
  Widget _buildAvailabilitySection(
      Map<int, List<AvailabilitySlot>> availability,
      ) {
    return Consumer<InstructorProvider>(
      builder: (context, provider, _) {
        provider.selectedDate ??= DateTime.now();

        // Initialize week start date
        provider.weekStartDate ??= provider.selectedDate!.subtract(
          Duration(days: provider.selectedDate!.weekday % 7),
        );

        // ---------------- WEEK DAYS LOADER ----------------
        List<DateTime> _getWeekDays(DateTime start) {
          return List.generate(7, (i) {
            final day = start.add(Duration(days: i));
            int key = day.weekday % 7;
            if ((availability[key] ?? []).isNotEmpty) return day;
            return null;
          }).whereType<DateTime>().toList();
        }

        List<DateTime> weekDays = _getWeekDays(provider.weekStartDate!);
        if (weekDays.isEmpty) weekDays = [provider.selectedDate!];

        // ---------------- WEEK NAVIGATION ----------------
        void goToNextWeek() {
          provider.setWeekStartDate(
            provider.weekStartDate!.add(const Duration(days: 7)),
          );
        }

        void goToPreviousWeek() {
          provider.setWeekStartDate(
            provider.weekStartDate!.subtract(const Duration(days: 7)),
          );
        }

        return Container(
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Date & Time",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.textColor,
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- MONTH + ARROWS ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _arrowButton(Icons.chevron_left,
                        enabled: true, onTap: goToPreviousWeek),
                    Text(
                      "${provider.selectedDate!.day} ${_monthName(provider.selectedDate!.month)} ${provider.selectedDate!.year}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    _arrowButton(Icons.chevron_right,
                        enabled: true, onTap: goToNextWeek),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------- DATE SELECTOR ----------
                _buildDateSelector(provider, availability),

                const SizedBox(height: 20),

                // ---------- TIME SLOTS ----------
                _buildTimeSlots(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _arrowButton(
      IconData icon, {
        required bool enabled,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled ? Colors.red.shade50 : Colors.grey.shade200,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? Colors.redAccent : Colors.grey.shade400,
            width: 1.2,
          ),
          boxShadow: [
            if (enabled)
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? Colors.redAccent : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      InstructorProvider provider,
      Map<int, List<AvailabilitySlot>> availability,
      ) {
    List<DateTime> weekDays = List.generate(7, (i) {
      final date = provider.weekStartDate!.add(Duration(days: i));
      int key = date.weekday % 7;

      if ((availability[key] ?? []).isNotEmpty) return date;
      return null;
    }).whereType<DateTime>().toList();

    if (weekDays.isEmpty) {
      return const Center(
        child: Text("No available days this week",
            style: TextStyle(color: Colors.grey)),
      );
    }

    provider.selectedDate ??= weekDays.first;

    return SizedBox(
      height: 75,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: weekDays.length,
        itemBuilder: (_, index) {
          final day = weekDays[index];

          final isSelected =
              provider.selectedDate!.day == day.day &&
                  provider.selectedDate!.month == day.month &&
                  provider.selectedDate!.year == day.year;

          return GestureDetector(
            onTap: () => provider.setSelectedDate(widget.instructorId,day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.redAccent : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.redAccent,
                  width: isSelected ? 2 : 1.2,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayShort(day),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${day.day}",
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots(InstructorProvider provider) {
    final slots = provider.availableSlotsResponse?.data.slots ?? [];

    if (provider.isSlotsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (slots.isEmpty) {
      return const Text("No slots available for this date");
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.9,
      ),
      itemBuilder: (_, index) {
        final slot = slots[index];
        final isSelected = provider.selectedSlot?.startTime == slot.startTime;

        return GestureDetector(
          onTap: () => provider.setSelectedSlot(
            AvailabilitySlot(
              id: "slot",
              dayOfWeek: provider.selectedDate!.weekday,
              startTime: slot.startTime,
              endTime: slot.endTime,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.redAccent : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.redAccent,
                width: isSelected ? 2 : 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "${slot.startTime} - ${slot.endTime}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.redAccent,
              ),
            ),
          ),
        );
      },
    );
  }

  String _weekdayShort(DateTime date) {
    return DateFormat("EEE").format(date).toUpperCase();
  }

  String _monthName(int month) {
    const names = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return names[month - 1];
  }

  List<AvailabilitySlot> generateHourlySlots(AvailabilitySlot slot) {
    final start = DateFormat("HH:mm").parse(slot.startTime);
    final end = DateFormat("HH:mm").parse(slot.endTime);

    List<AvailabilitySlot> result = [];

    DateTime current = start;
    while (current.isBefore(end)) {
      final next = current.add(const Duration(hours: 1));

      result.add(AvailabilitySlot(
        id: slot.id,
        dayOfWeek: slot.dayOfWeek,
        startTime: DateFormat("HH:mm").format(current),
        endTime: DateFormat("HH:mm").format(next),
      ));

      current = next;
    }

    return result;
  }

  // Generate hourly time slots

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
