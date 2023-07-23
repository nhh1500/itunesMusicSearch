/// object to hold all mediaType
/// dpend on [wrapperType], it will be inherited by class [album]/[song]/[artist]
/// album = collection
/// song = track
/// artist = artist
abstract class MediaObject {
  ///The name of the object returned by the search request.
  String? wrapperType;
}
