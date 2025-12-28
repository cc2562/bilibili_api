/// Data models for user module
library;

/// User detailed information (from /x/space/wbi/acc/info)
class UserInfo {
  final int mid;
  final String name;
  final String sex;
  final String face;
  final String sign;
  final int rank;
  final int level;
  final int silence;
  final VipInfo? vip;
  final OfficialInfo? official;
  final String? birthday;
  final LiveRoomInfo? liveRoom;

  UserInfo({
    required this.mid,
    required this.name,
    required this.sex,
    required this.face,
    required this.sign,
    required this.rank,
    required this.level,
    required this.silence,
    this.vip,
    this.official,
    this.birthday,
    this.liveRoom,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      mid: json['mid'] as int,
      name: json['name'] as String,
      sex: json['sex'] as String,
      face: json['face'] as String,
      sign: json['sign'] as String? ?? '',
      rank: json['rank'] as int,
      level: json['level'] as int,
      silence: json['silence'] as int,
      vip: json['vip'] != null
          ? VipInfo.fromJson(json['vip'] as Map<String, dynamic>)
          : null,
      official: json['official'] != null
          ? OfficialInfo.fromJson(json['official'] as Map<String, dynamic>)
          : null,
      birthday: json['birthday'] as String?,
      liveRoom: json['live_room'] != null
          ? LiveRoomInfo.fromJson(json['live_room'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// VIP membership information
class VipInfo {
  final int type;
  final int status;
  final int dueDate;
  final int vipPayType;
  final String nicknameColor;

  VipInfo({
    required this.type,
    required this.status,
    required this.dueDate,
    required this.vipPayType,
    required this.nicknameColor,
  });

  bool get isVip => status == 1;
  bool get isMonthly => type == 1;
  bool get isYearly => type == 2;

  factory VipInfo.fromJson(Map<String, dynamic> json) {
    return VipInfo(
      type: json['type'] as int,
      status: json['status'] as int,
      dueDate: json['due_date'] as int,
      vipPayType: json['vip_pay_type'] as int,
      nicknameColor: json['nickname_color'] as String? ?? '',
    );
  }
}

/// Official verification information
class OfficialInfo {
  final int role;
  final String title;
  final String desc;
  final int type;

  OfficialInfo({
    required this.role,
    required this.title,
    required this.desc,
    required this.type,
  });

  bool get isVerified => type != -1;

  factory OfficialInfo.fromJson(Map<String, dynamic> json) {
    return OfficialInfo(
      role: json['role'] as int,
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      type: json['type'] as int,
    );
  }
}

/// Live room information
class LiveRoomInfo {
  final int roomStatus;
  final int liveStatus;
  final String url;
  final String title;
  final int roomid;

  LiveRoomInfo({
    required this.roomStatus,
    required this.liveStatus,
    required this.url,
    required this.title,
    required this.roomid,
  });

  bool get hasRoom => roomStatus == 1;
  bool get isLiving => liveStatus == 1;

  factory LiveRoomInfo.fromJson(Map<String, dynamic> json) {
    return LiveRoomInfo(
      roomStatus: json['roomStatus'] as int,
      liveStatus: json['liveStatus'] as int,
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      roomid: json['roomid'] as int,
    );
  }
}

/// User card (simplified user info)
class UserCard {
  final String mid;
  final String name;
  final String sex;
  final String face;
  final String sign;
  final int fans;
  final int friend;

  UserCard({
    required this.mid,
    required this.name,
    required this.sex,
    required this.face,
    required this.sign,
    required this.fans,
    required this.friend,
  });

  factory UserCard.fromJson(Map<String, dynamic> json) {
    return UserCard(
      mid: json['mid'] as String,
      name: json['name'] as String,
      sex: json['sex'] as String,
      face: json['face'] as String,
      sign: json['sign'] as String? ?? '',
      fans: json['fans'] as int,
      friend: json['friend'] as int,
    );
  }
}
