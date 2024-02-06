import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grid_text_assignment/GridSearchScreen.dart';

class GridInputScreen extends StatefulWidget {
  const GridInputScreen({super.key});

  @override
  _GridInputScreenState createState() => _GridInputScreenState();
}

class _GridInputScreenState extends State<GridInputScreen> {
  int rows = 2;
  int columns = 2;
  Map<int, String> gridData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              const Text('Rows:'),
              const SizedBox(width: 10),
              Flexible(
                child: TextFormField(
                  initialValue: rows.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      rows = int.tryParse(value) ?? 0;
                      gridData.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              const Text('Columns:'),
              const SizedBox(width: 10),
              Flexible(
                child: TextFormField(
                  initialValue: columns.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      columns = int.tryParse(value) ?? 0;

                      gridData.clear();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns == 0 ? 1 : columns,
              ),
              itemCount: rows * columns,
              itemBuilder: (context, index) {
                return GridItem(
                  index: index,
                  onTextChanged: (text) {
                    setState(() {
                      gridData[index] = text;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (validateGridData()) {
                // List<String> alpha = gridData.values.toList();

                generateGrid(int m, int n) {
                  final List<List<String>> grid = [];
                  grid.clear();

                  List<String> alphabets = gridData.values.toList();

                  for (int i = 0; i < m; i++) {
                    List<String> row = [];
                    for (int j = 0; j < n; j++) {
                      row.add(alphabets[i * n + j]);
                    }
                    grid.add(row);
                  }
                  return grid;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GridSearchScreen(
                        m: rows,
                        n: columns,
                        fGrid: generateGrid(rows, columns)),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Incomplete Data'),
                      content:
                          const Text('Please enter text in all grid blocks.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Next Page'),
          ),
          const SizedBox(height: 20),
          Text('Grid Data: $gridData'),
        ],
      ),
    );
  }

  bool validateGridData() {
    for (int i = 0; i < rows * columns; i++) {
      if (!gridData.containsKey(i) || gridData[i]!.isEmpty) {
        return false;
      }
    }
    return true;
  }
}

class GridItem extends StatelessWidget {
  final int index;
  final Function(String) onTextChanged;

  const GridItem({
    super.key,
    required this.index,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: TextField(
        onChanged: onTextChanged,
        inputFormatters: [
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: const InputDecoration(
          hintText: 'Enter text',
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
