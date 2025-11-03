import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/presentation/instructor/provider/instructor_provider.dart';
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
      final provider =
      Provider.of<InstructorProvider>(context, listen: false);
      provider.getInstructorDetailProvider(widget.instructorId);
      provider.getWeeklyAvailabilityProvider(widget.instructorId);
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

        final instructor =
            provider.instructorDetailResponse!.data.instructor;
        final availability = provider.weeklyAvailability?.data ?? {};

        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorConstants.whiteColor,
            title: const Text("Instructor Details"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Profile Section ---
                _buildProfileCard(instructor),

                const SizedBox(height: 16),

                // --- Specializations ---
                _buildSpecializations(instructor.specializations),

                const SizedBox(height: 16),

                // --- Vehicle Details ---
                _buildVehicleCard(instructor.vehicleDetails),

                const SizedBox(height: 16),

                // --- Availability Calendar ---
                _buildAvailability(availability),

                const SizedBox(height: 16),

                // --- Session Notes ---
                _buildNotesSection(),

                const SizedBox(height: 20),

                // --- Book Now Button ---
                Center(
                  child: SizedBox(
                    width: 236,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
  }

  Widget _buildProfileCard(InstructorDetails instructor) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:ColorConstants.primaryTextColor.withOpacity(0.25), // Shadow color with opacity
            spreadRadius: 0,                     // How wide the shadow spreads
            blurRadius: 4,                       // How soft the shadow looks
            offset: const Offset(0, 4),          // x and y offset (move shadow)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:
              NetworkImage(instructor.user.avatar ?? ''),
              backgroundColor: ColorConstants.textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${instructor.user.firstName} ${instructor.user.lastName}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold,color: ColorConstants.textColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 12,color: ColorConstants.textColor),
                      SizedBox(width: 4,),
                      Text(instructor.user.email , style: const TextStyle(
                          fontSize: 10, color: ColorConstants.textColor),),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12,color: ColorConstants.textColor),
                      SizedBox(width: 4,),
                      Text(instructor.address, style: const TextStyle(
                          fontSize: 10, color: ColorConstants.textColor),),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("License Number: ${instructor.rsaLicenseNumber}", style: const TextStyle(
                          fontSize: 10, color: ColorConstants.textColor),),
                      SizedBox(width: 10,),
                      Text("Expiry: ${ DateFormat('dd MMM yyyy').format(DateTime.parse(instructor.licenseExpiryDate))}", style: const TextStyle(
                          fontSize: 10, color: ColorConstants.textColor),),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10, color: ColorConstants.textColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16),
                      Text(" ${instructor.rating} (${instructor.totalReviews} reviews)", style: const TextStyle(
                          fontSize: 10, color: ColorConstants.textColor),),
                      const Spacer(),
                      Text(
                        "\$${instructor.hourlyRate}/session",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: ColorConstants.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializations(List<String> specs) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:ColorConstants.primaryTextColor.withOpacity(0.25), // Shadow color with opacity
            spreadRadius: 0,                     // How wide the shadow spreads
            blurRadius: 4,                       // How soft the shadow looks
            offset: const Offset(0, 4),          // x and y offset (move shadow)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Specializations",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: ColorConstants.textColor),),
            SizedBox(height: 10,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: specs
                  .map((e) => Chip(
                backgroundColor: ColorConstants.backgroundChipColor,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    style: BorderStyle.none, // ✅ Removes the border completely
                  ),
                  borderRadius: BorderRadius.circular(16), // 🔹 Rounded edges only
                ),
                label: Text(
                  e,
                  style: const TextStyle(color: ColorConstants.primaryTextColor),
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleDetails vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:ColorConstants.primaryTextColor.withOpacity(0.25), // Shadow color with opacity
            spreadRadius: 0,                     // How wide the shadow spreads
            blurRadius: 4,                       // How soft the shadow looks
            offset: const Offset(0, 4),          // x and y offset (move shadow)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vehicle Details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: ColorConstants.textColor),),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Make: ${vehicle.make}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: ColorConstants.textColor),),
                      Text("Model: ${vehicle.model}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: ColorConstants.textColor),),
                      Text("Year: ${vehicle.year}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: ColorConstants.textColor),),
                      Text("Transmission: ${vehicle.transmission}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: ColorConstants.textColor),),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/car.png', // sample placeholder
                  width: 120,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAvailability(Map<int, List<AvailabilitySlot>> availability) {
    DateTime today = DateTime.now();

    // 🔹 Move state variables OUTSIDE the builder so they persist across rebuilds
    DateTime selectedDate = today;
    DateTime currentWeekStart = today.subtract(Duration(days: today.weekday % 7)); // Start from Sunday

    return StatefulBuilder(
      builder: (context, setState) {
        // Helper: get days for the current week
        List<DateTime> getWeekDays(DateTime weekStart) {
          return List.generate(7, (index) => weekStart.add(Duration(days: index)));
        }

        List<DateTime> currentWeekDays = getWeekDays(currentWeekStart);

        // Go to next week
        void goToNextWeek() {
          setState(() {
            currentWeekStart = currentWeekStart.add(const Duration(days: 7));
            currentWeekDays = getWeekDays(currentWeekStart);
            selectedDate = currentWeekDays.first; // Auto-select first day (Sunday)
          });
        }

        // Go to previous week
        void goToPreviousWeek() {
          setState(() {
            currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
            currentWeekDays = getWeekDays(currentWeekStart);
            selectedDate = currentWeekDays.first;
          });
        }

        // Get slots for a given day
        List<AvailabilitySlot> getSlotsForDay(DateTime day) {
          int dayOfWeek = day.weekday % 7; // Sunday = 0
          return availability[dayOfWeek] ?? [];
        }

        return Container(
          decoration: BoxDecoration(
            color: ColorConstants.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:ColorConstants.primaryTextColor.withOpacity(0.25), // Shadow color with opacity
                spreadRadius: 0,                     // How wide the shadow spreads
                blurRadius: 4,                       // How soft the shadow looks
                offset: const Offset(0, 4),          // x and y offset (move shadow)
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Select Date & Time", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: ColorConstants.textColor),)
                  ],
                ),
                const SizedBox(height: 10),

                // --- Month & Arrow Navigation ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _arrowButton(Icons.chevron_left, enabled: true, onTap: goToPreviousWeek),
                    // 👇 Selected date + month display
                    Column(
                      children: [
                        Text(
                          "${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    _arrowButton(Icons.chevron_right, enabled: true, onTap: goToNextWeek),
                  ],
                ),

                const SizedBox(height: 16),

                // --- Weekday Selection ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: currentWeekDays.map((day) {
                      bool isSelected = day.day == selectedDate.day &&
                          day.month == selectedDate.month &&
                          day.year == selectedDate.year;
                      bool hasAvailability = (availability[day.weekday % 7] ?? []).isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap:  () => setState(() => selectedDate = day),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.redAccent : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: hasAvailability
                                    ? Colors.redAccent
                                    : Colors.grey.shade300,
                                width: 1.3,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _weekdayShortName(day),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${day.day}",
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Time Slots ---
                Builder(
                  builder: (_) {
                    final selectedSlots = getSlotsForDay(selectedDate);
                    if (selectedSlots.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No slots available for this day",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.6,
                      ),
                      itemCount: selectedSlots.length,
                      itemBuilder: (context, index) {
                        final slot = selectedSlots[index];
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Selected ${slot.startTime} - ${slot.endTime}"),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.redAccent),
                            ),
                            child: Text(
                              slot.startTime,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// 🔹 Helper methods
  String _weekdayShortName(DateTime date) {
    const names = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    return names[date.weekday % 7];
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }


  Widget _arrowButton(
      IconData icon, {
        required bool enabled,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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



  Widget _buildNotesSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:ColorConstants.primaryTextColor.withOpacity(0.25), // Shadow color with opacity
            spreadRadius: 0,                     // How wide the shadow spreads
            blurRadius: 4,                       // How soft the shadow looks
            offset: const Offset(0, 4),          // x and y offset (move shadow)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Session Notes (Optional)", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: ColorConstants.textColor),),
            const SizedBox(height: 8),
            Text(
              "Add your notes or topics you’d like  to discuss", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: ColorConstants.textColor),),
            const SizedBox(height: 8),
            const TextField(
              maxLength: 500,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "What would you like to focus on in this session?",
                hintStyle:  TextStyle(fontWeight: FontWeight.w400,fontSize: 8,color: ColorConstants.textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.backgroundTextFormFieldColor,width: 1)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
