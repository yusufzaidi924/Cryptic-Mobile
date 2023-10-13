import 'package:edmonscan/config/theme/dark_theme_colors.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';

class StateSelector extends StatefulWidget {
  const StateSelector({
    super.key,
    this.initialState,
    required this.onChange,
  });
  final String? initialState;
  final Function onChange;

  @override
  _StateSelectorState createState() => _StateSelectorState();
}

class _StateSelectorState extends State<StateSelector> {
  String selectedState = "Alabama";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialState != null) {
      setState(() {
        selectedState = widget.initialState!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LightThemeColors.primaryColor, width: 2),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedState,
        hint: Text('Select a state'),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              selectedState = value;
            });
            widget.onChange(value);
          }
        },
        underline: Container(), // Set the underline to an empty Container
        items: <String>[
          'Alabama',
          'Alaska',
          'Arizona',
          'Arkansas',
          'California',
          'Colorado',
          'Connecticut',
          'Delaware',
          'Florida',
          'Georgia',
          'Hawaii',
          'Idaho',
          'Illinois',
          'Indiana',
          'Iowa',
          'Kansas',
          'Kentucky',
          'Louisiana',
          'Maine',
          'Maryland',
          'Massachusetts',
          'Michigan',
          'Minnesota',
          'Mississippi',
          'Missouri',
          'Montana',
          'Nebraska',
          'Nevada',
          'New Hampshire',
          'New Jersey',
          'New Mexico',
          'New York',
          'North Carolina',
          'North Dakota',
          'Ohio',
          'Oklahoma',
          'Oregon',
          'Pennsylvania',
          'Rhode Island',
          'South Carolina',
          'South Dakota',
          'Tennessee',
          'Texas',
          'Utah',
          'Vermont',
          'Virginia',
          'Washington',
          'West Virginia',
          'Wisconsin',
          'Wyoming'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
