import 'package:flutter/material.dart';

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample dummy data: 2D List
    final List<List<String>> timeTableData = [
      ["Lectures", "Miss Imroiza", "Urdu", "BREAK", "Diary", "OFF"],
      ["1st", "Miss Imroiza", "English", "BREAK", "Diary", "OFF"],
      ["3rd", "Sir Waqas", "Islamiat", "Miss Imroiza", "Urdu", "OFF"],
      ["5th", "Dr. Wajid", "English", "Sir Waqas", "Islamiat", "OFF"],
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Time Table")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns:  [
            DataColumn(label: Text("Timings", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("8:30AM-9:10AM", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("9:10AM-9:50AM", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("9:50AM-10:30AM", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("10:30AM-11:00AM", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("11:00AM-11:40AM", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List.generate(4, (index) {
            final row = timeTableData[index];
            return DataRow(
              cells: List.generate(
                row.length,
                    (cellIndex) => DataCell(Text(row[cellIndex])),
              ),
            );
          }),
        ),
      ),
    );
  }
}
