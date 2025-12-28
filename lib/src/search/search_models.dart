/// Data models for search module
library;

/// Search result wrapper
class SearchResult {
  final String seid;
  final int page;
  final int pagesize;
  final int numResults;
  final int numPages;
  final List<SearchItem> items;

  SearchResult({
    required this.seid,
    required this.page,
    required this.pagesize,
    required this.numResults,
    required this.numPages,
    required this.items,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      seid: json['seid'] as String,
      page: json['page'] as int,
      pagesize: json['pagesize'] as int,
      numResults: json['numResults'] as int,
      numPages: json['numPages'] as int,
      items: [], // Will be populated by specific implementations
    );
  }
}

/// Generic search item
class SearchItem {
  final String type;
  final String title;
  final String description;

  SearchItem({
    required this.type,
    required this.title,
    required this.description,
  });
}

/// Video search result
class VideoSearchResult extends SearchItem {
  final int aid;
  final String bvid;
  final String author;
  final int mid;
  final String arcurl;
  final String pic;
  final int play;
  final int favorites;
  final int duration;
  final int pubdate;

  VideoSearchResult({
    required this.aid,
    required this.bvid,
    required this.author,
    required this.mid,
    required String title,
    required String description,
    required this.arcurl,
    required this.pic,
    required this.play,
    required this.favorites,
    required this.duration,
    required this.pubdate,
  }) : super(type: 'video', title: title, description: description);

  factory VideoSearchResult.fromJson(Map<String, dynamic> json) {
    // Remove HTML tags from title
    String cleanTitle = json['title'] as String;
    cleanTitle = cleanTitle.replaceAll(RegExp(r'<[^>]*>'), '');

    return VideoSearchResult(
      aid: json['aid'] as int,
      bvid: json['bvid'] as String,
      author: json['author'] as String,
      mid: json['mid'] as int,
      title: cleanTitle,
      description: json['description'] as String? ?? '',
      arcurl: json['arcurl'] as String,
      pic: json['pic'] as String,
      play: json['play'] as int,
      favorites: json['favorites'] as int,
      duration: 0, // Parse duration string if needed
      pubdate: json['pubdate'] as int,
    );
  }
}

/// User search result
class UserSearchResult extends SearchItem {
  final int mid;
  final String uname;
  final String usign;
  final int fans;
  final int videos;
  final String upic;
  final int level;

  UserSearchResult({
    required this.mid,
    required this.uname,
    required this.usign,
    required this.fans,
    required this.videos,
    required this.upic,
    required this.level,
  }) : super(type: 'bili_user', title: uname, description: usign);

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      mid: json['mid'] as int,
      uname: json['uname'] as String,
      usign: json['usign'] as String? ?? '',
      fans: json['fans'] as int,
      videos: json['videos'] as int,
      upic: json['upic'] as String,
      level: json['level'] as int,
    );
  }
}

/// Search type enum
enum SearchType {
  video('video'),
  bangumi('media_bangumi'),
  movie('media_ft'),
  liveRoom('live_room'),
  liveUser('live_user'),
  article('article'),
  topic('topic'),
  user('bili_user'),
  photo('photo');

  final String value;
  const SearchType(this.value);
}

/// Search order enum
enum SearchOrder {
  totalrank('totalrank'), // Default: comprehensive
  click('click'), // Most clicks
  pubdate('pubdate'), // Latest
  dm('dm'), // Most danmaku
  stow('stow'), // Most favorites
  scores('scores'); // Most comments

  final String value;
  const SearchOrder(this.value);
}

/// Search suggestion item
class SearchSuggestion {  final String value;
  final String name; // HTML with highlight tags
  final String term;

  SearchSuggestion({
    required this.value,
    required this.name,
    required this.term,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      value: json['value'] as String,
      name: json['name'] as String,
      term: json['term'] as String? ?? json['value'] as String,
    );
  }

  /// Get plain text without HTML tags
  String get plainText {
    return name.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
