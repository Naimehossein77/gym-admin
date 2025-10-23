
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gym_admin/Views/DashbordScreen/dashboard_screen_controller.dart';

// import '../../Model/member_model.dart';

// class DashboardScreen extends GetView<DashboardScreenController> {
//   DashboardScreen({super.key});
//   DashboardScreenController controller = Get.put(DashboardScreenController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 100.h),
//                 Align(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 0.w),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
                                
//                               },
//                               child: Text("Add Member"),
//                             ),
//                           ],
//                         ),
//                         Obx(() {
//                           if (controller.isLoading.value) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }

//                           if (controller.members.isEmpty) {
//                             return const Center(
//                               child: Text('No members found.'),
//                             );
//                           }

//                           return Column(
//                             children: [
//                               SingleChildScrollView(
//                                 // scrollDirection: Axis.vertical,
//                                 scrollDirection: Axis.horizontal,
//                                 padding: const EdgeInsets.all(16),

//                                 child: Card(
//                                   elevation: 4,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: DataTable(
//                                     headingRowColor: MaterialStateProperty.all(
//                                       Colors.blueAccent.withOpacity(0.1),
//                                     ),
//                                     columnSpacing: 20,
//                                     horizontalMargin: 16,
//                                     columns: const [
//                                       DataColumn(
//                                         label: Text(
//                                           'ID',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Name',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Email',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Phone', 
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Type',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Status',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Delete Member',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'Add Credential',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'token genarate',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'User name',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       DataColumn(
//                                         label: Text(
//                                           'View Token',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                     rows:
//                                         controller.paginatedMembers.map((
//                                           member,
//                                         ) {
//                                           return DataRow(
//                                             cells: [
//                                               DataCell(
//                                                 Text(member.id.toString()),
//                                               ),
//                                               DataCell(Text(member.name)),
//                                               DataCell(Text(member.email)),
//                                               DataCell(Text(member.phone)),
//                                               DataCell(
//                                                 Text(member.membershipType),
//                                               ),
//                                               DataCell(
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 8,
//                                                         vertical: 4,
//                                                       ),
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         member.status
//                                                                     .toLowerCase() ==
//                                                                 'active'
//                                                             ? Colors.green
//                                                                 .withOpacity(
//                                                                   0.2,
//                                                                 )
//                                                             : Colors.red
//                                                                 .withOpacity(
//                                                                   0.2,
//                                                                 ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           6,
//                                                         ),
//                                                   ),
//                                                   child: Text(
//                                                     member.status,
//                                                     style: TextStyle(
//                                                       color:
//                                                           member.status
//                                                                       .toLowerCase() ==
//                                                                   'active'
//                                                               ? Colors.green
//                                                               : Colors.red,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 IconButton(
//                                                   icon: Icon(
//                                                     Icons.delete,
//                                                     color: Colors.red,
//                                                   ),
//                                                   tooltip: 'Delete Member',
//                                                   onPressed: () {
//                                                     Get.defaultDialog(
//                                                       title: "Confirm Delete",
//                                                       middleText:
//                                                           "Are you sure you want to delete ${member.name}?",
//                                                       textCancel: "Cancel",
//                                                       textConfirm: "Delete",
//                                                       confirmTextColor:
//                                                           Colors.white,
//                                                       onConfirm: () {
//                                                         Get.back();
//                                                         controller.deleteMember(
//                                                           member.id,
//                                                         );
//                                                       },
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 IconButton(
//                                                   icon: Icon(Icons.add),
//                                                   tooltip: 'add credentisl',
//                                                   onPressed: () {
//                                                     controller
//                                                         .selectedMember
//                                                         .value = MemberModel(
//                                                       id: member.id,
//                                                       name: member.name,
//                                                       email: member.email,
//                                                       phone: member.phone,
//                                                       membershipType:
//                                                           member.membershipType,
//                                                       status: member.status,
//                                                       createdAt: DateTime.now(),
//                                                       updatedAt: DateTime.now(),
//                                                     );
//                                                     // credendentials();
//                                                   },
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 InkWell(
//                                                   onTap: () {
//                                                     // tokenGenarate();
//                                                   },
//                                                   child: Container(
//                                                     height: 25.h,
//                                                     width: 70.h,

//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             5.sp,
//                                                           ),
//                                                       border: Border.all(
//                                                         color: Colors.grey,
//                                                       ),
//                                                     ),
//                                                     child: Center(
//                                                       child: Text("Generate"),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Container(
//                                                   child: Text("userName"),
//                                                 ),
//                                               ),
//                                               DataCell(
//                                                 Container(
//                                                   child: Text(
//                                                     "toksdfjsfusdfgjsfddujfgdsjfgjsdfgfen",
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         }).toList(),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.arrow_back),
//                                       onPressed:
//                                           controller.currentPage.value > 0
//                                               ? controller.previousPage
//                                               : null,
//                                     ),
//                                     Text(
//                                       'Page ${controller.currentPage.value + 1} of ${((controller.members.length - 1) / controller.pageSize).ceil()}',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.arrow_forward),
//                                       onPressed:
//                                           ((controller.currentPage.value + 1) *
//                                                       controller.pageSize <
//                                                   controller.members.length)
//                                               ? controller.nextPage
//                                               : null,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }
