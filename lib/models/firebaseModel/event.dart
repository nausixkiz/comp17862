

class Event {
  String? firebaseUuid;
  String? activityName;
  String? location;
  String? dateHeld;
  String? timeOfAttending;
  String? nameOfReporter;

  Event({
    this.firebaseUuid,
    this.activityName,
    this.location,
    this.dateHeld,
    this.timeOfAttending,
    this.nameOfReporter,
  });

  Event.fromJson(Map<String, dynamic> json) {
    firebaseUuid = json["firebaseUuid"];
    activityName = json["activityName"];
    location = json["location"];
    dateHeld = json["dateHeld"];
    timeOfAttending = json["timeOfAttending"];
    nameOfReporter = json["nameOfReporter"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["firebaseUuid"] = firebaseUuid;
    data["activityName"] = activityName;
    data["location"] = location;
    data["dateHeld"] = dateHeld;
    data["timeOfAttending"] = timeOfAttending;
    data["nameOfReporter"] = nameOfReporter;

    return data;
  }
}
