import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

/// Stayo Assistant - Resident aur Association dono ke liye ek hi chat screen.
///
/// GET  /ai/property-assistant?assistant_mode=...  -> welcome, society / flat, suggested questions,
///                                                    pichhle 24 ghante ki chat (chat_history)
/// POST /ai/property-assistant {query, assistant_mode} -> society ke LIVE data se jawab
/// DELETE /ai/history?type=property_assistant       -> chat clear
class StayoAssistantScreen extends ConsumerStatefulWidget {
  /// "resident" ya "association"
  final String mode;

  const StayoAssistantScreen({super.key, required this.mode});

  @override
  ConsumerState<StayoAssistantScreen> createState() =>
      _StayoAssistantScreenState();
}

class _StayoChatMessage {
  final String id;
  final bool isUser;
  final String text;
  final String time;
  final bool isError;

  const _StayoChatMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.time,
    this.isError = false,
  });
}

class _StayoAssistantScreenState extends ConsumerState<StayoAssistantScreen> {
  static const Color _dark = Color(0xff101C16);
  static const Color _gold = Color(0xffAE8130);
  static const Color _muted = Color(0x99101C16);

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  bool _loading = true;
  String? _loadError;
  bool _sending = false;
  bool _clearing = false;

  Map<String, dynamic> _data = {};
  final List<_StayoChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _load(silent: true); // pehli baar _loading pehle se true hai
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- data

  Map<String, dynamic> get _context {
    final c = _data['context'];
    return c is Map ? Map<String, dynamic>.from(c) : <String, dynamic>{};
  }

  Map<String, dynamic> get _assistant {
    final a = _data['assistant'];
    return a is Map ? Map<String, dynamic>.from(a) : <String, dynamic>{};
  }

  List<String> get _prompts {
    final p = _data['suggested_prompts'];
    if (p is List) {
      return p
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  String _errorText(Object e) {
    if (e is DioException) {
      final d = e.response?.data;
      if (d is Map && d['message'] != null) {
        return d['message'].toString();
      }
      return "Network error. Please check your connection and try again.";
    }
    return "Something went wrong. Please try again.";
  }

  String _clock(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return "${h.toString().padLeft(2, '0')}:$m ${t.hour < 12 ? 'AM' : 'PM'}";
  }

  String _timeFrom(dynamic label, dynamic createdAt) {
    if (label != null && label.toString().trim().isNotEmpty) {
      return label.toString();
    }
    final parsed = DateTime.tryParse(createdAt?.toString() ?? '');
    return parsed == null ? '' : _clock(parsed.toLocal());
  }

  List<_StayoChatMessage> _historyToMessages(Map<String, dynamic> data) {
    final out = <_StayoChatMessage>[];
    final chat = data['chat_history'];
    if (chat is List) {
      for (final raw in chat) {
        if (raw is! Map) continue;
        final h = Map<String, dynamic>.from(raw);
        final time = _timeFrom(h['time_label'], h['created_at']);
        final q = (h['query'] ?? '').toString();
        final a = (h['response'] ?? '').toString();
        if (q.trim().isNotEmpty) {
          out.add(
            _StayoChatMessage(
              id: 'u-${h['id']}',
              isUser: true,
              text: q,
              time: time,
            ),
          );
        }
        if (a.trim().isNotEmpty) {
          out.add(
            _StayoChatMessage(
              id: 'a-${h['id']}',
              isUser: false,
              text: a,
              time: time,
            ),
          );
        }
      }
      return out;
    }
    // Purana backend: recent_history (nayi pehle) -> ulta karo
    final recent = data['recent_history'];
    if (recent is List) {
      for (final raw in recent.reversed) {
        if (raw is! Map) continue;
        final h = Map<String, dynamic>.from(raw);
        final time = _timeFrom(null, h['created_at']);
        final q = (h['query'] ?? '').toString();
        final a = (h['ai_response'] ?? h['response'] ?? '').toString();
        if (q.trim().isNotEmpty) {
          out.add(
            _StayoChatMessage(
              id: 'u-${h['id']}',
              isUser: true,
              text: q,
              time: time,
            ),
          );
        }
        if (a.trim().isNotEmpty) {
          out.add(
            _StayoChatMessage(
              id: 'a-${h['id']}',
              isUser: false,
              text: a,
              time: time,
            ),
          );
        }
      }
    }
    return out;
  }

  /// silent = true: spinner nahi (pehli baar / pull-to-refresh)
  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _loadError = null;
      });
    }
    try {
      final res = await ref
          .read(authServiceProvider)
          .getStayoAssistant(mode: widget.mode);
      final d = res['data'];
      final data = d is Map
          ? Map<String, dynamic>.from(d)
          : <String, dynamic>{};
      if (!mounted) return;
      setState(() {
        _data = data;
        _loadError = null;
        _messages
          ..clear()
          ..addAll(_historyToMessages(data));
        _loading = false;
      });
      _scrollToBottom(jump: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = _errorText(e);
        _loading = false;
      });
    }
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty || _sending || _loading) return;

    FocusScope.of(context).unfocus();
    final stamp = DateTime.now();
    setState(() {
      _input.clear();
      _sending = true;
      _messages.add(
        _StayoChatMessage(
          id: 'user-${stamp.microsecondsSinceEpoch}',
          isUser: true,
          text: text,
          time: _clock(stamp),
        ),
      );
    });
    _scrollToBottom();

    try {
      final res = await ref
          .read(authServiceProvider)
          .askStayoAssistant(mode: widget.mode, query: text);
      final d = res['data'];
      final data = d is Map
          ? Map<String, dynamic>.from(d)
          : <String, dynamic>{};
      final answer = (data['response'] ?? data['ai_response'] ?? '').toString();
      if (!mounted) return;
      setState(() {
        if (data['context'] is Map) {
          _data['context'] = data['context'];
        }
        _messages.add(
          _StayoChatMessage(
            id: data['log_id'] != null
                ? 'a-${data['log_id']}'
                : 'ai-${stamp.microsecondsSinceEpoch}',
            isUser: false,
            text: answer.trim().isNotEmpty
                ? answer
                : (res['message']?.toString() ??
                      "Sorry, I couldn't get an answer right now. Please try again."),
            time: _timeFrom(data['time_label'], data['created_at']),
          ),
        );
        _sending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _StayoChatMessage(
            id: 'err-${stamp.microsecondsSinceEpoch}',
            isUser: false,
            text: _errorText(e),
            time: _clock(DateTime.now()),
            isError: true,
          ),
        );
        _sending = false;
      });
    }
    _scrollToBottom();
  }

  Future<void> _clear() async {
    if (_clearing || _sending || _messages.isEmpty) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Clear chat?",
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        content: Text(
          "Your Stayo Assistant chat history will be removed.",
          style: GoogleFonts.outfit(fontSize: 14.sp, color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel", style: GoogleFonts.outfit(color: _dark)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              "Clear",
              style: GoogleFonts.outfit(
                color: const Color(0xffDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _clearing = true);
    try {
      await ref.read(authServiceProvider).clearStayoAssistantHistory();
      if (!mounted) return;
      setState(() {
        _messages.clear();
        _clearing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _clearing = false);
    }
  }

  void _scrollToBottom({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = _scroll.position.maxScrollExtent;
      if (jump) {
        _scroll.jumpTo(target);
      } else {
        _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final subtitle =
        (_context['subtitle'] ??
                (widget.mode == 'association'
                    ? 'Your society assistant'
                    : 'Your flat & society assistant'))
            .toString();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
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
                child: Icon(Icons.arrow_back, color: _dark, size: 16.sp),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: _dark,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xffD4AF37),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Stayo Assistant",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: const BoxDecoration(
                          color: Color(0xff22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: _muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Clear chat",
            onPressed: (_clearing || _sending || _messages.isEmpty)
                ? null
                : _clear,
            icon: _clearing
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _dark,
                    ),
                  )
                : Icon(
                    Icons.delete_sweep_outlined,
                    color: _messages.isEmpty ? const Color(0x55101C16) : _dark,
                    size: 22.sp,
                  ),
          ),
          SizedBox(width: 6.w),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: _dark))
            : _loadError != null
            ? _errorView()
            : Column(
                children: [
                  Expanded(child: _chatList()),
                  _chips(),
                  _inputBar(),
                ],
              ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: _muted, size: 36.sp),
            SizedBox(height: 12.h),
            Text(
              _loadError ?? "Failed to load Stayo Assistant",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: _dark,
              ),
            ),
            SizedBox(height: 14.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => _load(),
              child: Text(
                "Retry",
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 15.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatList() {
    final itemCount = 1 + _messages.length + (_sending ? 1 : 0);
    return RefreshIndicator(
      color: _dark,
      onRefresh: () => _load(silent: true),
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (i == 0) return _welcomeCard();
          final mi = i - 1;
          if (mi < _messages.length) return _bubble(_messages[mi]);
          return _typingBubble();
        },
      ),
    );
  }

  Widget _welcomeCard() {
    final user = _data['user'] is Map
        ? Map<String, dynamic>.from(_data['user'])
        : <String, dynamic>{};
    final first = (user['name'] ?? '').toString().trim().split(' ').first;
    final welcome = (_assistant['welcome_message'] ?? '').toString();
    final notice = _context['linked'] == false
        ? (_context['notice'] ?? '').toString()
        : '';
    final hours = (_context['history_hours'] ?? 24).toString();

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0x1F101C16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: const Color(0x26AE8130),
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: Icon(Icons.auto_awesome, color: _gold, size: 17.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  first.isNotEmpty ? "Hello, $first" : "Hello",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffECFDF5),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0x6622C55E)),
                ),
                child: Text(
                  "Live data",
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff15803D),
                  ),
                ),
              ),
            ],
          ),
          if (welcome.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              welcome,
              style: GoogleFonts.outfit(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
                color: _muted,
                height: 1.35,
              ),
            ),
          ],
          if (notice.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xffFEF3C7),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0x66F59E0B)),
              ),
              child: Text(
                notice,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffB45309),
                ),
              ),
            ),
          ],
          if (_messages.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              "Showing your chats from the last $hours hours",
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0x66101C16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 28.w,
      height: 28.w,
      margin: EdgeInsets.only(right: 6.w, bottom: 18.h),
      decoration: const BoxDecoration(color: _dark, shape: BoxShape.circle),
      child: Icon(
        Icons.auto_awesome,
        color: const Color(0xffD4AF37),
        size: 13.sp,
      ),
    );
  }

  Widget _bubble(_StayoChatMessage m) {
    final maxW = MediaQuery.of(context).size.width * 0.78;
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxW),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: m.isUser
            ? _dark
            : (m.isError ? const Color(0xffFEF2F2) : Colors.white),
        border: m.isUser
            ? null
            : Border.all(
                color: m.isError
                    ? const Color(0xffFCA5A5)
                    : const Color(0x1A101C16),
              ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
          bottomLeft: Radius.circular(m.isUser ? 14.r : 4.r),
          bottomRight: Radius.circular(m.isUser ? 4.r : 14.r),
        ),
      ),
      child: m.isUser
          ? Text(
              m.text,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.35,
              ),
            )
          : StayoFormattedText(
              text: m.text,
              color: m.isError
                  ? const Color(0xffB91C1C)
                  : const Color(0xd9101C16),
            ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: m.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!m.isUser) _avatar(),
          Flexible(
            child: Column(
              crossAxisAlignment: m.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                bubble,
                if (m.time.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 3.h, left: 4.w, right: 4.w),
                    child: Text(
                      m.time,
                      style: GoogleFonts.outfit(
                        fontSize: 10.5.sp,
                        color: const Color(0x66101C16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typingBubble() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _avatar(),
          Container(
            margin: EdgeInsets.only(bottom: 18.h),
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0x1A101C16)),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _gold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Checking live data...",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chips() {
    final prompts = _prompts;
    if (prompts.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 46.h,
      decoration: const BoxDecoration(
        color: Color(0xB3FFFFFF),
        border: Border(top: BorderSide(color: Color(0x14101C16))),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        itemCount: prompts.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => GestureDetector(
          onTap: _sending ? null : () => _send(prompts[i]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0x66AE8130)),
            ),
            child: Text(
              prompts[i],
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: _sending ? const Color(0x66101C16) : _dark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0x1F101C16))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _input,
              enabled: !_sending,
              minLines: 1,
              maxLines: 4,
              maxLength: 1000,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: GoogleFonts.outfit(fontSize: 14.sp, color: _dark),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                hintText: widget.mode == 'association'
                    ? "Ask about dues, complaints, visitors..."
                    : "Ask about notices, dues, visitors...",
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color(0x73101C16),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 11.h,
                ),
                filled: true,
                fillColor: const Color(0xffFAFAF7),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0x4DAE8130)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0x26AE8130)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: _gold),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _sending ? null : () => _send(),
            child: Container(
              width: 46.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: _sending ? const Color(0x66101C16) : _dark,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: _sending
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Assistant ka jawab: **bold**, "- " bullets, "1. " numbers, "# heading", khaali line = naya paragraph.
class StayoFormattedText extends StatelessWidget {
  final String text;
  final Color color;

  const StayoFormattedText({
    super.key,
    required this.text,
    required this.color,
  });

  static final RegExp _bold = RegExp(r'\*\*([^*]+)\*\*');
  static final RegExp _bullet = RegExp(r'^[-*•]\s+(.*)$');
  static final RegExp _number = RegExp(r'^(\d+)[.)]\s+(.*)$');
  static final RegExp _heading = RegExp(r'^#{1,6}\s+(.*)$');

  List<InlineSpan> _inline(String s, TextStyle base) {
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in _bold.allMatches(s)) {
      if (m.start > last) {
        spans.add(
          TextSpan(text: s.substring(last, m.start).replaceAll('*', '')),
        );
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: base.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xff101C16),
          ),
        ),
      );
      last = m.end;
    }
    if (last < s.length) {
      spans.add(TextSpan(text: s.substring(last).replaceAll('*', '')));
    }
    return spans;
  }

  Widget _rich(String s, TextStyle base) =>
      Text.rich(TextSpan(style: base, children: _inline(s, base)));

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.outfit(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
    );
    final lines = text.replaceAll('\r\n', '\n').split('\n');
    final children = <Widget>[];
    var lastWasBlank = false;

    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) {
        if (children.isNotEmpty && !lastWasBlank) {
          children.add(SizedBox(height: 6.h));
        }
        lastWasBlank = true;
        continue;
      }
      lastWasBlank = false;

      final h = _heading.firstMatch(line);
      final b = _bullet.firstMatch(line);
      final n = _number.firstMatch(line);
      if (h != null) {
        children.add(_rich('**${h.group(1)}**', base));
      } else if (b != null || n != null) {
        final marker = b != null ? '•' : '${n!.group(1)}.';
        final body = b != null ? b.group(1)! : n!.group(2)!;
        children.add(
          Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16.w,
                  child: Text(
                    marker,
                    style: base.copyWith(
                      color: const Color(0xffAE8130),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(child: _rich(body, base)),
              ],
            ),
          ),
        );
      } else {
        children.add(_rich(line, base));
      }
    }

    if (children.isEmpty) {
      return Text('-', style: base);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
