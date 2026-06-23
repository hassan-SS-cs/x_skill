class PhotosModel {
final String id;
final String url;
final int popularity;
final int visit;
final int page;

PhotosModel({
  required this.id,
  required this.url,
  required this.popularity,
  required this.visit,
  required this.page
});


factory PhotosModel.fromJson(Map<String, dynamic> json){
  return PhotosModel(
      id: json['id'],
      url: json['url'],
      popularity: json['popularity'],
      visit: json['visit'],
      page: json['page']
        );
}

}