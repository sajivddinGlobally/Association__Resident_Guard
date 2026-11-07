import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAIProperty/Provider/getPropertyAssistantProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyAssistantModel.dart';
import 'package:svg_flutter/svg.dart';
import '../../Core/AuthService/AuthServiceProvider.dart';

class AiPropertyAssistantScreen extends ConsumerStatefulWidget {
  const AiPropertyAssistantScreen({super.key});

  @override
  ConsumerState<AiPropertyAssistantScreen> createState() =>
      _AiPropertyAssistantScreenState();
}

class _AiPropertyAssistantScreenState
    extends ConsumerState<AiPropertyAssistantScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _assistantScrollController = ScrollController();
  final GlobalKey _inputFieldKey = GlobalKey();

  bool isSending = false;
  String? pendingQuery;
  GetPropertyAssistantModel? updatedModel;

  void _scrollToInputField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inputFieldKey.currentContext != null) {
        Scrollable.ensureVisible(
          _inputFieldKey.currentContext!,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      } else if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollAssistantToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_assistantScrollController.hasClients) {
        _assistantScrollController.animateTo(
          _assistantScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();

    if (message.isEmpty || isSending) return;

    messageController.clear();
    setState(() {
      isSending = true;
      pendingQuery = message;
    });
    _scrollToInputField();
    _scrollAssistantToBottom();

    try {
      final response = await ref
          .read(authServiceProvider)
          .sendMessageToAi(query: message);

      if (mounted) {
        setState(() {
          updatedModel = response;
          pendingQuery = null;
          isSending = false;
        });
        ref.invalidate(getPropertyAssistantProvider);
        _scrollToInputField();
        _scrollAssistantToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          pendingQuery = null;
          isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send message: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    _assistantScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPropertyAssistant = ref.watch(getPropertyAssistantProvider);

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
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // "AI Property Assistant",
                    "Stayo Assistant",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Your property information assistant",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: getPropertyAssistant.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xff101C16)),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Failed to load AI Assistant",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff101C16),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff101C16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => ref.refresh(getPropertyAssistantProvider),
                child: Text(
                  "Retry",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (modelData) {
          final effectiveData = updatedModel?.data ?? modelData.data;
          final data = effectiveData;

          final rawAssistantStatus = data?.assistant?.status ?? "ready";
          final assistantStatusText = rawAssistantStatus.isNotEmpty
              ? " ${rawAssistantStatus[0].toUpperCase()}${rawAssistantStatus.substring(1)}"
              : " Ready";

          final welcomeMessage =
              data?.assistant?.welcomeMessage ??
              "Ask questions about your property, inspections, maintenance,\n complaints, service requests and property status.";

          final propertyName = data?.property?.name ?? "Property Not Assigned";
          final complexName =
              data?.property?.complexName ?? "Society Not Linked";
          final rawPropStatus =
              data?.property?.status ??
              (data?.property?.name != null ? "Active" : "Not Linked");
          final propertyStatus = rawPropStatus.isNotEmpty
              ? "${rawPropStatus[0].toUpperCase()}${rawPropStatus.substring(1)}"
              : "Active";

          final suggestedPrompts = data?.suggestedPrompts ?? [];

          // Retain history from updated model or modelData, preserving all entries
          List<RecentHistory> rawHistory = [];
          if (updatedModel?.data?.recentHistory != null &&
              updatedModel!.data!.recentHistory!.isNotEmpty) {
            rawHistory = List.from(updatedModel!.data!.recentHistory!);
            if (modelData.data?.recentHistory != null) {
              for (var oldItem in modelData.data!.recentHistory!) {
                final exists = rawHistory.any(
                  (item) =>
                      (item.id != null &&
                          oldItem.id != null &&
                          item.id == oldItem.id) ||
                      (item.query == oldItem.query &&
                          item.aiResponse == oldItem.aiResponse),
                );
                if (!exists) {
                  rawHistory.add(oldItem);
                }
              }
            }
          } else if (modelData.data?.recentHistory != null) {
            rawHistory = List.from(modelData.data!.recentHistory!);
          }

          final recentHistory = rawHistory.isNotEmpty
              ? rawHistory.reversed.toList()
              : <RecentHistory>[];

          return RefreshIndicator(
            color: const Color(0xff101C16),
            onRefresh: () async {
              setState(() {
                updatedModel = null;
                pendingQuery = null;
              });
              return ref.refresh(getPropertyAssistantProvider.future);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Stayo Assistant is ",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            TextSpan(
                              text: assistantStatusText,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xffAE8130),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF101C16),
                                width: 1.2.w,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Container(
                                width: 42.w,
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF101C16),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/SvgImage/vector.svg",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Hello, how can I help?",
                            style: GoogleFonts.outfit(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            welcomeMessage,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(42, 41, 51, 0.75),
                              letterSpacing: -0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 42.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: AppColors.heading),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/auditImg.png",
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  propertyName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    fontSize: 17.sp,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  complexName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                    fontSize: 14.sp,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            propertyStatus,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              fontSize: 15.sp,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Suggested Questions",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      color: const Color(0xFFFFFCEF),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _questionCard(
                                  icon: Icons.crop_square,
                                  title: suggestedPrompts.isNotEmpty
                                      ? suggestedPrompts[0]
                                      : "What is my current property status?",
                                  isSelected: true,
                                  onTap: () {
                                    final prompt = suggestedPrompts.isNotEmpty
                                        ? suggestedPrompts[0]
                                        : "What is my current property status?";
                                    messageController.text = prompt;
                                    _scrollToInputField();
                                  },
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: _questionCard(
                                  icon: Icons.check,
                                  title: suggestedPrompts.length > 1
                                      ? suggestedPrompts[1]
                                      : "Show my latest inspection status",
                                  onTap: () {
                                    final prompt = suggestedPrompts.length > 1
                                        ? suggestedPrompts[1]
                                        : "Show my latest inspection status";
                                    messageController.text = prompt;
                                    _scrollToInputField();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: _questionCard(
                                  icon: Icons.settings,
                                  title: suggestedPrompts.length > 2
                                      ? suggestedPrompts[2]
                                      : "What maintenance is pending?",
                                  onTap: () {
                                    final prompt = suggestedPrompts.length > 2
                                        ? suggestedPrompts[2]
                                        : "What maintenance is pending?";
                                    messageController.text = prompt;
                                    _scrollToInputField();
                                  },
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: _questionCard(
                                  icon: Icons.priority_high,
                                  title: suggestedPrompts.length > 3
                                      ? suggestedPrompts[3]
                                      : "Do I have any open complaints?",
                                  onTap: () {
                                    final prompt = suggestedPrompts.length > 3
                                        ? suggestedPrompts[3]
                                        : "Do I have any open complaints?";
                                    messageController.text = prompt;
                                    _scrollToInputField();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Assistant",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      height: 320.h,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFCEF),
                        border: Border.all(
                          color: const Color(0xFF222222),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Scrollbar(
                        controller: _assistantScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _assistantScrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (recentHistory.isNotEmpty) ...[
                                for (
                                  int i = 0;
                                  i < recentHistory.length;
                                  i++
                                ) ...[
                                  if (recentHistory[i].query != null &&
                                      recentHistory[i].query!
                                          .trim()
                                          .isNotEmpty) ...[
                                    if (i > 0) SizedBox(height: 12.h),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 280.w,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFE8D8),
                                          border: Border.all(
                                            color: AppColors.heading,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          recentHistory[i].query!,
                                          style: GoogleFonts.outfit(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                  ],
                                  if (recentHistory[i].aiResponse != null &&
                                      recentHistory[i].aiResponse!
                                          .trim()
                                          .isNotEmpty)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24.w,
                                          width: 24.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFB78932),
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Text(
                                            "AI",
                                            style: GoogleFonts.outfit(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            recentHistory[i].aiResponse!,
                                            style: GoogleFonts.outfit(
                                              fontSize: 17.sp,
                                              color: AppColors.heading,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.2,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ] else ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24.w,
                                      width: 24.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB78932),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        "AI",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        welcomeMessage,
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          color: AppColors.heading,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.2,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (pendingQuery != null) ...[
                                SizedBox(height: 12.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 280.w,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFE8D8),
                                      border: Border.all(
                                        color: AppColors.heading,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      pendingQuery!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 24.w,
                                      width: 24.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB78932),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        "AI",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    SizedBox(
                                      height: 14.h,
                                      width: 14.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFB78932),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Thinking...",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        color: const Color.fromRGBO(
                                          42,
                                          41,
                                          51,
                                          0.7,
                                        ),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      key: _inputFieldKey,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            textAlignVertical: TextAlignVertical.center,
                            cursorHeight: 22.h,
                            cursorColor: AppColors.heading,
                            cursorWidth: 1.5.w,
                            enabled: !isSending,
                            textInputAction: TextInputAction.send,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                            onSubmitted: (_) {
                              if (!isSending) {
                                sendMessage();
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Ask about your property...",
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(16, 28, 22, 0.6),
                                letterSpacing: -0.2,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: BorderSide(
                                  color: AppColors.heading,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(16, 28, 22, 0.6),
                                  width: 1.2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 9.w),
                        GestureDetector(
                          onTap: isSending ? null : sendMessage,
                          child: Container(
                            height: 52.h,
                            width: 58.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10201A),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: isSending
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      "What I Can Help With",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Column(
                      children: [
                        propertyOption(
                          icon: Icons.home_outlined,
                          title: "Property details and current property status",
                          onTap: () {
                            messageController.text =
                                "Property details and current property status";
                            _scrollToInputField();
                          },
                        ),
                        propertyOption(
                          icon: Icons.check,
                          title: "Inspection and audit information",
                          onTap: () {
                            messageController.text =
                                "Inspection and audit information";
                            _scrollToInputField();
                          },
                        ),
                        propertyOption(
                          icon: Icons.settings,
                          title: "Maintenance and service request updates",
                          onTap: () {
                            messageController.text =
                                "Maintenance and service request updates";
                            _scrollToInputField();
                          },
                        ),
                        propertyOption(
                          icon: Icons.priority_high,
                          title: "Security and visitor management updates",
                          onTap: () {
                            messageController.text =
                                "Security and visitor management updates";
                            _scrollToInputField();
                          },
                        ),
                        propertyOption(
                          icon: Icons.radio_button_checked,
                          title: "Facility and amenity booking details",
                          onTap: () {
                            messageController.text =
                                "Facility and amenity booking details";
                            _scrollToInputField();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _questionCard({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(16, 28, 22, 0.4),
            width: 1.1,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 18.sp, color: AppColors.heading),
            SizedBox(height: 10.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyOption({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Container(
                  height: 32.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.heading, width: 1.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18.sp, color: AppColors.heading),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(16, 28, 22, 0.15),
          ),
        ],
      ),
    );
  }
}
