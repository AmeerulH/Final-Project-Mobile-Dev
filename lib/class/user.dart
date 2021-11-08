/// Data Users
class User {
  final String author;
  dynamic posts;

  User({
    required this.author,
    required this.posts,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'posts': posts,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      author: map['author'],
      posts: map['posts'],
    );
  }
}
