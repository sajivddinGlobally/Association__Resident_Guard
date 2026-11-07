import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/maintananceOverviewModel.dart';

final getMaintenanceOverviewProvider =
    FutureProvider.autoDispose<MaintananceOverviewModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.getMaintenanceOverview();
    });
