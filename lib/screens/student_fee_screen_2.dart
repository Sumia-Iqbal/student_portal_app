import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/fee_controller.dart';
import '../helpers/colors.dart';

class StudentFeesScreen2 extends StatelessWidget {
  final FeeController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    ctrl.fetchFees();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fees – ${ctrl.selectedStudent?['name'] ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: drawerContainer,
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.fees.isEmpty) {
          return const Center(child: Text("No fee records found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.fees.length,
          itemBuilder: (context, index) {
            final fee = ctrl.fees[index];
            final isPaid = (fee['status'] ?? '') == 'paid';
            final fine = ctrl.calcFine(fee);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: isPaid ? Colors.white : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header Row with Month & Year
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${fee['month']} ${fee['year']}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isPaid
                            ? Icon(Icons.check_circle, color: drawerContainer)
                            : ElevatedButton(
                          onPressed: () {
                            ctrl.markPaid(fee['id'].toString());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Mark Paid"),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    /// Table-style Rows
                    _rowItem("Due Date", _formatDate(fee['due_date'])),
                    _rowItem("Amount", "Rs. ${fee['amount']}"),
                    if (!isPaid && fine > 0)
                      _rowItem("Fine", "Rs. $fine", color: Colors.redAccent),
                    _rowItem("Status", fee['status'].toString().capitalizeFirst!),
                    if (fee['paid_date'] != null)
                      _rowItem("Paid On", _formatDate(fee['paid_date'])),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// Helper widget for row items like a mini table
  Widget _rowItem(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: drawerContainer,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "-";
    final dt = DateTime.tryParse(dateStr);
    return dt != null ? DateFormat('dd MMM yyyy').format(dt) : "-";
  }
}
