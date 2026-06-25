import 'comment_model.dart';

class VideoModel {
  final String id;
  final String title;
  final String url;
  final String duration;
final List<CommentModel> comments;
  VideoModel({
    required this.id,
    required this.title,
    required this.url,
    required this.duration,
    required this.comments,
  });

  factory VideoModel.fromJson(Map<String , dynamic> json){
    return VideoModel
    ( 
      id: json['id'],
      title: json['title'],
      url: json['url'],
      duration: json['duration'],
      comments: (json['comments'] as List)
          .map((c) => CommentModel.fromJson(c))
          .toList(),
      );
  }
}