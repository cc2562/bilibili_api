/// Extended video models for video stream and download
library;

/// Video stream URL response
class VideoStreamUrl {
  final int quality;
  final String format;
  final int timelength;
  final List<int> acceptQuality;
  final List<String> acceptDescription;
  final int videoCodecid;
  final List<VideoUrl>? durl; // For MP4/FLV format
  final DashInfo? dash; // For DASH format

  VideoStreamUrl({
    required this.quality,
    required this.format,
    required this.timelength,
    required this.acceptQuality,
    required this.acceptDescription,
    required this.videoCodecid,
    this.durl,
    this.dash,
  });

  bool get isDash => dash != null;
  bool get isMp4 => durl != null;

  factory VideoStreamUrl.fromJson(Map<String, dynamic> json) {
    return VideoStreamUrl(
      quality: json['quality'] as int,
      format: json['format'] as String,
      timelength: json['timelength'] as int,
      acceptQuality: (json['accept_quality'] as List).cast<int>(),
      acceptDescription: (json['accept_description'] as List).cast<String>(),
      videoCodecid: json['video_codecid'] as int,
      durl: json['durl'] != null
          ? (json['durl'] as List)
              .map((e) => VideoUrl.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      dash: json['dash'] != null
          ? DashInfo.fromJson(json['dash'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Video URL segment (for MP4/FLV)
class VideoUrl {
  final int order;
  final int length;
  final int size;
  final String url;
  final List<String>? backupUrl;

  VideoUrl({
    required this.order,
    required this.length,
    required this.size,
    required this.url,
    this.backupUrl,
  });

  factory VideoUrl.fromJson(Map<String, dynamic> json) {
    return VideoUrl(
      order: json['order'] as int,
      length: json['length'] as int,
      size: json['size'] as int,
      url: json['url'] as String,
      backupUrl: json['backup_url'] != null
          ? (json['backup_url'] as List).cast<String>()
          : null,
    );
  }
}

/// DASH format stream info
class DashInfo {
  final int duration;
  final List<DashStream> video;
  final List<DashStream>? audio;

  DashInfo({
    required this.duration,
    required this.video,
    this.audio,
  });

  factory DashInfo.fromJson(Map<String, dynamic> json) {
    return DashInfo(
      duration: json['duration'] as int,
      video: (json['video'] as List)
          .map((e) => DashStream.fromJson(e as Map<String, dynamic>))
          .toList(),
      audio: json['audio'] != null
          ? (json['audio'] as List)
              .map((e) => DashStream.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

/// DASH stream (video or audio)
class DashStream {
  final int id;
  final String baseUrl;
  final List<String>? backupUrl;
  final int bandwidth;
  final String mimeType;
  final String codecs;
  final int? width;
  final int? height;
  final String? frameRate;
  final int codecid;

  DashStream({
    required this.id,
    required this.baseUrl,
    this.backupUrl,
    required this.bandwidth,
    required this.mimeType,
    required this.codecs,
    this.width,
    this.height,
    this.frameRate,
    required this.codecid,
  });

  factory DashStream.fromJson(Map<String, dynamic> json) {
    return DashStream(
      id: json['id'] as int,
      baseUrl: json['baseUrl'] as String? ?? json['base_url'] as String,
      backupUrl: json['backupUrl'] != null
          ? (json['backupUrl'] as List).cast<String>()
          : json['backup_url'] != null
              ? (json['backup_url'] as List).cast<String>()
              : null,
      bandwidth: json['bandwidth'] as int,
      mimeType: json['mimeType'] as String? ?? json['mime_type'] as String,
      codecs: json['codecs'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      frameRate: json['frameRate'] as String? ?? json['frame_rate'] as String?,
      codecid: json['codecid'] as int,
    );
  }
}
