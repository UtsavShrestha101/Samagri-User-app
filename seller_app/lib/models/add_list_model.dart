import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
part 'add_list_model.g.dart';

@HiveType(typeId: 0)
class AddListModel extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<String> itemList;

  AddListModel(this.date, this.itemList);
}
