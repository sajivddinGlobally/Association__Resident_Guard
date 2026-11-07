import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/maintenanceChargeStatusModel.dart';

final maintenanceChargeStatusProvider = FutureProvider.family
    .autoDispose<MaintananceChargeStatusModel, String>((ref, tab) async {
      final service = ref.read(authServiceProvider);
      return await service.maintenanceChargeStatus(tab: tab);
    });
