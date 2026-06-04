class Beneficiary {
  final int beneficiaryId;
  final String encryptedBeneficiaryId;
  final String pmjayId;
  final String applicantName;
  final String aadhaarNo;
  final String mobileNumber;
  final String gender;
  final String dateOfBirth;
  final String address;
  final String district;
  final String block;
  final String gramPanchayat;
  final String? ward;
  final String rationCardNo;
  final String familyHeadName;
  final int familyMembersCount;
  final String familyId;

  Beneficiary({
    required this.beneficiaryId,
    required this.encryptedBeneficiaryId,
    required this.pmjayId,
    required this.applicantName,
    required this.aadhaarNo,
    required this.mobileNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.district,
    required this.block,
    required this.gramPanchayat,
    this.ward,
    required this.rationCardNo,
    required this.familyHeadName,
    required this.familyMembersCount,
    required this.familyId,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      beneficiaryId: json['beneficiaryId'],
      encryptedBeneficiaryId: json['encryptedBeneficiaryId'] ?? '',
      pmjayId: json['pmjayId'] ?? '',
      applicantName: json['applicantName'] ?? '',
      aadhaarNo: json['aadhaarNo'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      address: json['address'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      gramPanchayat: json['gramPanchayat'] ?? '',
      ward: json['ward'],
      rationCardNo: json['rationCardNo'] ?? '',
      familyHeadName: json['familyHeadName'] ?? '',
      familyMembersCount: json['familyMembersCount'] ?? 0,
      familyId: json['familyId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'beneficiaryId': beneficiaryId,
      'encryptedBeneficiaryId': encryptedBeneficiaryId,
      'pmjayId': pmjayId,
      'applicantName': applicantName,
      'aadhaarNo': aadhaarNo,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'district': district,
      'blockName': block,
      'gramPanchayat': gramPanchayat,
      'ward': ward,
      'rationCardNo': rationCardNo,
      'familyHeadName': familyHeadName,
      'familyMembersCount': familyMembersCount,
      'familyId': familyId,
    };
  }
}