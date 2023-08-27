import 'package:flutter/material.dart';

class DropDownItemElements {
  final int value;
  final String label;

  DropDownItemElements(this.value, this.label);
}

class M4DropDownMenu extends StatefulWidget {
  const M4DropDownMenu({super.key, required this.dropdownElements});

  final List<DropDownItemElements> dropdownElements;

  @override
  State<M4DropDownMenu> createState() => _M4DropDownMenuState();
}

class _M4DropDownMenuState extends State<M4DropDownMenu> {
  int dropdownSelectedValue = 0;

  @override
  Widget build(BuildContext context) {
    // TODO there is space between text and training icon, need a way to
    //      remvoe it
    return Container(
      color: Colors.blue,
      child: DropdownMenu<int>(
        initialSelection: dropdownSelectedValue,
        trailingIcon: Icon(Icons.expand_more),
        selectedTrailingIcon: Icon(Icons.expand_less),
        dropdownMenuEntries: widget.dropdownElements
            .map<DropdownMenuEntry<int>>(
              (e) => DropdownMenuEntry(value: e.value, label: e.label),
            )
            .toList(),
        enableFilter: false,
        enableSearch: false,
        textStyle: TextStyle(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          // isCollapsed: true,
          // filled: true,
          border: InputBorder.none,
          suffixIconColor: Colors.white,
          contentPadding: const EdgeInsets.all(8.0),
          // constraints: BoxConstraints(maxWidth: 110),
        ),
        menuStyle:
            MenuStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
      ),
    );
  }
}
