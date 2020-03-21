class Note {
  String maahSom;
  String text;
  String vid;

  Note(this.maahSom, this.text, this.vid);

  Note.fromJson(Map<String, dynamic> json) {
    maahSom = json['maahSom'];
    text = json['text'];
    vid = json['vid'];
  }
}