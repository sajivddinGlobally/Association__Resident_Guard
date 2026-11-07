import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getUnitsModel.dart';

final addResidentProvider = FutureProvider.autoDispose<GetUnitsModel>((
  ref,
) async {
  final service = ref.read(authServiceProvider);
  return await service.getAvailableUnits();
});
