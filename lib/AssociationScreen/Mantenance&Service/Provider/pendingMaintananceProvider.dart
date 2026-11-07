import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/pendingMaintananceModel.dart';

final pendingMainTananceProvider = FutureProvider.family
    .autoDispose<PendingMaintenanceModel, ({String? priority, String? search})>(
      (ref, params) async {
        final service = ref.read(authServiceProvider);
        return await service.getPendingMaintanance(
          priority: params.priority,
          search: params.search,
        );
      },
    );
