import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentRequestScreen/provider/getComplaintListProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentRequestScreen/provider/getComplaintTrackingProvider.dart';

/// Resident confirm karta hai ki kaam ho gaya (association/admin ye nahi kar sakte).
/// Dialog (rating + feedback optional) -> POST /resident/complaints/{id}/complete.
/// Success par true return karta hai aur list + tracking refresh ho jaate hain.
Future<bool> showMarkCompletedFlow({
  required BuildContext context,
  required WidgetRef ref,
  required String id,
  String title = "Service Completed?",
}) async {
  final feedbackController = TextEditingController();
  int rating = 0;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setS) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Confirm only if the work is done to your satisfaction."),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setS(() => rating = i + 1),
                  icon: Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            TextField(
              controller: feedbackController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: "Feedback (optional)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Yes, Completed"),
          ),
        ],
      ),
    ),
  );

  final feedback = feedbackController.text;
  feedbackController.dispose();
  if (confirmed != true) return false;

  try {
    final res = await ref
        .read(authServiceProvider)
        .markResidentRequestCompleted(
          id: id,
          rating: rating > 0 ? rating : null,
          feedback: feedback,
        );
    if (res['status'] == true) {
      ref.invalidate(getComplaintTrackingProvider(id));
      ref.invalidate(getComplaintListProvider);
      showSuccessSnackBar((res['message'] ?? "Marked as completed").toString());
      return true;
    }
    showErrorSnackBar((res['message'] ?? "Could not update").toString());
  } catch (e) {
    showErrorSnackBar("Could not update. Please try again.");
  }
  return false;
}
