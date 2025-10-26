import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Models/member_model.dart';
import 'package:gym_admin/Models/member_with_token.dart';
import 'package:gym_admin/Network_managar/api_sarvice.dart';

class DashboardScreenController extends GetxController {
  // Dropdown options
  final List<int> pageSizes = const [25, 50, 100, 500];
  final RxInt selectedPageSize = 25.obs;
  final members = <Member>[].obs;
  final isLoading = false.obs;
  final isCleaning = false.obs;

  final allMembers = <Member>[].obs;
  final visibleMembers = <Member>[].obs;
  final RxInt currentPage = 1.obs;
  // credential dialog controllers
  final credUserC = TextEditingController();
  final credPassC = TextEditingController();
  final expiresDayC = TextEditingController(text: '30');
  // top-level fields
  final tokensByMember = <int, MemberWithToken>{}.obs;
  final ScrollController hCtrl = ScrollController();

  final searchC = TextEditingController();
  final RxString searchQuery = ''.obs;

  // মোট পেজ (members.length ও page size অনুযায়ী)
  int get pageCount {
    final n = selectedPageSize.value;
    if (n <= 0) return 1;
    return (members.length / n).ceil().clamp(1, 1 << 30);
  }

  // পেজ পরিবর্তন
  void goToPage(int page) {
    if (page < 1) page = 1;
    if (page > pageCount) page = pageCount;
    currentPage.value = page;
    _rebuildVisible();
  }

  void nextPage() => goToPage(currentPage.value + 1);
  void prevPage() => goToPage(currentPage.value - 1);

  void changePageSize(int? value) {
    if (value == null) return;
    selectedPageSize.value = value;
    currentPage.value = 1;
    _rebuildVisible();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    debounce<String>(
      searchQuery,
      (_) => _applyFilter(),
      time: const Duration(milliseconds: 300),
    );

    loadMembers();

    loadMemberTokens();
  }

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();

  final List<String> membershipTypes = const ["Premium", "Standard", "Basic"];
  final RxString selectedMembership = "Premium".obs;

  void changeMembership(String? v) {
    if (v == null) return;
    selectedMembership.value = v;
  }

  // যখন সার্চ বক্সে টাইপ করবে
  void onSearchChanged(String v) {
    searchQuery.value = v;
  }

  void _applyFilter() {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) {
      members.assignAll(allMembers);
    } else {
      final filtered =
          allMembers.where((m) {
            final name = (m.name ?? '').toLowerCase();
            final email = (m.email ?? '').toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();
      members.assignAll(filtered);
    }
    currentPage.value = 1;
    _rebuildVisible();
  }

  void _rebuildVisible() {
    final size = selectedPageSize.value;
    final page = currentPage.value;

    if (members.isEmpty) {
      visibleMembers.clear();
      return;
    }

    final start = (page - 1) * size;
    final end = (start + size).clamp(0, members.length);
    final safeStart = start.clamp(0, members.length - 1);
    final safeEnd = end;

    if (safeStart >= safeEnd) {
      currentPage.value = pageCount;
      return _rebuildVisible();
    }

    visibleMembers.assignAll(members.sublist(safeStart, safeEnd));
  }

  Future<void> onContinueAddMember() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final phone = phoneC.text.trim();
    final type = selectedMembership.value;

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar(
        'Required',
        'Name, Email, Phone — Filled All the Fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final res = await ApiService.addMember(
        MemberCreateRequest(
          name: name,
          email: email,
          phone: phone,
          membershipType: type,
        ),
      );

      Get.back();
      Get.snackbar(
        '✅ Success',
        'Member added: $name ($type)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
      loadMembers();

      nameC.clear();
      emailC.clear();
      phoneC.clear();
      selectedMembership.value = "Premium";
    } on Exception catch (e) {
      final msg = e.toString();

      String title = 'Error';
      String message = 'Something went wrong ❌';

      if (msg.contains('400')) {
        message = 'Bad Request: This email already exists.';
      } else if (msg.contains('401')) {
        message = 'Unauthorized: Please log in again.';
      } else if (msg.contains('403')) {
        message =
            'Forbidden: You do not have permission to perform this action.';
      } else if (msg.contains('404')) {
        message = 'Not Found: The requested resource could not be found.';
      } else if (msg.contains('500')) {
        message = 'Server Error: Please try again later.';
      } else if (msg.contains('timeout')) {
        message =
            'Connection Timeout: Please check your network and try again.';
      } else {
        message = msg.replaceAll('Exception: ', '');
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Unexpected Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadMembers() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getMembers();
      // members.assignAll(data);
      allMembers.assignAll(data);
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openCredentialDialog(BuildContext ctx, Member m) {
    credUserC.clear();
    credPassC.clear();

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 90.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 227, 227),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add Credential • ${m.name}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 4.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // username
                    TextField(
                      controller: credUserC,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.r),
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // password
                    TextField(
                      controller: credPassC,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.r),
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // save
                    SizedBox(
                      width: double.infinity,
                      height: 36.h,
                      child: ElevatedButton(
                        onPressed: () => _submitCredentials(m.id ?? 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 3.5.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _submitCredentials(int memberId) async {
    final u = credUserC.text.trim();
    final p = credPassC.text.trim();

    if (u.isEmpty || p.isEmpty) {
      Get.snackbar(
        'Required',
        'Username & Password are required.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final res = await ApiService.setMemberCredentials(
        memberId: memberId,
        username: u,
        password: p,
      );

      Get.back(); // close dialog
      Get.snackbar(
        res.success ? 'Success' : 'Info',
        res.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: res.success ? Colors.green.shade600 : Colors.orange,
        colorText: Colors.white,
      );
      loadMemberTokens();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  // ===== Generate Token flow =====
  void openTokenInputDialog(Member m) {
    expiresDayC.text = '30';
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 227, 227),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Generate Token • ${m.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 4.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: expiresDayC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Expire (days)',
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.r),
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 36.h,
                      child: ElevatedButton(
                        onPressed: () => _submitGenerateToken(m.id ?? 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Generate',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 3.5.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _submitGenerateToken(int memberId) async {
    final d = int.tryParse(expiresDayC.text.trim());
    if (d == null || d <= 0) {
      Get.snackbar(
        'Required',
        'Please enter a valid expire days (e.g. 30).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final res = await ApiService.generateMemberToken(
        memberId: memberId,
        expiresInDays: d,
      );
      Get.back(); // close input dialog
      loadMemberTokens();
      _showTokenDialog(res.token);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  void _showTokenDialog(String token) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 227, 227),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Token Generated',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 4.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SelectableText(
                        token,
                        style: TextStyle(fontSize: 3.5.sp),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: token),
                                );
                                Get.back();
                                Get.snackbar(
                                  'Copied',
                                  'Token copied to clipboard.',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green.shade600,
                                  colorText: Colors.white,
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toggleMemberStatus(Member m) async {
    final bool isActive = (m.status ?? '').toLowerCase() == 'active';
    final newStatus = isActive ? 'Suspended' : 'Active';

    // ⚠️ Confirmation Dialog
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 230, 227, 227),
        title: Text(
          isActive ? 'Suspend Member' : 'Activate Member',
          style: TextStyle(
            color: Colors.black,
            fontSize: 5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          isActive
              ? 'Are you sure you want to suspend ${m.name}?'
              : 'Are you sure you want to activate ${m.name}?',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 3.5.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w400,
                fontSize: 3.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              isActive ? 'Suspend' : 'Activate',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 4.sp,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final updated = await ApiService.updateMember(
        m.id ?? 0,
        status: newStatus,
      );

      Get.snackbar(
        '✅ Success',
        'Member "${updated.name}" is now ${updated.status}.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
      final idx = allMembers.indexWhere((x) => x.id == m.id);
      if (idx != -1) allMembers[idx] = updated;
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadMemberTokens() async {
    try {
      final list = await ApiService.getMembersWithTokens();
      // member_id -> MemberWithToken ম্যাপ বানাও
      final map = <int, MemberWithToken>{};
      for (final t in list) {
        map[t.memberId] = t;
      }
      tokensByMember.assignAll(map);
      _rebuildVisible();
    } catch (e) {
      Get.snackbar(
        'Token Load Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  Future<void> confirmAndDelete(Member m) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 230, 227, 227),
        title: Text(
          'Delete Member',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 5.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${m.name}" (ID: ${m.id})?',
          style: TextStyle(color: Colors.black, fontSize: 3.5.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontSize: 3.5.sp),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontSize: 4.sp),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final res = await ApiService.deleteMember(m.id ?? 0);

      allMembers.removeWhere((x) => x.id == m.id);
      _applyFilter();

      Get.snackbar(
        'Deleted',
        res.message.isNotEmpty ? res.message : 'Member deleted successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Delete failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  Future<void> confirmAndCleanupTokens() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color.fromARGB(255, 230, 227, 227),
        title: Text(
          'Remove expired tokens?',
          style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to remove all expired tokens?',
          style: TextStyle(fontSize: 3.5.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 3.5.sp),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Confirm',
              style: TextStyle(color: Colors.black, fontSize: 4.sp),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (ok == true) {
      await runTokensCleanup();
    }
  }

  Future<void> runTokensCleanup() async {
    if (isCleaning.value) return;
    isCleaning.value = true;
    try {
      final res = await ApiService.cleanupExpiredTokens();
      Get.snackbar(
        res.success ? 'Cleanup done' : 'Cleanup info',
        '${res.message} • Removed: ${res.expiredTokensRemoved}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: res.success ? Colors.green.shade600 : Colors.orange,
        colorText: Colors.white,
      );
      await loadMemberTokens();
    } catch (e) {
      Get.snackbar(
        'Cleanup failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isCleaning.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    credUserC.dispose();
    credPassC.dispose();
    expiresDayC.dispose();
    hCtrl.dispose();
    super.onClose();
  }
}
