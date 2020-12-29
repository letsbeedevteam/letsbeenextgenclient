class RiderLocationResponse {
  RiderLocationResponse({
    this.status,
    this.data
  });
  
  int status;
  RiderLocationData data;


  factory RiderLocationResponse.fromJson(Map<String, dynamic> json) => RiderLocationResponse(
    status: json['status'],
    data: RiderLocationData.fromJson(json['data'])
  );
}

class RiderLocationData {
  RiderLocationData({
    this.location
  });

  Location location;

  factory RiderLocationData.fromJson(Map<String, dynamic> json) => RiderLocationData(
    location: Location.fromJson(json['location'])
  );
}

class Location {
  Location({
    this.latitude,
    this.longitude
  });
  
  double latitude;
  double longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json['lat'],
    longitude: json['lng']
  );
}