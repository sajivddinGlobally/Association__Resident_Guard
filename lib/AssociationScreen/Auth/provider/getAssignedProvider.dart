import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

final getAssignedProvider = FutureProvider.autoDispose((ref) async {
  final service = ref.read(authServiceProvider);
  return await service.getUnassigned();
});
