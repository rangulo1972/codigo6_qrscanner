class QrModel {
  QrModel({
    this.id,
    required this.title,
    required this.observation,
    required this.url,
    required this.datetime,
  });
  int? id; //! para uso en poder visualizar en el
  String title;
  String observation;
  String url;
  String datetime;

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
        id: json["id"],
        title: json["title"] ?? "", //* en caso no exista title se envía vacío
        observation: json["observation"],
        url: json["url"],
        datetime: json["datetime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "observation": observation,
        "url": url,
        "datetime": datetime,
      };
}
