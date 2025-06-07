


class Tamilwords {
  int? ns;
  String? title;
  int? pageid;
  int? size;
  int? wordcount;
  String? snippet;
  String? timestamp;
  bool? selected=true;

  Tamilwords(
      {this.ns,
      this.title,
      this.pageid,
      this.size,
      this.wordcount,
      this.snippet,
      this.timestamp,this.selected});

  Tamilwords.fromJson(Map<String, dynamic> json) {
    ns = json['ns'];
    title = json['title'];
    pageid = json['pageid'];
    size = json['size'];
    wordcount = json['wordcount'];
    snippet = json['snippet'];
    timestamp = json['timestamp'];
    // selected = json['selected'];
      selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ns'] = ns;
    data['title'] = title;
    data['pageid'] = pageid;
    data['size'] = size;
    data['wordcount'] = wordcount;
    data['snippet'] = snippet;
    data['timestamp'] = timestamp;
    data['selected'] = selected;
    return data;
  }
}
