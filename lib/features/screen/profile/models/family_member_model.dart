class FamilyMemberModel {
  final String name;
  final String mobile;
  final String relation; // SPOUSE/CHILD/PARENT/OTHER
  final String? email;
  final String? photoUrl;
  final String? familyMemberId;
  final String? residentId;
  final String? societyId;
  final String? buildingId;

  const FamilyMemberModel({
    required this.name,
    required this.mobile,
    required this.relation,
    this.email,
    this.photoUrl,
    this.familyMemberId,
    this.residentId,
    this.societyId,
    this.buildingId,
  });

  Map<String, dynamic> toJson() => {
    'name':     name,
    'mobile':   mobile,
    'relation': relation,
    'email':    email,
    'photoUrl': photoUrl,
    'familyMemberId': familyMemberId,
    'residentId': residentId,
    'societyId': societyId,
    'buildingId': buildingId,
  };

  static FamilyMemberModel fromJson(Map<String, dynamic> map) {
    return FamilyMemberModel(
      name:     map['name'],
      mobile:   map['mobile'],
      relation: map['relation'],
      email:    map['email'],
      photoUrl: map['photoUrl'],
      familyMemberId: map['familyMemberId'],
      residentId:     map['residentId'],
      societyId:      map['societyId'],
      buildingId:     map['buildingId']);

  }
}

