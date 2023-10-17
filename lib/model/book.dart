class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  //Book 상세정보
  final String error;
  final String authors;
  // final String publisher;
  // final String isbn10;
  // final String pages;
  // final String year;
  // final String rating;
  // final String desc;
  //final PDF pdf;

  Book({
    required this.title,
    required this.subtitle,
    required this.isbn13,
    required this.price,
    required this.image,
    required this.url,
    
    required this.error,
    required this.authors,
    // required this.publisher,
    // required this.isbn10,
    // required this.pages,
    // required this.year,
    // required this.rating,
    // required this.desc,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      isbn13: json['isbn13'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',

      error: json['error'] ?? '',
      authors: json['authors'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "isbn13": isbn13,
        "price": price,
        "image": image,
        "url": url,
      };
}

class PDF {
  final String chapter;

  PDF({
    required this.chapter,
  });
}


