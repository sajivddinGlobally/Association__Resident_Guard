import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/getPropertyUnitDetailsModel.dart'
    show GetPropertyUnitDetailsModel;

final getPropertyUnitDetailsProvider = FutureProvider.family
    .autoDispose<GetPropertyUnitDetailsModel, String>((ref, unitID) async {
      final service = ref.read(authServiceProvider);
      return await service.getPropertyUnitDetails(id: unitID);
    });
