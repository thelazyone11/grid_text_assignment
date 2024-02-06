import 'package:flutter/material.dart';
import 'package:grid_text_assignment/GridInputScreen.dart';

class GridSearchScreen extends StatefulWidget {
  final int m; // Row
  final int n; // Colume

  final List<List<String>> fGrid;

  const GridSearchScreen(
      {super.key, required this.m, required this.n, required this.fGrid});
  @override
  _GridSearchScreenState createState() => _GridSearchScreenState();
}

class _GridSearchScreenState extends State<GridSearchScreen> {
  List<List<String>> displayGrid = [];
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayGrid = widget.fGrid.map((row) => row.toList()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Search App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTextController,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Enter Text to Search'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => searchGrid(),
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      widget.fGrid.isNotEmpty ? widget.fGrid[0].length : 1,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ widget.fGrid[0].length;
                  int col = index % widget.fGrid[0].length;
                  return GridTile(
                    child: Container(
                      color: displayGrid[row][col].contains("*")
                          ? Colors.yellow
                          : displayGrid[row][col].contains("#")
                              ? Colors.green
                              : displayGrid[row][col].contains("@")
                                  ? Colors.blue
                                  : Colors.white,
                      child: Center(
                        child: Text(displayGrid[row][col]),
                      ),
                    ),
                  );
                },
                itemCount: widget.fGrid.isNotEmpty
                    ? widget.fGrid.length * widget.fGrid[0].length
                    : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchGrid() {
    displayGrid = widget.fGrid.map((row) => row.toList()).toList();
    int textFoundCount = 0;

    String searchText = searchTextController.text;
    if (widget.fGrid.isNotEmpty &&
        widget.fGrid[0].isNotEmpty &&
        searchText.isNotEmpty) {
      for (int i = 0; i < widget.fGrid.length; i++) {
        for (int j = 0; j < widget.fGrid[0].length; j++) {
          // if (searchInDirection(i, j, searchText, 1, 0, "*") ||
          //     searchInDirection(i, j, searchText, 1, 1, "@") ||
          //     searchInDirection(i, j, searchText, 0, 1, "#")) {
          //   return;
          // }

          if (searchInDirection(i, j, searchText, 1, 0, "*")) {
            textFoundCount++;
          }
          if (searchInDirection(i, j, searchText, 1, 1, "@")) {
            textFoundCount++;
          }

          if (searchInDirection(i, j, searchText, 0, 1, "#")) {
            textFoundCount++;
          }
        }
      }
      if (textFoundCount != 0) {
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Text not found in the grid')));
  }

  bool searchInDirection(int row, int col, String searchText, int rowIncrement,
      int colIncrement, String syb) {
    int len = searchText.length;
    int i = 0;
    for (; i < len; i++) {
      int currentRow = row + i * rowIncrement;
      int currentCol = col + i * colIncrement;

      if (currentRow >= widget.fGrid.length ||
          currentCol >= widget.fGrid[0].length ||
          widget.fGrid[currentRow][currentCol] != searchText[i]) {
        break;
      }
    }

    if (i == len) {
      markHighlighted(row, col, len, rowIncrement, colIncrement, syb);
      return true;
    }

    return false;
  }

  void markHighlighted(int row, int col, int len, int rowIncrement,
      int colIncrement, String syb) {
    for (int i = 0; i < len; i++) {
      int currentRow = row + i * rowIncrement;
      int currentCol = col + i * colIncrement;
      displayGrid[currentRow][currentCol] =
          '$syb${widget.fGrid[currentRow][currentCol]}';
    }

    setState(() {});
  }
}
