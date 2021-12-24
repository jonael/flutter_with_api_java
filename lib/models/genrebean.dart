class Genrebean {
  int? _idGenre;
  String? _genreName;

  int? get idGenre => _idGenre;
  String? get genreName => _genreName;

  Genrebean({
    int? idGenre,
    String? genreName}){
    _idGenre = idGenre;
    _genreName = genreName;
  }

  Genrebean.fromJson(dynamic json) {
    _idGenre = json["idGenre"];
    _genreName = json["genreName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["idGenre"] = _idGenre;
    map["genreName"] = _genreName;
    return map;
  }

}