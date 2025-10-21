class ApiConstants {
  static const String baseUrl = 'http://192.168.10.29:9000/api';
  static const String adminLogin =
      'http://192.168.10.29:9000/api/auth/admin/login';
  static const String addMember = 'http://192.168.10.29:9000/api/members';
  static const String getMembers = '/members?skip=0&limit=1000';
  static const String deleteNember ="/members";
  static const String setPassword = '${baseUrl}/members/';

}
