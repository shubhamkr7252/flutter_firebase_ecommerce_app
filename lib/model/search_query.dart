import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'search_query.g.dart';

@HiveType(typeId: 1)
class SearchQueryModel {
  @HiveField(0)
  String? queryText;
}
