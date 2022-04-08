import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class EventObjectBoxModel {
  int id = 0;
  String firebaseUuid;
  String activityName;
  String? location;
  String dateHeld;
  String? timeOfAttending;
  String nameOfReporter;

  EventObjectBoxModel({
    required this.firebaseUuid,
    required this.activityName,
    this.location,
    required this.dateHeld,
    required this.timeOfAttending,
    required this.nameOfReporter,
  });
}
