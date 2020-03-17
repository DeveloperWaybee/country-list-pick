import 'package:country_list_pick/selection_list.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:country_list_pick/support/code_countrys.dart';
import 'package:flutter/material.dart';

export 'support/code_country.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick(
      {this.onChanged,
      this.isShowFlag,
      this.isDownIcon,
      this.isShowTitle,
      this.initialSelection,
      this.onTap});
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isDownIcon;
  final String initialSelection;
  final ValueChanged<CountryCode> onChanged;
  final Function onTap;

  @override
  _CountryListPickState createState() {
    final jsonList = codes.entries;

    List<CountryCode> elements = jsonList
        .map((s) => CountryCode(
              name: s.value["country_name"],
              code: s.key,
              dialCode: s.value["dialling_code"],
              flagUri: 'flags/${s.key.toLowerCase()}.png',
            ))
        .toList();
    return _CountryListPickState(elements);
  }
}

class _CountryListPickState extends State<CountryListPick> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  _CountryListPickState(this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  void _awaitFromSelectScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionList(elements, selectedItem),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        widget.onTap();
        _awaitFromSelectScreen(context);
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.isShowFlag == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  selectedItem.flagUri,
                  package: 'country_list_pick',
                  width: 32.0,
                ),
              ),
            ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(widget.isShowTitle
                  ? selectedItem.toCountryStringOnly()
                  : selectedItem.toString()),
            ),
          ),
          if (widget.isDownIcon == true)
            Flexible(
              child: Icon(Icons.keyboard_arrow_down),
            )
        ],
      ),
    );
  }
}
