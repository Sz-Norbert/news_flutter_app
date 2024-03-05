class Hits {
  String? author;
  String? createdAt;
  int? createdAtI;
  int? numComments;
  String? objectID;
  int? points;
  int? storyId;
  String? title;
  String? updatedAt;
  String? url;
  String? storyText;
  bool _isFavorite;

  Hits({
    this.author,
    this.createdAt,
    this.createdAtI,
    this.numComments,
    this.objectID,
    this.points,
    this.storyId,
    this.title,
    this.updatedAt,
    this.url,
    this.storyText,
    bool isFavorite = false,
  }) : _isFavorite = isFavorite;

  bool get isFavorite => _isFavorite;

  // Setter pentru isFavorite
  set isFavorite(bool value) {
    _isFavorite = value;
  }

  Hits.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        createdAt = json['created_at'],
        createdAtI = json['created_at_i'],
        numComments = json['num_comments'],
        objectID = json['objectID'],
        points = json['points'],
        storyId = json['story_id'],
        title = json['title'],
        updatedAt = json['updated_at'],
        url = json['url'],
        storyText = json['story_text'],
        _isFavorite = false; // Inițializați _isFavorite cu valoarea implicită false

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['author'] = this.author;
    data['created_at'] = this.createdAt;
    data['created_at_i'] = this.createdAtI;
    data['num_comments'] = this.numComments;
    data['objectID'] = this.objectID;
    data['points'] = this.points;
    data['story_id'] = this.storyId;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['isFavorite'] = this._isFavorite; // Actualizați serializarea cu _isFavorite

    return data;
  }

  static List<Hits> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Hits.fromJson(json)).toList();
  }
}
