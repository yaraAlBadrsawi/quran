class QuranData {
  int id;
  String aya_text;
  String aya_text_emlaey;
  String sura_name_ar;
  int page;
  int jozz;
  int aya_no;

  QuranData({
    required this.id,
    required this.sura_name_ar,
    required this.aya_text,
    required this.aya_text_emlaey,
    required this.page,
    required this.jozz,
    required this.aya_no,
  });

  factory QuranData.fromMap(Map<String, dynamic> json) =>
      QuranData(
        id: json["id"],
        aya_text: json["aya_text"],
        aya_text_emlaey: json["aya_text_emlaey"],
        sura_name_ar: json["sura_name_ar"],
        page: json["page"],
        jozz: json["jozz"],
        aya_no: json['aya_no'],
      );

}
