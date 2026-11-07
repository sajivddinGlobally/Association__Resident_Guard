import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/ResidentCommunityContactResModel.dart';

final residentCommunityContactProvider  =
    FutureProvider.autoDispose<ResidentCommunityContactResModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.residentCommunityContact();
    });