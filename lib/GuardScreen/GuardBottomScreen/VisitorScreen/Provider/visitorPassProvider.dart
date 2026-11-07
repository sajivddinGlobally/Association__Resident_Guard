import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VisitorPassResModel.dart';

final visitorPassProvider = FutureProvider.family
    .autoDispose<VisitorPassResModel?, String>((ref, visitorId) async {
      final trimmed = visitorId.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      final service = ref.read(authServiceProvider);
      return await service.getVisitorPassDataGuard(trimmed);
    });
