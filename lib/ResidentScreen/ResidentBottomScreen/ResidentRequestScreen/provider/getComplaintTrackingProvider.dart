import 'package:property_association_or_resident/ResidentScreen/Model/getComplaintTrackingModel.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:riverpod/riverpod.dart';

final getComplaintTrackingProvider = FutureProvider.family
    .autoDispose<GetComplaintTrackingModel, String>((ref, id) async {
      final srvice = ref.read(authServiceProvider);
      return await srvice.getComplaintTracking(id: id);
    });
