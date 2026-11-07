import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

/// Association / Admin: society ka Visitor In-Out Log (reporting ke liye).
/// Data: GET /api/v1/committee/visitor-logs
class AssociationVisitorLogScreen extends ConsumerStatefulWidget {
  const AssociationVisitorLogScreen({super.key});

  @override
  ConsumerState<AssociationVisitorLogScreen> createState() =>
      _AssociationVisitorLogScreenState();
}

class _AssociationVisitorLogScreenState
    extends ConsumerState<AssociationVisitorLogScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  static const List<String> _rangeLabels = [
    "Today",
    "7 Days",
    "30 Days",
    "All",
  ];
  static const List<String> _statusLabels = [
    "All",
    "Inside",
    "Completed",
    "Pending",
    "Rejected",
  ];

  int _rangeIndex = 0;
  int _statusIndex = 0;

  List<Map<String, dynamic>> _logs = [];
  Map<String, dynamic> _summary = {};
  String _complexName = "";
  int _page = 1;
  int _lastPage = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        !_loading &&
        !_loadingMore &&
        _page < _lastPage) {
      _load(reset: false);
    }
  }

  String? _dateFrom() {
    final now = DateTime.now();
    final fmt = DateFormat('yyyy-MM-dd');
    switch (_rangeIndex) {
      case 0:
        return fmt.format(now);
      case 1:
        return fmt.format(now.subtract(const Duration(days: 6)));
      case 2:
        return fmt.format(now.subtract(const Duration(days: 29)));
      default:
        return null;
    }
  }

  String? _dateTo() {
    if (_rangeIndex == 3) return null;
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _failed = false;
        _page = 1;
      });
    } else {
      setState(() {
        _loadingMore = true;
      });
    }

    final targetPage = reset ? 1 : _page + 1;
    final statusKey = _statusLabels[_statusIndex].toLowerCase();

    try {
      final res = await ref
          .read(authServiceProvider)
          .getCommitteeVisitorLogs(
            dateFrom: _dateFrom(),
            dateTo: _dateTo(),
            status: (statusKey == "completed" ||
                    statusKey == "pending" ||
                    statusKey == "rejected")
                ? statusKey
                : null,
            onlyInside: statusKey == "inside",
            search: _searchController.text.trim(),
            page: targetPage,
          );

      if (!mounted) return;

      final data = res['data'];
      if (res['status'] == true && data is Map) {
        final List<Map<String, dynamic>> rows = [];
        final rawLogs = data['logs'];
        if (rawLogs is List) {
          for (final item in rawLogs) {
            if (item is Map) {
              rows.add(Map<String, dynamic>.from(item));
            }
          }
        }
        final pagination = data['pagination'];
        setState(() {
          if (reset) {
            _logs = rows;
          } else {
            _logs = [..._logs, ...rows];
          }
          _summary = data['summary'] is Map
              ? Map<String, dynamic>.from(data['summary'] as Map)
              : {};
          final complex = data['complex'];
          _complexName = complex is Map
              ? (complex['name']?.toString() ?? "")
              : _complexName;
          _page = targetPage;
          _lastPage = pagination is Map
              ? (int.tryParse(pagination['last_page'].toString()) ?? 1)
              : 1;
          _failed = false;
        });
      } else {
        setState(() {
          _failed = reset;
        });
      }
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
      if (mounted) {
        setState(() {
          _failed = reset;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _load(reset: true);
    });
  }

  String _durationText(dynamic minutes) {
    final m = int.tryParse(minutes?.toString() ?? "");
    if (m == null) return "--";
    if (m < 60) return "$m min";
    final h = m ~/ 60;
    final r = m % 60;
    return r == 0 ? "$h hr" : "$h hr $r min";
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "INSIDE":
        return const Color(0xFFD97706);
      case "COMPLETED":
        return const Color(0xFF16A765);
      case "REJECTED":
        return const Color(0xFFDC2626);
      case "APPROVED":
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Visitor Log",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    _complexName.isEmpty
                        ? "In / Out records of your society"
                        : _complexName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
          children: [
            _buildSummary(),
            SizedBox(height: 14.h),
            _buildSearch(),
            SizedBox(height: 12.h),
            _buildChipRow(
              labels: _rangeLabels,
              selected: _rangeIndex,
              onSelected: (i) {
                if (_rangeIndex == i) return;
                setState(() => _rangeIndex = i);
                _load(reset: true);
              },
            ),
            SizedBox(height: 8.h),
            _buildChipRow(
              labels: _statusLabels,
              selected: _statusIndex,
              onSelected: (i) {
                if (_statusIndex == i) return;
                setState(() => _statusIndex = i);
                _load(reset: true);
              },
            ),
            SizedBox(height: 14.h),
            ..._buildBody(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    if (_loading) {
      return [
        SizedBox(height: 60.h),
        const Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ];
    }
    if (_failed) {
      return [
        SizedBox(height: 50.h),
        Center(
          child: Text(
            "Could not load the visitor log.\nPull down to retry.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ];
    }
    if (_logs.isEmpty) {
      return [
        SizedBox(height: 50.h),
        Icon(
          Icons.groups_outlined,
          size: 44.sp,
          color: const Color(0xFFBDB8A8),
        ),
        SizedBox(height: 10.h),
        Center(
          child: Text(
            "No visitor records for these filters.",
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ];
    }
    return [
      ..._logs.map(_buildLogCard),
      if (_loadingMore)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          ),
        ),
    ];
  }

  Widget _buildSummary() {
    Widget tile(String label, String key, Color color) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xffE8E5DC)),
          ),
          child: Column(
            children: [
              Text(
                _summary[key]?.toString() ?? "0",
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tile("Total", "total", AppColors.heading),
        SizedBox(width: 8.w),
        tile("Inside now", "inside_now", const Color(0xFFD97706)),
        SizedBox(width: 8.w),
        tile("Completed", "completed", const Color(0xFF16A765)),
        SizedBox(width: 8.w),
        tile("Rejected", "rejected", const Color(0xFFDC2626)),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      style: GoogleFonts.outfit(fontSize: 15.sp, color: AppColors.heading),
      decoration: InputDecoration(
        hintText: "Search name, phone, vehicle or flat",
        hintStyle: GoogleFonts.outfit(
          fontSize: 14.sp,
          color: const Color(0xFF999999),
        ),
        prefixIcon: Icon(Icons.search, size: 20.sp, color: AppColors.heading),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffE8E5DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.heading, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildChipRow({
    required List<String> labels,
    required int selected,
    required ValueChanged<int> onSelected,
  }) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final isSel = selected == i;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? AppColors.heading : Colors.transparent,
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: AppColors.heading),
              ),
              child: Text(
                labels[i],
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: isSel ? Colors.white : AppColors.heading,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    final status = (log['status']?.toString() ?? "PENDING").toUpperCase();
    final color = _statusColor(status);
    final flat = log['flat']?.toString() ?? "";
    final type = log['visitor_type']?.toString() ?? "";
    final vehicle = log['vehicle_number']?.toString() ?? "";
    final guard = log['guard_name']?.toString() ?? "";
    final resident = log['resident_name']?.toString() ?? "";

    Widget infoCell(String title, String value) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffE8E5DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log['visitor_name']?.toString() ?? "Visitor",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      [
                        if (flat.isNotEmpty) "Flat $flat",
                        if (type.isNotEmpty) type,
                        if (vehicle.isNotEmpty) vehicle,
                      ].join(" • "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              infoCell("IN", log['in_time']?.toString() ?? "--"),
              SizedBox(width: 8.w),
              infoCell("OUT", log['out_time']?.toString() ?? "--"),
              SizedBox(width: 8.w),
              infoCell("STAYED", _durationText(log['duration_minutes'])),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            [
              log['date']?.toString() ?? "",
              if (resident.isNotEmpty) "Resident: $resident",
              if (guard.isNotEmpty) "Guard: $guard",
            ].where((e) => e.isNotEmpty).join("  •  "),
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              color: const Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }
}
