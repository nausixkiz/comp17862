class EventFirebaseModel {
  String? firebaseUuid;
  String? activityName;
  String? location;
  String? dateHeld;
  String? timeOfAttending;
  String? nameOfReporter;
  String? thumpUrl;
  String? report;

  EventFirebaseModel({
    this.firebaseUuid,
    this.activityName,
    this.location,
    this.dateHeld,
    this.timeOfAttending,
    this.nameOfReporter,
    this.thumpUrl,
    this.report,
  });

  EventFirebaseModel.fromJson(Map<String, dynamic> json) {
    firebaseUuid = json["firebaseUuid"];
    activityName = json["activityName"];
    location = json["location"];
    dateHeld = json["dateHeld"];
    timeOfAttending = json["timeOfAttending"];
    nameOfReporter = json["nameOfReporter"];
    thumpUrl = json["thumpUrl"];
    report = json["report"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["firebaseUuid"] = firebaseUuid;
    data["activityName"] = activityName;
    data["location"] = location;
    data["dateHeld"] = dateHeld;
    data["timeOfAttending"] = timeOfAttending;
    data["nameOfReporter"] = nameOfReporter;
    data["thumpUrl"] = thumpUrl;
    data["report"] = report;

    return data;
  }
}
