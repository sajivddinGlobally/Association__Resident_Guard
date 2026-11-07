import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/maintananceChargesModel.dart';

final maintenanceChargesProvider =
    FutureProvider.autoDispose<MaintananceChargesModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.getMaintananceCharges();
    });
