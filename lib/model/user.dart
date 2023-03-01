class User {
  final String displayName;
  final int reputation;
  final String profileImage;
  final String? location;
  final int userID;
  User(
      {required this.displayName,
      required this.reputation,
      required this.profileImage,
      required this.location,
      required this.userID});

  Map<String, dynamic> toJson() => {
        'display_name': displayName,
        'reputation': reputation,
        'profile_image': profileImage,
        'location': location,
        'user_id': userID
      };

  User.fromJson(Map<String, dynamic> json)
      : displayName = json['display_name'],
        reputation = json['reputation'],
        profileImage = json['profile_image'],
        location = json['location'],
        userID = json['user_id'];
}

class UserDetails {
  final String reputationHistoryType;
  final int reputationChange;
  final int creationDate;
  final int postID;
  UserDetails(
      {required this.reputationHistoryType,
      required this.reputationChange,
      required this.creationDate,
      required this.postID});
}
