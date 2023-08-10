import 'package:equatable/equatable.dart';

class CharacterListModel extends Equatable {
  late List<RelatedTopics> relatedTopics;

  CharacterListModel({required this.relatedTopics});

  CharacterListModel.fromJson(Map<String, dynamic> json) {
    if (json['RelatedTopics'] != null) {
      relatedTopics = <RelatedTopics>[];
      json['RelatedTopics'].forEach((v) {
        relatedTopics.add(new RelatedTopics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.relatedTopics != null) {
      data['RelatedTopics'] =
          this.relatedTopics.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [];
}

class RelatedTopics extends Equatable {
  late String firstURL;
  late IconData icon;
  late String result;
  late String text;

  RelatedTopics(
      {required this.firstURL,
      required this.icon,
      required this.result,
      required this.text});

  RelatedTopics.fromJson(Map<String, dynamic> json) {
    firstURL = json['FirstURL'];
    icon = (json['Icon'] != null ? new IconData.fromJson(json['Icon']) : null)!;
    result = json['Result'];
    text = json['Text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstURL'] = this.firstURL;
    if (this.icon != null) {
      data['Icon'] = this.icon.toJson();
    }
    data['Result'] = this.result;
    data['Text'] = this.text;
    return data;
  }

  @override
  List<Object?> get props => [];
}

class IconData extends Equatable {
  late String height;
  late String uRL;
  late String width;

  IconData({required this.height, required this.uRL, required this.width});

  IconData.fromJson(Map<String, dynamic> json) {
    height = json['Height'];
    uRL = json['URL'];
    width = json['Width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Height'] = this.height;
    data['URL'] = this.uRL;
    data['Width'] = this.width;
    return data;
  }

  @override
  List<Object?> get props => [];
}
