import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentAssociationCalendarScreen/provider/residentCalenderProvider.dart';

class ResidentCalendarScreen extends ConsumerStatefulWidget {
  const ResidentCalendarScreen({super.key});

  @override
  ConsumerState<ResidentCalendarScreen> createState() =>
      _ResidentCalendarScreenState();
}

class _ResidentCalendarScreenState
    extends ConsumerState<ResidentCalendarScreen> {
  DateTime currentMonth = DateTime.now();
  DateTime? selectedDate;
  String? currentMonthParam;

  final Set<int> eventDates = {3, 9, 18};

  final List<String> weekDays = [
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
  ];

  void previousMonth([String? prevMonthStr]) {
    setState(() {
      if (prevMonthStr != null && prevMonthStr.isNotEmpty) {
        currentMonthParam = prevMonthStr;
      }
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      selectedDate = null;
    });
  }

  void nextMonth([String? nextMonthStr]) {
    setState(() {
      if (nextMonthStr != null && nextMonthStr.isNotEmpty) {
        currentMonthParam = nextMonthStr;
      }
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDate = null;
    });
  }

  String get monthName {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[currentMonth.month - 1];
  }

  List<DateTime> getCalendarDates() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);

    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );

    final startOffset = firstDayOfMonth.weekday % 7;

    final List<DateTime> dates = [];

    // Previous month's dates
    for (int i = startOffset - 1; i >= 0; i--) {
      dates.add(DateTime(currentMonth.year, currentMonth.month, -i));
    }

    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      dates.add(DateTime(currentMonth.year, currentMonth.month, i));
    }
    int nextDay = 1;

    while (dates.length < 35) {
      dates.add(DateTime(currentMonth.year, currentMonth.month + 1, nextDay++));
    }

    return dates;
  }

  bool isCurrentMonth(DateTime date) {
    return date.month == currentMonth.month && date.year == currentMonth.year;
  }

  bool isSelected(DateTime date) {
    if (selectedDate == null) return false;
    return date.year == selectedDate!.year &&
        date.month == selectedDate!.month &&
        date.day == selectedDate!.day;
  }

  bool hasEvent(DateTime date) {
    return isCurrentMonth(date) && eventDates.contains(date.day);
  }

  Color _parseColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  IconData _getEventIcon(String? iconType) {
    switch (iconType?.toLowerCase()) {
      case 'users':
      case 'meeting':
        return Icons.groups_outlined;
      case 'announcement':
      case 'announcements':
        return Icons.campaign_outlined;
      case 'maintenance':
        return Icons.build_outlined;
      default:
        return Icons.groups_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getResidentCalenderProvider(currentMonthParam));
    final dates = getCalendarDates();
    final headerData = state.valueOrNull?.data?.header;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 41.w,
                  height: 41.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headerData?.tag ??
                        headerData?.title ??
                        "Association Calendar",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    headerData?.subtitle ?? "View upcoming community events",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: state.when(
        data: (data) {
          final calendar = data.data?.calendar;
          final upcoming = data.data?.upcomingEvents;
          final daysGrid = calendar?.daysGrid;
          final useApiGrid = daysGrid != null && daysGrid.isNotEmpty;
          final weekdaysList = calendar?.weekdays ?? weekDays;
          final eventsList = upcoming?.events ?? [];

          final Set<String> upcomingEventDates = {};
          for (final ev in eventsList) {
            if (ev.dateRaw != null) {
              upcomingEventDates.add(
                "${ev.dateRaw!.year}-${ev.dateRaw!.month}-${ev.dateRaw!.day}",
              );
            }
          }

          final bool hasTodayInGrid =
              useApiGrid && daysGrid.any((d) => d.isToday == true);

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              ref.invalidate(getResidentCalenderProvider(currentMonthParam));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      calendar?.title ?? "Calender",
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 22.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 45.w,
                                width: 45.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffEAF6F3),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 23.sp,
                                  color: const Color(0xff007C6B),
                                ),
                              ),
                              SizedBox(width: 13.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      calendar?.monthYear ??
                                          "$monthName ${currentMonth.year}",
                                      style: GoogleFonts.inter(
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff101C16),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      calendar?.subtitle ??
                                          "Community Calendar",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff777777),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    previousMonth(calendar?.previousMonth),
                                child: Container(
                                  height: 44.w,
                                  width: 44.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8FAF9),
                                    border: Border.all(
                                      color: const Color(0xffE5EAE7),
                                    ),
                                    borderRadius: BorderRadius.circular(11.r),
                                  ),
                                  child: Icon(
                                    Icons.chevron_left,
                                    size: 28.sp,
                                    color: const Color(0xff49635C),
                                  ),
                                ),
                              ),
                              SizedBox(width: 7.w),
                              GestureDetector(
                                onTap: () => nextMonth(calendar?.nextMonth),
                                child: Container(
                                  height: 44.w,
                                  width: 44.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8FAF9),
                                    border: Border.all(
                                      color: const Color(0xffE5EAE7),
                                    ),
                                    borderRadius: BorderRadius.circular(11.r),
                                  ),
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 28.sp,
                                    color: const Color(0xff49635C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: weekdaysList.map((day) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff8A9692),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 8.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: useApiGrid
                                ? daysGrid.length
                                : dates.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: 0.95,
                                ),
                            itemBuilder: (context, index) {
                              final int dayNum;
                              final bool selected;
                              final bool current;
                              final bool event;
                              final VoidCallback? onDateTap;

                              if (useApiGrid) {
                                final dayItem = daysGrid[index];
                                dayNum = dayItem.dayNumber ?? 0;
                                current = dayItem.isCurrentMonth ?? false;
                                final String? dayKey = dayItem.date != null
                                    ? "${dayItem.date!.year}-${dayItem.date!.month}-${dayItem.date!.day}"
                                    : null;
                                final bool hasUpcomingEvent =
                                    dayKey != null &&
                                    upcomingEventDates.contains(dayKey);
                                event =
                                    (dayItem.hasEvents ?? false) ||
                                    ((dayItem.eventCount ?? 0) > 0) ||
                                    hasUpcomingEvent;
                                selected = selectedDate != null
                                    ? (dayItem.date != null &&
                                          selectedDate!.year ==
                                              dayItem.date!.year &&
                                          selectedDate!.month ==
                                              dayItem.date!.month &&
                                          selectedDate!.day ==
                                              dayItem.date!.day)
                                    : hasTodayInGrid
                                    ? (dayItem.isToday ?? false)
                                    : false;
                                onDateTap = current
                                    ? () {
                                        setState(() {
                                          selectedDate = dayItem.date;
                                        });
                                      }
                                    : null;
                              } else {
                                final date = dates[index];
                                dayNum = date.day;
                                final String dateKey =
                                    "${date.year}-${date.month}-${date.day}";
                                final now = DateTime.now();
                                final bool isTodayDate =
                                    date.year == now.year &&
                                    date.month == now.month &&
                                    date.day == now.day;
                                selected = selectedDate != null
                                    ? isSelected(date)
                                    : isTodayDate;
                                current = isCurrentMonth(date);
                                event =
                                    hasEvent(date) ||
                                    upcomingEventDates.contains(dateKey);
                                onDateTap = current
                                    ? () {
                                        setState(() {
                                          selectedDate = date;
                                        });
                                      }
                                    : null;
                              }

                              return GestureDetector(
                                onTap: onDateTap,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xff007665)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$dayNum",
                                        style: GoogleFonts.inter(
                                          fontSize: 17.sp,
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: !current
                                              ? const Color(0xffC7CDCA)
                                              : selected
                                              ? Colors.white
                                              : event
                                              ? const Color(0xff007665)
                                              : const Color(0xff4D5552),
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      if (event && current)
                                        Container(
                                          width: 5.w,
                                          height: 5.w,
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? Colors.white
                                                : const Color(0xff007665),
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      else
                                        SizedBox(width: 5.w, height: 5.w),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Separate into upcoming and past events
                    Builder(
                      builder: (context) {
                        final todayItem = daysGrid
                            ?.where((d) => d.isToday == true)
                            .firstOrNull;
                        final today = todayItem?.date ?? DateTime.now();
                        final todayComparable = DateTime(
                          today.year,
                          today.month,
                          today.day,
                        );

                        final upcomingEvents = eventsList.where((ev) {
                          if (ev.dateRaw == null) return true;
                          final evDate = DateTime(
                            ev.dateRaw!.year,
                            ev.dateRaw!.month,
                            ev.dateRaw!.day,
                          );
                          return !evDate.isBefore(todayComparable);
                        }).toList();

                        final pastEvents = eventsList.where((ev) {
                          if (ev.dateRaw == null) return false;
                          final evDate = DateTime(
                            ev.dateRaw!.year,
                            ev.dateRaw!.month,
                            ev.dateRaw!.day,
                          );
                          return evDate.isBefore(todayComparable);
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              upcoming?.sectionTitle ?? "Upcoming Events",
                              style: GoogleFonts.outfit(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (upcomingEvents.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: upcomingEvents.length,
                                itemBuilder: (context, index) {
                                  final ev = upcomingEvents[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: eventCard(
                                      title: ev.title ?? "",
                                      date: ev.date ?? "",
                                      time: ev.time ?? "",
                                      badgeBg: _parseColor(
                                        ev.badgeIconBg,
                                        const Color(0xffEBD9A8),
                                      ),
                                      iconColor: _parseColor(
                                        ev.badgeIconColor,
                                        const Color(0xffA77900),
                                      ),
                                      icon: _getEventIcon(ev.icon),
                                    ),
                                  );
                                },
                              )
                            else
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: Center(
                                  child: Text(
                                    "No upcoming events",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff777777),
                                    ),
                                  ),
                                ),
                              ),
                            if (pastEvents.isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Text(
                                "Past Events",
                                style: GoogleFonts.outfit(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff777777),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: pastEvents.length,
                                itemBuilder: (context, index) {
                                  final ev = pastEvents[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Opacity(
                                      opacity: 0.85,
                                      child: eventCard(
                                        title: ev.title ?? "",
                                        date: ev.date ?? "",
                                        time: ev.time ?? "",
                                        badgeBg: const Color(0xffE5EAE7),
                                        iconColor: const Color(0xff777777),
                                        icon: _getEventIcon(ev.icon),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            SizedBox(height: 20.h),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "Error",
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.2,
              ),
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget eventCard({
    required String title,
    required String date,
    required String time,
    Color? badgeBg,
    Color? iconColor,
    IconData? icon,
  }) {
    Widget info(IconData icon, String text) {
      return Row(
        children: [
          Icon(icon, size: 17.sp, color: const Color(0xff101C16)),
          SizedBox(width: 11.w),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              color: const Color(0xff101C16),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff969696)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: badgeBg ?? const Color(0xffEBD9A8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.groups_outlined,
                  size: 18.sp,
                  color: iconColor ?? const Color(0xffA77900),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),
          Divider(height: 1, color: const Color(0xff8D8D8D)),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: info(Icons.calendar_today_outlined, date),
          ),

          Divider(height: 1, color: const Color(0xff8D8D8D)),

          Padding(
            padding: EdgeInsets.only(top: 13.h),
            child: info(Icons.access_time_outlined, time),
          ),
        ],
      ),
    );
  }
}
