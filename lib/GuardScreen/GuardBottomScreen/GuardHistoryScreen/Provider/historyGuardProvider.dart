import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyGuardResModel.dart';

final historyGuardProvider =
    FutureProvider.autoDispose<HistoryGuardResModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.historyGuardData();
    });
