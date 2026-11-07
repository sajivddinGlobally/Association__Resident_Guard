import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getComplaintDetailsResModel.dart';

final getComplaintDetailsProvider = FutureProvider.family
    .autoDispose<GetComplaintDetailsResModel, String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.getComplaintDetails(id: unitID);
    });
