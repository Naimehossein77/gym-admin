// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gym_admin/Dashboard_Screen/dashboard_controller.dart';

// class DashboardScreen extends GetView<DashboardController> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         centerTitle: true,
//         title: ElevatedButton.icon(
//           onPressed: () {
//             controller.showAdminPopup(context);
//           },
//           icon: const Icon(Icons.person_add, color: Colors.white),
//           label: const Text(
//             'Add Members',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         backgroundColor: theme.colorScheme.primary,
//       ),

//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.members.isEmpty) {
//           return const Center(child: Text("No members found"));
//         }

//         return Column(
//           children: [
//             Expanded(
//               child: Scrollbar(
//                 controller: controller.verticalController,
//                 thumbVisibility: true,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Scrollbar(
//                     controller: controller.horizontalController,
//                     trackVisibility: true,
//                     // notificationPredicate: (notif) => notif.depth == 1,
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                        controller:controller.horizontalController,
//                       scrollDirection: Axis.horizontal,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minWidth: MediaQuery.of(context).size.width,
//                         ),
//                         child: DataTable(
//                           headingRowHeight: 60,
//                           dataRowHeight: 70,
//                           columnSpacing: 24,
//                           headingRowColor: MaterialStateProperty.all(
//                             theme.colorScheme.primaryContainer,
//                           ),
//                           columns: const [
//                             DataColumn(label: Text('ID')),
//                             DataColumn(label: Text('Name')),
//                             DataColumn(label: Text('Email')),
//                             DataColumn(label: Text('Phone')),
//                             DataColumn(label: Text('Type')),
//                             DataColumn(label: Text('Status')),
//                             DataColumn(label: Text('Delete')),
//                             DataColumn(label: Text('Add Credential')),
//                             DataColumn(label: Text('Token')),
//                             DataColumn(label: Text('Username')),
//                             DataColumn(label: Text('View Token')),
//                           ],
//                           rows:
//                               controller.members.map((member) {
//                                 return DataRow(
//                                   cells: [
//                                     DataCell(Text(member.id.toString())),
//                                     DataCell(Text(member.name)),
//                                     DataCell(Text(member.email)),
//                                     DataCell(Text(member.phone)),
//                                     DataCell(Text(member.membershipType)),
//                                     DataCell(Text(member.status)),
//                                     DataCell(
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                         ),
//                                         onPressed:
//                                             () => controller.deleteMembers(
//                                               member.id,
//                                             ),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.add_circle_outline,
//                                         ),
//                                         onPressed:
//                                             () =>
//                                                 controller.showCredentialPopup(
//                                                   context,
//                                                   member.id,
//                                                 ),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor:
//                                               theme.colorScheme.secondary,
//                                         ),
//                                         onPressed:
//                                             () => controller.showTokenPopup(
//                                               context,
//                                               member.id,
//                                             ),
//                                         child: const Text('Generate'),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Text(
//                                         member.username.isNotEmpty
//                                             ? member.username
//                                             : "N/A",
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Obx(() {
//                                         final token =
//                                             controller.generatedTokens[member
//                                                 .id] ??
//                                             "No token";
//                                         return Text(token);
//                                       }),
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // ✅ Pagination Buttons
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Obx(() {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(controller.totalPages, (index) {
//                     final pageNumber = index + 1;
//                     final isSelected =
//                         controller.currentPage.value == pageNumber;

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           controller.currentPage.value = pageNumber;
//                           controller.fetchMembers(page: pageNumber);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               isSelected ? Colors.blue : Colors.grey[300],
//                         ),
//                         child: Text(
//                           "$pageNumber",
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               }),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_admin/Dashboard_Screen/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🌌 Elegant Material 3 Dark Palette
    const backgroundColor = Color(0xFF0D1117);
    const cardColor = Color(0xFF161B22);
    const headerColor = Color(0xFF1F2937);
    const dividerColor = Color(0xFF30363D);
    final primaryColor = Colors.tealAccent.shade400;
    final accentColor = Colors.indigoAccent.shade200;
    final deleteColor = Colors.redAccent.shade200;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: cardColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard, color: Colors.tealAccent, size: 26),
            const SizedBox(width: 8),
            Text(
              "Admin Dashboard",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => controller.showAdminPopup(context),
              icon: const Icon(Icons.person_add_alt_1, color: Colors.black),
              label: const Text(
                "Add Member",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),

      // 🌌 Body Content
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.tealAccent),
          );
        }

        if (controller.members.isEmpty) {
          return const Center(
            child: Text(
              "No members found",
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                
                interactive:true,
                controller: controller.verticalController,
                thumbVisibility: true,
                trackVisibility: true,
                // thickness: 10,
                radius: const Radius.circular(12),

                child: SingleChildScrollView(
                  
                  controller: controller.verticalController,
                  scrollDirection: Axis.vertical,
                  child: RawScrollbar(
                    // trackBorderColor: Colors.amber,
                    controller: controller.horizontalController,
                    thumbVisibility: true,
                    thickness: 10,

                    radius: const Radius.circular(12),

                    child: SingleChildScrollView(
                      controller: controller.horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: dividerColor),
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              headerColor,
                            ),
                            headingTextStyle: const TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            dataTextStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            columnSpacing: 28,
                            dividerThickness: 0.6,
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Delete')),
                              DataColumn(label: Text('Add Credential')),
                              DataColumn(label: Text('Token')),
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('View Token')),
                            ],
                            rows:
                                controller.members.map((member) {
                                  final isActive =
                                      member.status.toLowerCase() == 'active';
                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                      Color?
                                    >((states) {
                                      if (states.contains(
                                        MaterialState.hovered,
                                      )) {
                                        return Colors.tealAccent.withOpacity(
                                          0.05,
                                        );
                                      }
                                      return null;
                                    }),
                                    cells: [
                                      DataCell(Text(member.id.toString())),
                                      DataCell(Text(member.name)),
                                      DataCell(Text(member.email)),
                                      DataCell(Text(member.phone)),
                                      DataCell(Text(member.membershipType)),

                                      // 🌟 Modern Status Badge
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors:
                                                  isActive
                                                      ? [
                                                        Colors
                                                            .greenAccent
                                                            .shade400,
                                                        Colors
                                                            .tealAccent
                                                            .shade700,
                                                      ]
                                                      : [
                                                        Colors
                                                            .redAccent
                                                            .shade400,
                                                        Colors.red.shade800,
                                                      ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    isActive
                                                        ? Colors.tealAccent
                                                            .withOpacity(0.2)
                                                        : Colors.redAccent
                                                            .withOpacity(0.2),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isActive
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                member.status.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      DataCell(
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: deleteColor,
                                          ),
                                          onPressed:
                                              () => controller.deleteMembers(
                                                member.id,
                                              ),
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: primaryColor,
                                          ),
                                          onPressed:
                                              () => controller
                                                  .showCredentialPopup(
                                                    context,
                                                    member.id,
                                                  ),
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 4,
                                          ),
                                          onPressed:
                                              () => controller.showTokenPopup(
                                                context,
                                                member.id,
                                              ),
                                          child: const Text(
                                            'Generate',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          member.username.isNotEmpty
                                              ? member.username
                                              : "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Obx(() {
                                          final token =
                                              controller.generatedTokens[member
                                                  .id] ??
                                              "No token";
                                          return Text(token);
                                        }),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🌙 Floating Pagination
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() {
                return Wrap(
                  spacing: 8,
                  children: List.generate(controller.totalPages, (index) {
                    final pageNumber = index + 1;
                    final isSelected =
                        controller.currentPage.value == pageNumber;
                    return ElevatedButton(
                      onPressed: () {
                        controller.currentPage.value = pageNumber;
                        controller.fetchMembers(page: pageNumber);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? primaryColor : Colors.grey.shade900,
                        foregroundColor:
                            isSelected ? Colors.black : Colors.white70,
                        elevation: isSelected ? 6 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        "$pageNumber",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
