import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getResidentDetailsModel.dart';

final getResidentDetailsProvider = FutureProvider.family
    .autoDispose<GetResidentDetailsModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getResidentDetails(id: id);
    });
