
class Model{
  String title;
  String url;
  String thumbnail;
    String id;

  Model(this.id, this.title,this.url,this.thumbnail);
  
  Model.fromJson(Map<String,dynamic> parseJson){
    title=parseJson['title'];
    url=parseJson['url'];
    thumbnail=parseJson['thumbnailUrl'];
    
  }
}