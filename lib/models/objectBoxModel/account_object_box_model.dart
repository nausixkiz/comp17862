import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class AccountObjectBoxModel {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
  String firebaseUuid;
  String name;
  @Unique(onConflict: ConflictStrategy.replace)
  String email;
  String password;
  String phone;
  String address;
  String avatarUrl;

  AccountObjectBoxModel({
    required this.firebaseUuid,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });
}
