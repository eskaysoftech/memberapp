import 'package:hive/hive.dart';
part 'logindetails.g.dart';

@HiveType(typeId: 0)
class Logindetails {
  @HiveField(0)
  late final String username;
  @HiveField(1)
  late final String password;

  Logindetails(this.username, this.password);
}
