
import 'dart:convert';

import 'all_list_model.dart';

class MinimalCollectionModel {
  MinimalCollectionModel({

    this.name,
    this.description,
    this.slug,
    this.on_page_visibility,
    required this.listModel

  });

  String? name;
  String? description;
  String? slug;
  String? on_page_visibility;
  PageListModel listModel;

  factory MinimalCollectionModel .fromJson(Map<String, dynamic> json) => MinimalCollectionModel (
    name: json["name"],
    description: json["description"],
    slug: json['slug'],
    on_page_visibility: json['on_page_visibility'],
    listModel: PageListModel.fromJson(json['list']),
  );

}


class PageListModel {
  PageListModel ({
    this.name,
    this.description,
    this.slug,
    this.id
  });

  int? id;
  String? name;
  String? description;
  String? slug;

  factory PageListModel.fromJson(Map<String, dynamic> json) => PageListModel (
    id: json["id"],
    name: json["name"],
    description: json["description"],
    slug: json['slug'],
  );



}