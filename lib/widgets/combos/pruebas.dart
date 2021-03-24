import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

// This class uses searchable dropdown package
// Link to it :  https://pub.dev/packages/searchable_dropdown

class DropdownSearchable extends StatefulWidget {
  static const routeName = '/DropdownSearchable';
  @override
  _DropdownSearchableState createState() => _DropdownSearchableState();
}

class _DropdownSearchableState extends State<DropdownSearchable> {


  String selectedValue;
  List<int> selectedItems;
  final List<DropdownMenuItem> items = [
    DropdownMenuItem(
      child: Text("Item1"),
      value: "Item1",
    ),
    DropdownMenuItem(
      child: Text("Item2"),
      value: "Item2",
    ),
    DropdownMenuItem(
      child: Text("Item3"),
      value: "Item3",
    ),
    DropdownMenuItem(
      child: Text("Item4"),
      value: "Item4",
    ),
    DropdownMenuItem(
      child: Text("Item5"),
      value: "Item5",
    ),
    DropdownMenuItem(
      child: Text("Item6"),
      value: "Item6",
    ),
    DropdownMenuItem(
      child: Text("Item7"),
      value: "Item7",
    ),
    DropdownMenuItem(
      child: Text("Item8"),
      value: "Item8",
    ),
    DropdownMenuItem(
      child: Text("Item9"),
      value: "Item9",
    ),
    DropdownMenuItem(
      child: Text("Item10"),
      value: "Item10",
    ),
  ];

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 16,right: 16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32.0),

              //==================================================================

              //===============================
              //       Choose One Item
              //===============================
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('Choose One Item',style: TextStyle(fontSize: 14,color: Colors.black)),
                    SearchableDropdown.single(
                      items: items,
                      value: selectedValue,
                      hint: "Select one",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      isExpanded: true,
                    )

                  ],
                ),
              ),

              //==================================================================

              const SizedBox(height: 32.0),

              //==================================================================

              //===============================
              //      Choose Multi Items
              //===============================
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('Choose Multi Items',style:  TextStyle(fontSize: 14,color: Colors.black)),
                    SearchableDropdown.multiple(
                      items: items,
                      selectedItems: selectedItems,
                      hint: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Select any"),
                      ),
                      searchHint: "Select any",
                      onChanged: (value) {
                        setState(() {
                          selectedItems = value;
                        });
                      },
                      closeButton: (selectedItems) {
                        return (selectedItems.isNotEmpty
                            ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                            : "Save without selection");
                      },
                      isExpanded: true,
                    )

                  ],
                ),
              ),

              //==================================================================

              const SizedBox(height: 32.0),

              //==================================================================

              //=======================================
              //   Choose One Item With Done Button
              //=======================================
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('Choose One Item With Done Button',style:  TextStyle(fontSize: 14,color: Colors.black)),
                    SearchableDropdown.single(
                      items: items,
                      value: selectedValue,
                      hint: "Select one",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      doneButton: "Done",
                      displayItem: (item, selected) {
                        return (Row(children: [
                          selected
                              ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.grey,
                          )
                              : Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: item,
                          ),
                        ]));
                      },
                      isExpanded: true,
                    )

                  ],
                ),
              ),

              //==================================================================

              const SizedBox(height: 32.0),

              //==================================================================


              //================================================
              //    Choose Multi Items With Custom Display
              //================================================
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('Choose Multi Items With Custom Display',style:  TextStyle(fontSize: 14,color: Colors.black)),
                    SearchableDropdown.multiple(
                      items: items,
                      selectedItems: selectedItems,
                      hint: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Select any"),
                      ),
                      searchHint: "Select any",
                      onChanged: (value) {
                        setState(() {
                          selectedItems = value;
                        });
                      },
                      displayItem: (item, selected) {
                        return (Row(children: [
                          selected
                              ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                              : Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: item,
                          ),
                        ]));
                      },
                      selectedValueWidgetFn: (item) {
                        return (Center(
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.brown,
                                    width: 0.5,
                                  ),
                                ),
                                margin: EdgeInsets.all(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.toString()),
                                ))));
                      },
                      doneButton: (selectedItemsDone, doneContext) {
                        return (RaisedButton(
                            onPressed: () {
                              Navigator.pop(doneContext);
                              setState(() {});
                            },
                            child: Text("Save")));
                      },
                      closeButton: null,
                      style: TextStyle(fontStyle: FontStyle.italic),
                      searchFn: (String keyword, items) {
                        List<int> ret = List<int>();
                        if (keyword != null && items != null && keyword.isNotEmpty) {
                          keyword.split(" ").forEach((k) {
                            int i = 0;
                            items.forEach((item) {
                              if (k.isNotEmpty &&
                                  (item.value
                                      .toString()
                                      .toLowerCase()
                                      .contains(k.toLowerCase()))) {
                                ret.add(i);
                              }
                              i++;
                            });
                          });
                        }
                        if (keyword.isEmpty) {
                          ret = Iterable<int>.generate(items.length).toList();
                        }
                        return (ret);
                      },
                      clearIcon: Icon(Icons.clear_all),
                      icon: Icon(Icons.arrow_drop_down_circle),
                      label: "Label for multi",
                      underline: Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                            border:
                            Border(bottom: BorderSide(color: Colors.teal, width: 3.0))),
                      ),
                      iconDisabledColor: Colors.brown,
                      iconEnabledColor: Colors.indigo,
                      isExpanded: true,
                    )

                  ],
                ),
              ),


              const SizedBox(height: 32.0),

              //==================================================================

              //===============================================
              //    Choose Multi With select Just 3 Items
              //===============================================
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('Choose Multi With select Just 3 Items',style:  TextStyle(fontSize: 14,color: Colors.black)),
                    SearchableDropdown.multiple(
                      items: items,
                      selectedItems: selectedItems,
                      hint: "Select 3 items",
                      searchHint: "Select 3",
                      validator: (selectedItemsForValidator) {
                        if (selectedItemsForValidator.length != 3) {
                          return ("Must select 3");
                        }
                        return (null);
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedItems = value;
                        });
                      },
                      doneButton: (selectedItemsDone, doneContext) {
                        return (RaisedButton(
                            onPressed: selectedItemsDone.length != 3
                                ? null
                                : () {
                              Navigator.pop(doneContext);
                              setState(() {});
                            },
                            child: Text("Save")));
                      },
                      closeButton: (selectedItems) {
                        return (selectedItems.length == 3 ? "Ok" : null);
                      },
                      isExpanded: true,
                    )

                  ],
                ),
              ),


              //==================================================================

              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}