import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../elevated_container.dart';

class FilterToggleButton<TValue> extends StatelessWidget {
  const FilterToggleButton({
    Key? key,
    required bool isSelected,
    required Function(TValue?) onTapped,
    required Widget child,
    TValue? value,
  })  : _value = value,
        _isSelected = isSelected,
        _onTapped = onTapped,
        _child = child,
        super(key: key);

  final TValue? _value;
  final bool _isSelected;
  final Function(TValue?) _onTapped;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    if (_isSelected) {
      return Expanded(
        child: ElevatedContainer(
          backgroundColor: AppColors.accentColor,
          child: _child,
        ),
      );
    }

    return Expanded(
      child: InkWell(
        child: _child,
        onTap: () => _onTapped(_value),
      ),
    );
  }
}
