class ApiEndPoints {
  //base url staging
  static String baseAPIUrl = "https://pmjv.wbhealth.gov.in";
  // auth
  static final String authEndPoint = "$baseAPIUrl/m/auth/login";
  static final String verifyOTPEndPoint = "$baseAPIUrl/m/auth/verify-otp";
  static final String masterAPIEndPoint = "$baseAPIUrl/m/beneficiary/beneficiary-data-pull?pageNumber=1&pageSize=500";

  static final String requestCountEndPoint =
      "$baseAPIUrl/pgr-services/v2/request/_count";
  static final String sendOtpEndPoint = '$baseAPIUrl/user-otp/v1/_send';
  static final String validateOtpEndPoint = '$baseAPIUrl/user/otp/validate';
  static final String createUserEndPoint =
      '$baseAPIUrl/user/users/_createnovalidate';
  static final String mdmsEndPoint = '$baseAPIUrl/mdms-v2/v1/_search';
}
