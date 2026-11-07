import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/getFlatApartmentModel.dart';

final getFlatApartmentProvider =
    FutureProvider.autoDispose<GetFlatApartmentModel>((ref) async {
      final serivce = ref.watch(authServiceProvider);
      return await serivce.getFlatApartmentData();
    });
