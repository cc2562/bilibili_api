/// User relation models - followers and following
library;

import 'user_models.dart'; // Import VipInfo and OfficialVerify

/// Relation list item
class RelationUser {
  final int mid;
  final int attribute;
  final int? mtime;
  final List<int>? tag;
  final int special;
  final String uname;
  final String face;
  final String sign;
  final bool faceNft;
  final OfficialInfo officialVerify;
  final VipInfo vip;

  RelationUser({
    required this.mid,
    required this.attribute,
    this.mtime,
    this.tag,
    required this.special,
    required this.uname,
    required this.face,
    required this.sign,
    required this.faceNft,
    required this.officialVerify,
    required this.vip,
  });

  factory RelationUser.fromJson(Map<String, dynamic> json) {
    return RelationUser(
      mid: json['mid'] as int,
      attribute: json['attribute'] as int,
      mtime: json['mtime'] as int?,
      tag: json['tag'] != null ? (json['tag'] as List).cast<int>() : null,
      special: json['special'] as int,
      uname: json['uname'] as String,
      face: json['face'] as String,
      sign: json['sign'] as String? ?? '',
      faceNft: (json['face_nft'] as int? ?? 0) == 1,
      officialVerify: OfficialInfo.fromJson(
          json['official_verify'] as Map<String, dynamic>),
      vip: VipInfo.fromJson(json['vip'] as Map<String, dynamic>),
    );
  }

  /// Attribute meanings:
  /// 0: Not following
  /// 2: Following
  /// 6: Mutual following
  /// 128: Blocked
  bool get isFollowing => attribute == 2 || attribute == 6;
  bool get isMutual => attribute == 6;
  bool get isBlocked => attribute == 128;
  bool get isSpecial => special == 1;
}

/// Followers list response
class FollowersList {
  final List<RelationUser> list;
  final String? offset;
  final int total;

  FollowersList({
    required this.list,
    this.offset,
    required this.total,
  });

  factory FollowersList.fromJson(Map<String, dynamic> json) {
    return FollowersList(
      list: (json['list'] as List)
          .map((e) => RelationUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: json['offset'] as String?,
      total: json['total'] as int,
    );
  }
}

/// Following list response
class FollowingsList {
  final List<RelationUser> list;
  final int total;

  FollowingsList({
    required this.list,
    required this.total,
  });

  factory FollowingsList.fromJson(Map<String, dynamic> json) {
    return FollowingsList(
      list: (json['list'] as List)
          .map((e) => RelationUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}
