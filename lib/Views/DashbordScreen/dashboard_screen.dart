import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Utils/customdialog.dart';
import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

class DashboardScreen extends GetView<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 227, 227),
        centerTitle: true,
        title: Text(
          "Manage Member",
          style: TextStyle(
            color: Colors.black,
            fontSize: 5.sp,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 251, 255),
                        borderRadius: BorderRadius.circular(7.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "National Gym",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    "Showing: ${controller.visibleMembers.length} / ${controller.members.length} • Total Members: ${controller.allMembers.length}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 3.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Spacer(),

                                Text(
                                  "|  View :  ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Obx(
                                  () => DropdownButton<int>(
                                    value: controller.selectedPageSize.value,
                                    items:
                                        controller.pageSizes
                                            .map(
                                              (e) => DropdownMenuItem<int>(
                                                value: e,
                                                child: Text(
                                                  '$e',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: controller.changePageSize,
                                    // isDense: true,
                                    borderRadius: BorderRadius.circular(8.r),
                                    underline: const SizedBox.shrink(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 6.sp,
                                    ),
                                    menuMaxHeight: 170.h,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Obx(
                              () => ElevatedButton.icon(
                                onPressed:
                                    controller.isCleaning.value
                                        ? null
                                        : () async =>
                                            controller
                                                .confirmAndCleanupTokens(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.isCleaning.value
                                          ? Colors.grey
                                          : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                icon:
                                    controller.isCleaning.value
                                        ? SizedBox(
                                          width: 5.sp,
                                          height: 5.sp,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                        : Icon(
                                          Icons.cleaning_services_outlined,
                                          size: 4.sp,
                                          color: Colors.white,
                                        ),
                                label: Text(
                                  controller.isCleaning.value
                                      ? 'Cleaning...'
                                      : 'Cleanup Tokens',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 3.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        // হালকা ব্যাকগ্রাউন্ড
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔍 Search TextField
                          // Search TextField
                          TextField(
                            controller: controller.searchC,
                            onChanged: controller.onSearchChanged,
                            decoration: InputDecoration(
                              hintText: "Search by name or email...",
                              hintStyle: TextStyle(
                                fontSize: 3.sp,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 4.sp,
                                color: Colors.grey[700],
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 6.h,
                                horizontal: 8.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(fontSize: 4.sp),
                          ),

                          SizedBox(height: 15.h),
                          SizedBox(
                            width: double.infinity,
                            height: 35.h,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showAddMemberDialog(context, controller);
                              },
                              icon: Icon(
                                Icons.person_add_alt_1,
                                size: 4.sp,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Add Member",
                                style: TextStyle(
                                  fontSize: 3.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ===== Members table (header + rows) =====
              // ===== Members table (header + rows) =====
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.members.isEmpty) {
                  return Center(
                    child: Text(
                      'No members found',
                      style: TextStyle(fontSize: 4.sp, color: Colors.grey),
                    ),
                  );
                }
                final double tableWidth = 783.w;

                return Scrollbar(
                  controller: controller.hCtrl,
                  thumbVisibility: true, // thumb always visible
                  interactive: true,
                  notificationPredicate: (notif) => notif.depth == 0,
                  child: SingleChildScrollView(
                    controller: controller.hCtrl,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: Column(
                        children: [
                          _headerRow(),
                          ListView.separated(
                            padding: EdgeInsets.only(top: 8.h),
                            itemCount: controller.visibleMembers.length,
                            shrinkWrap: true,
                            physics:
                                const ClampingScrollPhysics(), // vertical scroll এখানে-ই
                            separatorBuilder: (_, __) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final m = controller.visibleMembers[index];
                              final t = controller.tokensByMember[m.id ?? -1];

                              return _dataRow(
                                id: '#${m.id}',
                                name: m.name,
                                email: m.email,
                                phone: m.phone,
                                membership: m.membershipType,
                                status: m.status,
                                created: m.createdAt,
                                updated: m.updatedAt,
                                username: t?.username ?? '',
                                token: t?.token ?? '',
                                tokenIssuedAt: t?.tokenIssuedAt ?? '',
                                tokenExpiresAt: t?.tokenExpiresAt ?? '',
                                onAddCredential:
                                    () => controller.openCredentialDialog(
                                      context,
                                      m,
                                    ),
                                onGenerateToken:
                                    () => controller.openTokenInputDialog(m),
                                onToggleStatus:
                                    () => controller.toggleMemberStatus(m),
                                onDelete: () => controller.confirmAndDelete(m),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // ===== Pagination Bar =====
              Obx(() {
                final pc = controller.pageCount;
                if (pc <= 1) return const SizedBox.shrink();

                final pages = List<int>.generate(pc, (i) => i + 1);

                return Padding(
                  padding: EdgeInsets.only(top: 12.h, left: 10.w, right: 10.w),
                  child: Row(
                    children: [
                      // Prev
                      // _pageNavButton(
                      //   label: 'Prev',
                      //   enabled: controller.currentPage.value > 1,
                      //   onTap: controller.prevPage,
                      // ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                pages.map((p) {
                                  final isActive =
                                      controller.currentPage.value == p;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    child: _pageNumber(
                                      text: p.toString(),
                                      active: isActive,
                                      onTap: () => controller.goToPage(p),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),
                      // Next
                      // _pageNavButton(
                      //   label: 'Next',
                      //   enabled: controller.currentPage.value < pc,
                      //   onTap: controller.nextPage,
                      // ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageNumber({
    required String text,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 3.5.sp,
            color: active ? Colors.white : Colors.black87,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _pageNavButton({
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 3.5.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Header row
  Widget _headerRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _headerCell('ID', width: 32.w),
          _headerCell('Name', width: 53.w),
          _headerCell('Email', width: 48.w),
          _headerCell('Phone', width: 37.w),
          _headerCell('Membership', width: 40.w),
          _headerCell('Status', width: 45.w),
          _headerCell('Created', width: 55.w),
          _headerCell('Updated', width: 55.w),
          _headerCell('Username', width: 70.w), // 🆕
          _headerCell('Token', width: 65.w),
          _headerCell('Token Issue-date', width: 60.w),
          _headerCell('Token Expire-date', width: 60.w),
          _headerCell('Actions', width: 90.w),
          _headerCell('Delete', width: 25.w),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required double width}) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 3.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Data row
  Widget _dataRow({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String membership,
    required String status,
    required String created,
    required String updated,
    required String username, // 🆕
    required String token, // 🆕
    required String tokenIssuedAt, // 🆕
    required String tokenExpiresAt, // 🆕
    required VoidCallback onAddCredential,
    required VoidCallback onGenerateToken,
    required VoidCallback onToggleStatus,
    required VoidCallback onDelete,
  }) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _cell(id, width: 22.w, bold: true),
          _cell(name, width: 45.w),
          _cell(email, width: 60.w),
          _cell(phone, width: 40.w),
          _chipCell(membership, width: 40.w),
          _statusCell(
            isActive ? 'Active' : status,
            isActive,
            width: 35.w,
            onTap: onToggleStatus,
          ),
          _cell(_shortDate(created), width: 55.w),
          _cell(_shortDate(updated), width: 60.w),

          // 🆕 Username & Token
          _cell(username.isEmpty ? '-' : username, width: 45.w),
          _tokenCell(token, width: 90.w),
          // 🆕 token times
          _cell(
            tokenIssuedAt.isEmpty ? '-' : _shortDate(tokenIssuedAt),
            width: 60.w,
          ),
          _cell(
            tokenExpiresAt.isEmpty ? '-' : _shortDate(tokenExpiresAt),
            width: 60.w,
          ),

          // Actions
          _actionCell(
            width: 45.w,
            label: 'Add Credential',
            onTap: onAddCredential,
            submitted: username.isNotEmpty,
          ),

          _actionCells(
            width: 45.w,
            label: token.isNotEmpty ? 'Generated' : 'Generate',
            onTap: () {
              if (username.isEmpty) {
                Get.snackbar(
                  'Set credentials first',
                  'Please add a username & password before generating a token.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }
              onGenerateToken();
            },
            disabled: token.isNotEmpty,
          ),

          // _actionCells(
          //   width: 45.w,
          //   label: token.isNotEmpty ? 'Generated' : 'Generate',
          //   onTap: onGenerateToken,
          //   disabled: token.isNotEmpty,
          // ),
          _deleteCell(width: 40.w, onTap: onDelete),
        ],
      ),
    );
  }

  // Widget _cellWithToken({
  //   required double width,
  //   required VoidCallback onGenerate,
  // }) {
  //   return Container(
  //     width: width,
  //     padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
  //     alignment: Alignment.centerLeft,
  //     decoration: BoxDecoration(
  //       border: Border(right: BorderSide(color: Colors.grey.shade200)),
  //     ),
  //     child: InkWell(
  //       onTap: onGenerate,
  //       borderRadius: BorderRadius.circular(6.r),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
  //         decoration: BoxDecoration(
  //           color: Colors.green,
  //           borderRadius: BorderRadius.circular(6.r),
  //         ),
  //         child: Text(
  //           'Genarate',
  //           style: TextStyle(
  //             fontSize: 2.6.sp,
  //             color: Colors.white,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _actionCells({
    required double width,
    required String label,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: disabled ? Colors.grey : Colors.green,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 3.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionCell({
    required double width,
    required String label,
    required VoidCallback onTap,
    bool submitted = false,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: submitted ? null : onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: submitted ? Colors.blue : Colors.black,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              submitted ? 'Submitted' : label,
              style: TextStyle(
                fontSize: 3.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // Plain text cell
  Widget _cell(String text, {required double width, bool bold = false}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 3.sp,
            color: Colors.black87,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Membership chip-like cell
  Widget _chipCell(String text, {required double width}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF3FF),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFB6C6FF)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 3.sp, color: const Color(0xFF274690)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // Status pill cell
  Widget _statusCell(
    String text,
    bool active, {
    required double width,
    VoidCallback? onTap,
  }) {
    final bg = active ? Colors.green.shade100 : Colors.red.shade100;
    final fg = active ? Colors.green.shade800 : Colors.red.shade800;
    final bd = active ? Colors.green.shade400 : Colors.red.shade400;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: bd),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 3.sp,
                color: fg,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _statusCell(String text, bool active, {required double width}) {
  //   final bg = active ? Colors.green.shade100 : Colors.red.shade100;
  //   final fg = active ? Colors.green.shade800 : Colors.red.shade800;
  //   final bd = active ? Colors.green.shade400 : Colors.red.shade400;

  //   return Container(
  //     width: width,
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
  //     decoration: BoxDecoration(
  //       border: Border(right: BorderSide(color: Colors.grey.shade200)),
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
  //       decoration: BoxDecoration(
  //         color: bg,
  //         borderRadius: BorderRadius.circular(20.r),
  //         border: Border.all(color: bd),
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: 3.sp,
  //             color: fg,
  //             fontWeight: FontWeight.w600,
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _deleteCell({required double width, required VoidCallback onTap}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        // border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 3.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tokenCell(String token, {required double width}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child:
          token.isEmpty
              ? Center(child: Text('-', style: TextStyle(fontSize: 3.sp)))
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        token,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 3.sp),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: token));
                        Get.snackbar(
                          'Copied',
                          'Token copied to clipboard.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green.shade600,
                          colorText: Colors.white,
                        );
                      },
                      child: const Icon(Icons.copy, size: 16),
                    ),
                  ],
                ),
              ),
    );
  }

  String _shortDate(String iso) {
    if (iso.isEmpty) return '-';
    final s = iso.replaceFirst('T', ' ');
    return s.length >= 16 ? s.substring(0, 16) : s;
  }
}
