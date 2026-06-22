class PaginationLinksModel {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinksModel({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory PaginationLinksModel.fromJson(Map<String, dynamic> json) {
    return PaginationLinksModel(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class PaginationMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
