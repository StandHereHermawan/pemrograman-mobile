class Credential {
  static const String collectionName = "credentials";
  final String id;
  final String userId;
  final String credential;
  final String createdAt;

  const Credential({
    this.id = "0",
    this.userId = "0",
    this.credential = "Kosong",
    this.createdAt = "kosong",
  });
}