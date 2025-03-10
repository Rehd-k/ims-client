import 'package:flutter/material.dart';

class SmallTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const SmallTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns:
              columns.map((column) => DataColumn(label: Text(column))).toList(),
          rows: rows.asMap().entries.map((entry) {
            int index = entry.key;
            List<String> row = entry.value;
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (index % 2 == 0) {
                    return Theme.of(context)
                        .colorScheme
                        .surfaceBright; // Even rows
                  } else {
                    return Theme.of(context).colorScheme.surfaceDim; // Odd rows
                  }
                },
              ),
              cells: row.map((cell) => DataCell(Text(cell))).toList(),
            );
          }).toList(),
          border: TableBorder.all(style: BorderStyle.none),
        ),
      ),
    );
  }
}
