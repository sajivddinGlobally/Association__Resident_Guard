import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/residentDashboardModel.dart';

final residentDashboardProvider =
    FutureProvider.autoDispose<ResidentDashbordModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.getResidentDashboardData();
    });
