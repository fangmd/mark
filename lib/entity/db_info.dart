class DBInfoEntity {
  int id;
  int version;

  DBInfoEntity({this.version});

  Map<String, dynamic> toMapDB() {
    var map = <String, dynamic>{
      'id': id,
      'version': version,
    };
    return map;
  }

  DBInfoEntity.fromMapDB(Map<String, dynamic> map) {
    id = map["id"];
    version = map["version"];
  }
}
