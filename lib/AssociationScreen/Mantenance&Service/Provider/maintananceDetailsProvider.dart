import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/maintananceDetailsModel.dart';

final maintananceDetailsProvider = FutureProvider.family
    .autoDispose<MaintananceDetailsModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getMaintananceDetails(id: id);
    });
