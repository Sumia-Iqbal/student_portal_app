import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fee_controller.dart';
import '../helpers/colors.dart';

class StudentFeesScreen extends StatelessWidget {
  final FeeController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      ctrl.fetchFees();
    });


    return Scaffold(
      appBar: AppBar(title: Text("Fees – ${ctrl.selectedStudent!['name']}"), backgroundColor: drawerContainer),
      body: Obx(() {
        if (ctrl.isLoading.value) return Center(child: CircularProgressIndicator());
        if (ctrl.fees.isEmpty) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(child: Text("No fee records.")),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add New Fee", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: drawerContainer, minimumSize: Size(double.infinity, 50)),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Add Fee",
                    content: AddFeeForm(),
                  );
                },
              ),
            ],
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (var fee in ctrl.fees)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("${fee['month']} ${fee['year']}", style: TextStyle(color: drawerContainer, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("Amount:Rs${fee['amount']}", style: TextStyle(fontSize: 16)),
                      Text("Status: ${fee['status'].toString().capitalizeFirst}", style: TextStyle(fontSize: 16)),
                    ]),
                    SizedBox(height: 8),
                    if (ctrl.calcFine(fee) > 0)
                      Text("Fine: Rs${ctrl.calcFine(fee).toStringAsFixed(0)}", style: TextStyle(color: Colors.red, fontSize: 16)),
                    SizedBox(height: 12),
                    if (fee['status'] != 'paid')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: drawerContainer),
                        onPressed: () => ctrl.markPaid(fee['id'].toString()),
                        child: const Text("Mark as Paid",
                        style:TextStyle(color:Colors.white)
                        ),
                      ),
                  ]),
                ),
              ),
            ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.white),
              label: Text("Add New Fee", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: drawerContainer, minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                Get.defaultDialog(
                  title: "Add Fee",
                  content: AddFeeForm(),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

class AddFeeForm extends StatefulWidget {
  @override
  _AddFeeFormState createState() => _AddFeeFormState();
}
class _AddFeeFormState extends State<AddFeeForm> {
  final FeeController ctrl = Get.find();
  final _formKey = GlobalKey<FormState>();
  String month = '', remarks = '';
  double amount = 0;
  int fine = 0;
  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding:EdgeInsets.only(left:8),
          margin:EdgeInsets.symmetric(horizontal:12),
          decoration:BoxDecoration(
              color:Colors.grey.shade300,
            borderRadius:BorderRadius.circular(12)

          ),
          child: TextFormField(
            decoration: InputDecoration(labelText: "Month (e.g., July)", border:InputBorder.none),
            validator: (val) => val == null || val.isEmpty ? "Enter month" : null,
            onSaved: (v) => month = v!,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding:EdgeInsets.only(left:8),
          margin:EdgeInsets.symmetric(horizontal:12),
          decoration:BoxDecoration(
              color:Colors.grey.shade300,
              borderRadius:BorderRadius.circular(12)

          ),
          child: TextFormField(
            decoration: InputDecoration(labelText: "Amount", border: InputBorder.none),
            keyboardType: TextInputType.number,
            validator: (val) => val == null || double.tryParse(val) == null ? "Enter amount" : null,
            onSaved: (v) => amount = double.parse(v!),
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding:EdgeInsets.only(left:8),
          margin:EdgeInsets.symmetric(horizontal:12),
          decoration:BoxDecoration(
              color:Colors.grey.shade300,
              borderRadius:BorderRadius.circular(12)

          ),
          child: TextFormField(
            decoration: InputDecoration(labelText: "Remarks", border: InputBorder.none),
            onSaved: (v) => remarks = v ?? '',
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.only(left: 8),
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            decoration: InputDecoration(labelText: "Fine", border: InputBorder.none),
            keyboardType: TextInputType.number,
            validator: (val) => val == null || int.tryParse(val) == null ? "Enter fine amount" : null,
            onSaved: (v) => fine = int.tryParse(v ?? '0') ?? 0,
          ),
        ),

        Row(children: [
          Text("Due: ${dueDate.toLocal().toString().split(' ')[0]}"),
          Spacer(),
          TextButton(
            onPressed: () async {
              final d = await showDatePicker(context: context, initialDate: dueDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (d != null) setState(() => dueDate = d);
            },
            child: Text("Select Due Date"),
          )
        ]),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: drawerContainer),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              ctrl.addFee({
                'student_id': ctrl.selectedStudent!['id'],
                'month': month,
                'year': dueDate.year,
                'amount': amount,
                'due_date': dueDate.toIso8601String(),
                'paid_date': null,
                'status': 'unpaid',
                'fine': fine,
                'remarks': remarks,
              });
              Get.back();
            }
          },
          child: Text("Save Fee",
          style: TextStyle(color:Colors.white),
          ),
        )
      ]),
    );
  }
}
