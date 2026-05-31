class FamilyMemberModel {
  final String name;
  final String mobile;
  final String relation; // SPOUSE/CHILD/PARENT/OTHER
  final String? email;

  const FamilyMemberModel({
    required this.name,
    required this.mobile,
    required this.relation,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    'name':     name,
    'mobile':   mobile,
    'relation': relation,
    'email':    email,
  };
}

