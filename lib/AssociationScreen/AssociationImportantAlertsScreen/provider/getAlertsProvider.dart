import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getAlertModel.dart';

final getAlertsProvider = FutureProvider.family
    .autoDispose<GetAlertModel, String>((ref, filter) async {
      final service = ref.read(authServiceProvider);
      return await service.getAlerts(filter: filter);
    });
