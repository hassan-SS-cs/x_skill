class CommentModel {
final String ip;
final String content;

CommentModel({
required this.ip,
required this.content
});

factory CommentModel.fromJson(Map<String, dynamic>json){
  return CommentModel(
    ip: json['ip'],
    content: json['content']
    );
}
}