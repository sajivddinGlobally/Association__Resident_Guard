import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/complaintStatusResModel.dart';

final compaintStatusProvider = FutureProvider.family
    .autoDispose<ComplaintStatusResModel, String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.getComplaintStatus(id: unitID);
    });
