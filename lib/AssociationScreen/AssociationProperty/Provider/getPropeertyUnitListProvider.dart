import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitListModel.dart';

final getPropertyUnitListProvider = FutureProvider.autoDispose
    .family<
      GetPropertyUnitListModel,
      ({String status, String block, String search})
    >((ref, params) async {
      final service = ref.read(authServiceProvider);
      return await service.getPropertyUnitList(
        status: params.status,
        block: params.block,
        search: params.search,
      );
    });

final committeeUnitsListProvider = FutureProvider.autoDispose<GetPropertyUnitListModel>((ref) async {
  final service = ref.read(authServiceProvider);
  return await service.getPropertyUnitList();
});

