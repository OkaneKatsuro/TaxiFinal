class Place {
  double long;
  double lat;
  String name;
  String? description;
  String? shortName;

  Place({
    required this.name,
    required this.description,
    required this.lat,
    required this.long,
  });

  factory Place.fromYandexJson(Map<String, dynamic> json) => Place(
        name: json['properties']['name'],
        description: json['properties']['description'],
        lat: json['geometry']['coordinates'][1],
        long: json['geometry']['coordinates'][0],
      );

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        name: json['name'],
        description: json['description'],
        lat: json['lat'],
        long: json['long'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['"name"'] = '"$name"';
    data['"description"'] = '"$description"';
    data['"lat"'] = lat;
    data['"long"'] = long;
    return data;
  }
}
