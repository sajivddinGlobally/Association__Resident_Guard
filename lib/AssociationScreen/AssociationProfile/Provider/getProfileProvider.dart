import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getProfileModel.dart';

final getProfileProvider = FutureProvider.autoDispose<GetProfileModel>((
  ref,
) async {
  final service = ref.read(authServiceProvider);
  return await service.getProfileData();
});
