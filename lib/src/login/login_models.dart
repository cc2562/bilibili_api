/// Data models for login module
library;

/// QR code generation response data
class QRCodeData {
  final String url;
  final String qrcodeKey;

  QRCodeData({
    required this.url,
    required this.qrcodeKey,
  });

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      url: json['url'] as String,
      qrcodeKey: json['qrcode_key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'qrcode_key': qrcodeKey,
    };
  }
}

/// QR code poll status
enum QRPollStatus {
  notScanned(86101, '未扫码'),
  scanned(86090, '已扫码未确认'),
  expired(86038, '二维码已失效'),
  success(0, '登录成功');

  final int code;
  final String message;

  const QRPollStatus(this.code, this.message);

  static QRPollStatus fromCode(int code) {
    return QRPollStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => QRPollStatus.expired,
    );
  }
}

/// QR code poll response data
class QRPollData {
  final String url;
  final String refreshToken;
  final int timestamp;
  final int code;
  final String message;

  QRPollData({
    required this.url,
    required this.refreshToken,
    required this.timestamp,
    required this.code,
    required this.message,
  });

  QRPollStatus get status => QRPollStatus.fromCode(code);

  bool get isSuccess => status == QRPollStatus.success;

  factory QRPollData.fromJson(Map<String, dynamic> json) {
    return QRPollData(
      url: json['url'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      timestamp: json['timestamp'] as int? ?? 0,
      code: json['code'] as int,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'refresh_token': refreshToken,
      'timestamp': timestamp,
      'code': code,
      'message': message,
    };
  }
}

/// Navigation bar user info (wbi_img included)
class NavInfo {
  final bool isLogin;
  final int? emailVerified;
  final String? face;
  final LevelInfo? levelInfo;
  final int? mid;
  final int? mobileVerified;
  final double? money;
  final int? moral;
  final String? uname;
  final int? vipDueDate;
  final int? vipStatus;
  final int? vipType;
  final WbiImg? wbiImg;
  final bool? isJury;

  NavInfo({
    required this.isLogin,
    this.emailVerified,
    this.face,
    this.levelInfo,
    this.mid,
    this.mobileVerified,
    this.money,
    this.moral,
    this.uname,
    this.vipDueDate,
    this.vipStatus,
    this.vipType,
    this.wbiImg,
    this.isJury,
  });

  factory NavInfo.fromJson(Map<String, dynamic> json) {
    return NavInfo(
      isLogin: json['isLogin'] as bool,
      emailVerified: json['email_verified'] as int?,
      face: json['face'] as String?,
      levelInfo: json['level_info'] != null
          ? LevelInfo.fromJson(json['level_info'] as Map<String, dynamic>)
          : null,
      mid: json['mid'] as int?,
      mobileVerified: json['mobile_verified'] as int?,
      money: (json['money'] as num?)?.toDouble(),
      moral: json['moral'] as int?,
      uname: json['uname'] as String?,
      vipDueDate: json['vipDueDate'] as int?,
      vipStatus: json['vipStatus'] as int?,
      vipType: json['vipType'] as int?,
      wbiImg: json['wbi_img'] != null
          ? WbiImg.fromJson(json['wbi_img'] as Map<String, dynamic>)
          : null,
      isJury: json['is_jury'] as bool?,
    );
  }
}

/// User level information
class LevelInfo {
  final int currentLevel;
  final int currentMin;
  final int currentExp;
  final dynamic nextExp; // Can be string "--" or int

  LevelInfo({
    required this.currentLevel,
    required this.currentMin,
    required this.currentExp,
    required this.nextExp,
  });

  factory LevelInfo.fromJson(Map<String, dynamic> json) {
    return LevelInfo(
      currentLevel: json['current_level'] as int,
      currentMin: json['current_min'] as int,
      currentExp: json['current_exp'] as int,
      nextExp: json['next_exp'],
    );
  }
}

/// WBI image URLs for signature
class WbiImg {
  final String imgUrl;
  final String subUrl;

  WbiImg({
    required this.imgUrl,
    required this.subUrl,
  });

  factory WbiImg.fromJson(Map<String, dynamic> json) {
    return WbiImg(
      imgUrl: json['img_url'] as String,
      subUrl: json['sub_url'] as String,
    );
  }
}

/// User navigation statistics
class NavStat {
  final int following;
  final int follower;
  final int dynamicCount;

  NavStat({
    required this.following,
    required this.follower,
    required this.dynamicCount,
  });

  factory NavStat.fromJson(Map<String, dynamic> json) {
    return NavStat(
      following: json['following'] as int,
      follower: json['follower'] as int,
      dynamicCount: json['dynamic_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'following': following,
      'follower': follower,
      'dynamic_count': dynamicCount,
    };
  }
}
