import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrShareService {
  static Future<void> sharePassWithQr({
    required String passCode,
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String purpose,
  }) async {
    final shareText = "🏠 Visitor Gate Pass\n"
        "Visitor: $visitorName\n"
        "Pass Code: $passCode\n"
        "Date: $visitDate ${visitTime.isNotEmpty ? 'at $visitTime' : ''}\n"
        "Purpose: $purpose\n\n"
        "Please show this QR code or pass code to the security guard at the gate for fast entry.";

    try {
      final qrValidationResult = QrValidator.validate(
        data: passCode,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      if (qrValidationResult.status == QrValidationStatus.valid &&
          qrValidationResult.qrCode != null) {
        final qrPainter = QrPainter.withQr(
          qr: qrValidationResult.qrCode!,
          gapless: false,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Color(0xFF101C16),
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: Color(0xFF101C16),
          ),
        );

        const double cardWidth = 600.0;
        const double cardHeight = 740.0;
        const double qrSize = 400.0;

        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);

        // 1. Draw solid white background
        final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
        canvas.drawRect(
          const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
          bgPaint,
        );

        // 2. Draw outer subtle border
        final borderPaint = Paint()
          ..color = const Color(0xFFE5E0D5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(16, 16, cardWidth - 32, cardHeight - 32),
            const Radius.circular(24),
          ),
          borderPaint,
        );

        // 3. Header text: "VISITOR GATE PASS"
        final titlePainter = TextPainter(
          text: const TextSpan(
            text: "VISITOR GATE PASS",
            style: TextStyle(
              color: Color(0xFF101C16),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: cardWidth);
        titlePainter.paint(
          canvas,
          Offset((cardWidth - titlePainter.width) / 2, 40),
        );

        // 4. Subtitle: "Scan at gate for instant verification"
        final subtitlePainter = TextPainter(
          text: const TextSpan(
            text: "Show this QR code to guard at the gate",
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: cardWidth);
        subtitlePainter.paint(
          canvas,
          Offset((cardWidth - subtitlePainter.width) / 2, 75),
        );

        // 5. White container for QR Code
        final qrContainerPaint = Paint()..color = const Color(0xFFFFFFFF);
        final qrContainerRect = RRect.fromRectAndRadius(
          const Rect.fromLTWH(
            (cardWidth - qrSize) / 2 - 10,
            110,
            qrSize + 20,
            qrSize + 20,
          ),
          const Radius.circular(16),
        );
        canvas.drawRRect(qrContainerRect, qrContainerPaint);

        // 6. Paint QR code
        canvas.save();
        canvas.translate((cardWidth - qrSize) / 2, 120);
        qrPainter.paint(canvas, const Size(qrSize, qrSize));
        canvas.restore();

        // 7. Draw Pass Code Pill Box
        const pillWidth = 440.0;
        const pillHeight = 56.0;
        const pillX = (cardWidth - pillWidth) / 2;
        const pillY = 560.0;

        final pillPaint = Paint()..color = const Color(0xFF101C16);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(pillX, pillY, pillWidth, pillHeight),
            const Radius.circular(14),
          ),
          pillPaint,
        );

        final codePainter = TextPainter(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "PASS CODE:  ",
                style: TextStyle(
                  color: Color(0xFFD9D9D9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              TextSpan(
                text: passCode,
                style: const TextStyle(
                  color: Color(0xFFE8B900),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: pillWidth);
        codePainter.paint(
          canvas,
          Offset(
            (cardWidth - codePainter.width) / 2,
            pillY + (pillHeight - codePainter.height) / 2,
          ),
        );

        // 8. Visitor name & visit info at bottom
        final infoPainter = TextPainter(
          text: TextSpan(
            text: "Visitor: $visitorName • $visitDate",
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: cardWidth - 60);
        infoPainter.paint(
          canvas,
          Offset((cardWidth - infoPainter.width) / 2, 638),
        );

        // Render to Image & File
        final picture = recorder.endRecording();
        final image = await picture.toImage(
          cardWidth.toInt(),
          cardHeight.toInt(),
        );
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          final tempDir = await getTemporaryDirectory();
          final sanitizedCode =
              passCode.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
          final file = File('${tempDir.path}/visitor_pass_$sanitizedCode.png');
          await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

          final xFile = XFile(
            file.path,
            mimeType: 'image/png',
            name: 'visitor_pass_$sanitizedCode.png',
          );

          await SharePlus.instance.share(
            ShareParams(
              text: shareText,
              subject: "Visitor Gate Pass - $visitorName",
              files: [xFile],
            ),
          );
          return;
        }
      }

      // Fallback to text sharing
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: "Visitor Gate Pass - $visitorName",
        ),
      );
    } catch (e) {
      debugPrint("Error sharing QR code image: $e");
      try {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: "Visitor Gate Pass - $visitorName",
          ),
        );
      } catch (_) {}
    }
  }
}
