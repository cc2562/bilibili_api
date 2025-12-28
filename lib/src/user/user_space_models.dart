/// User space video list API
library;

/// User uploaded videos response
class UserUploadVideos {
  final List<UploadedVideo> videos;
  final Map<int, VideoCategory> categories;
  final PageInfo pageInfo;

  UserUploadVideos({
    required this.videos,
    required this.categories,
    required this.pageInfo,
  });

  factory UserUploadVideos.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as Map<String, dynamic>;
    final vlist = (list['vlist'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final tlist = (list['tlist'] as Map<String, dynamic>?) ?? {};
    final page = json['page'] as Map<String, dynamic>;

    return UserUploadVideos(
      videos: vlist.map((v) => UploadedVideo.fromJson(v)).toList(),
      categories: tlist.map((key, value) => MapEntry(
        int.parse(key),
        VideoCategory.fromJson(value as Map<String, dynamic>),
      )),
      pageInfo: PageInfo.fromJson(page),
    );
  }
}

/// Uploaded video item
class UploadedVideo {
  final int aid;
  final String bvid;
  final String title;
  final String description;
  final String pic;
  final int created;
  final String length;
  final int typeid;
  final String copyright;
  final int play;
  final int comment;
  final int videoReview; // danmaku

  final String author;
  final int mid;

  // Optional fields
  final bool isUnionVideo;
  final bool isSteinsGate;
  final bool isLivePlayback;

  UploadedVideo({
    required this.aid,
    required this.bvid,
    required this.title,
    required this.description,
    required this.pic,
    required this.created,
    required this.length,
    required this.typeid,
    required this.copyright,
    required this.play,
    required this.comment,
    required this.videoReview,
    required this.author,
    required this.mid,
    this.isUnionVideo = false,
    this.isSteinsGate = false,
    this.isLivePlayback = false,
  });

  factory UploadedVideo.fromJson(Map<String, dynamic> json) {
    return UploadedVideo(
      aid: json['aid'] as int,
      bvid: json['bvid'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      pic: json['pic'] as String,
      created: json['created'] as int,
      length: json['length'] as String,
      typeid: json['typeid'] as int,
      copyright: json['copyright'] as String,
      play: json['play'] as int,
      comment: json['comment'] as int,
      videoReview: json['video_review'] as int,
      author: json['author'] as String,
      mid: json['mid'] as int,
      isUnionVideo: (json['is_union_video'] as int?) == 1,
      isSteinsGate: (json['is_steins_gate'] as int?) == 1,
      isLivePlayback: (json['is_live_playback'] as int?) == 1,
    );
  }
}

/// Video category info
class VideoCategory {
  final int tid;
  final String name;
  final int count;

  VideoCategory({
    required this.tid,
    required this.name,
    required this.count,
  });

  factory VideoCategory.fromJson(Map<String, dynamic> json) {
    return VideoCategory(
      tid: json['tid'] as int,
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }
}

/// Page information
class PageInfo {
  final int pn;
  final int ps;
  final int count;

  PageInfo({
    required this.pn,
    required this.ps,
    required this.count,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      pn: json['pn'] as int,
      ps: json['ps'] as int,
      count: json['count'] as int,
    );
  }

  int get totalPages => (count / ps).ceil();
  bool get hasNextPage => pn < totalPages;
}

/// Sort order for user videos
class UserVideoOrder {
  static const String pubdate = 'pubdate'; // Latest published
  static const String click = 'click'; // Most views
  static const String stow = 'stow'; // Most favorites
}
