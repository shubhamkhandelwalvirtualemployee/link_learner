import 'dart:async';

import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/utils/search_bottom_sheet.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/presentation/instructor/provider/instructor_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class InstructorListScreen extends StatefulWidget {
  const InstructorListScreen({super.key});

  @override
  State<InstructorListScreen> createState() => _InstructorListScreenState();
}

class _InstructorListScreenState extends State<InstructorListScreen> {
  late ScrollController _controller;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_paginationLogic);

    Future.microtask(
      () => context.read<InstructorProvider>().getInstructorList(),
    );
  }

  void _paginationLogic() {
    final provider = context.read<InstructorProvider>();

    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 200 &&
        !provider.isPaginating &&
        provider.hasMore) {
      provider.getInstructorList(); // fetch next page
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InstructorProvider>();
    final response = provider.instructorListResponse;

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// ✅ Search bar UI
            _buildSearchBar(),

            const SizedBox(height: 20),

            /// ✅ LOADING
            if (provider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.primaryColor,
                  ),
                ),
              )
            /// ✅ NO DATA
            else if (response?.data.instructors == null ||
                response!.data.instructors.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No Instructors Found",
                    style: TextStyle(
                      color: ColorConstants.disabledColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            /// ✅ LIST VIEW
            else
              Expanded(
                child: ListView.separated(
                  controller: _controller,
                  // ✅ added
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount:
                      response.data.instructors.length +
                      (provider.isPaginating ? 1 : 0),
                  // ✅ loader row
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    if (index == response.data.instructors.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      );
                    }

                    final instructor = response.data!.instructors[index];
                    return _instructorCard(instructor);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ✅ SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 50,
        decoration: BoxDecoration(
          color: ColorConstants.containerAndFillColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 22),
            const SizedBox(width: 10),

            /// ✅ SEARCH FIELD (CONNECTED TO PROVIDER)
            Expanded(
              child: TextField(
                onChanged: (value) {
                  final provider = context.read<InstructorProvider>();
                  provider.searchText = value;

                  if (_searchDebounce?.isActive ?? false) {
                    _searchDebounce!.cancel();
                  }

                  _searchDebounce = Timer(
                    const Duration(milliseconds: 400),
                    () {
                      provider.getInstructorList(
                        isRefresh: true,
                      ); // ✅ IMPORTANT
                    },
                  );
                },
                decoration: const InputDecoration(
                  hintText: "Find Instructors",
                  hintStyle: TextStyle(
                    color: ColorConstants.disabledColor,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            /// ✅ FILTER ICON
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const SearchFilterBottomSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ColorConstants.containerAndFillColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: ColorConstants.disabledColor,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Instructor Card UI (Dynamic from API)
  Widget _instructorCard(Instructor instructor) {
    final String initials = [
      if (instructor.user.firstName.isNotEmpty) instructor.user.firstName[0].toUpperCase() else "",
      (instructor.user.lastName.isNotEmpty)
          ? instructor.user.lastName[0].toUpperCase()
          : "",
    ].join("");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.disabledColor.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ IMAGE BOX
          // firstName and lastName should come from your model
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

          const SizedBox(width: 16),

          /// ✅ INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Name + Rating Badge + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// ✅ Name + Bio + Address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ Instructor Name
                          Text(
                            "${instructor.user.firstName} ${instructor.user.lastName}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// ✅ Address Row (Icon + text)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${instructor.address}, ${instructor.city}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ColorConstants.disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                instructor.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${instructor.experience.toString()} years",
                                style: const TextStyle(
                                  color: ColorConstants.primaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// ✅ Rating + Hourly Rate
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// ✅ Rating Badge with star
                        const SizedBox(height: 6),

                        /// ✅ Hourly Rate
                        Text(
                          "£${instructor.hourlyRate}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          "per hour",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// ✅ Buttons row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final provider = Provider.of<InstructorProvider>(
                          context,
                          listen: false,
                        );

                        // ✅ 1. Call availability API
                        await provider.getWeeklyAvailabilityProvider(
                          instructor.id,
                        );

                        // ✅ 2. After data is loaded → go to calendar screen
                        AppRoutes.push(
                          context,
                          RouteNames.instructorDetailsScreen,
                          arguments: {'instructorId': instructor.id},
                        );
                      },
                      child: _actionButton("Book Session"),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        AppRoutes.push(
                          context,
                          RouteNames.bookInstructorPackageScreen,
                          arguments: {'instructorId': instructor.id,
                            'user':instructor.user,
                            'ratings':instructor.rating,
                            'hourlyRate':instructor.hourlyRate
                          },
                        );
                      },
                      child: _actionButton("Add Credits"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Beautiful Red Button
  Widget _actionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
