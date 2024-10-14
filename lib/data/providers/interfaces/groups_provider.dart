import 'package:mobi_resize_flutter/models/grupo.dart';

abstract class GroupsProvider {
  Future<List<Grupo>> findAll(String companyId);
  Future<bool> update(String companyId, String id, Map<String, dynamic> data);
  Future<bool> lock(String companyId, String id);
  Future<bool> unlock(String companyId, String id);
  void listen(String companyId,
      {void Function(Grupo grupo)? groupAdded,
      void Function(Grupo grupo)? groupModified,
      void Function(Grupo grupo)? groupoRemoved});
  Future<void> cancel(String companyId);
  Future<void> clear();
}
