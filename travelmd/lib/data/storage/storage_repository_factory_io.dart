import 'package:travelmd/data/storage/isar_service.dart';
import 'package:travelmd/data/storage/storage_repository.dart';
import 'package:travelmd/data/storage/storage_repository_base.dart';

Future<StorageRepositoryBase> createStorageRepository() async {
  final isar = await IsarService.getInstance();
  return StorageRepository(isar);
}
