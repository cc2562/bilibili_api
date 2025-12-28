/// Data models for video module
library;

/// Video detailed information
class VideoInfo {
  final String bvid;
  final int aid;
  final int videos;
  final int tid;
  final String tname;
  final int copyright;
  final String pic;
  final String title;
  final int pubdate;
  final String desc;
  final int duration;
  final VideoOwner owner;
  final VideoStat stat;
  final List<VideoPage> pages;

  VideoInfo({
    required this.bvid,
    required this.aid,
    required this.videos,
    required this.tid,
    required this.tname,
    required this.copyright,
    required this.pic,
    required this.title,
    required this.pubdate,
    required this.desc,
    required this.duration,
    required this.owner,
    required this.stat,
    required this.pages,
  });

  bool get isOriginal => copyright == 1;

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      bvid: json['bvid'] as String,
      aid: json['aid'] as int,
      videos: json['videos'] as int,
      tid: json['tid'] as int,
      tname: json['tname'] as String,
      copyright: json['copyright'] as int,
      pic: json['pic'] as String,
      title: json['title'] as String,
      pubdate: json['pubdate'] as int,
      desc: json['desc'] as String? ?? '',
      duration: json['duration'] as int,
      owner: VideoOwner.fromJson(json['owner'] as Map<String, dynamic>),
      stat: VideoStat.fromJson(json['stat'] as Map<String, dynamic>),
      pages: (json['pages'] as List?)
              ?.map((e) => VideoPage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Video owner (UP主) information
class VideoOwner {
  final int mid;
  final String name;
  final String face;

  VideoOwner({
    required this.mid,
    required this.name,
    required this.face,
  });

  factory VideoOwner.fromJson(Map<String, dynamic> json) {
    return VideoOwner(
      mid: json['mid'] as int,
      name: json['name'] as String,
      face: json['face'] as String,
    );
  }
}

/// Video statistics
class VideoStat {
  final int aid;
  final int view;
  final int danmaku;
  final int reply;
  final int favorite;
  final int coin;
  final int share;
  final int like;

  VideoStat({
    required this.aid,
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.favorite,
    required this.coin,
    required this.share,
    required this.like,
  });

  factory VideoStat.fromJson(Map<String, dynamic> json) {
    return VideoStat(
      aid: json['aid'] as int,
      view: json['view'] as int,
      danmaku: json['danmaku'] as int,
      reply: json['reply'] as int,
      favorite: json['favorite'] as int,
      coin: json['coin'] as int,
      share: json['share'] as int,
      like: json['like'] as int,
    );
  }
}

/// Video page (分P) information
class VideoPage {
  final int cid;
  final int page;
  final String from;
  final String part;
  final int duration;
  final VideoDimension? dimension;

  VideoPage({
    required this.cid,
    required this.page,
    required this.from,
    required this.part,
    required this.duration,
    this.dimension,
  });

  factory VideoPage.fromJson(Map<String, dynamic> json) {
    return VideoPage(
      cid: json['cid'] as int,
      page: json['page'] as int,
      from: json['from'] as String,
      part: json['part'] as String,
      duration: json['duration'] as int,
      dimension: json['dimension'] != null
          ? VideoDimension.fromJson(json['dimension'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Video dimension (resolution)
class VideoDimension {
  final int width;
  final int height;
  final int rotate;

  VideoDimension({
    required this.width,
    required this.height,
    required this.rotate,
  });

  factory VideoDimension.fromJson(Map<String, dynamic> json) {
    return VideoDimension(
      width: json['width'] as int,
      height: json['height'] as int,
      rotate: json['rotate'] as int,
    );
  }
}
