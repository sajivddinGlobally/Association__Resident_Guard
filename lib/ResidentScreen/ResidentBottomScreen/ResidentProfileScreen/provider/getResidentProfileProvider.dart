
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getResidentProfileModel.dart';
import '../../../../Core/AuthService/AuthServiceProvider.dart';

final getResidentProfileProvider = FutureProvider.autoDispose<GetResidentProfileModel>((
  ref,
) async {
  final service = ref.read(authServiceProvider);
  return await service.getResidentProfileData();
});
