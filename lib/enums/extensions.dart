// ignore_for_file: unused_element

import 'package:flutter/material.dart';

extension Sliver on Widget {
  Widget get sliverBox {
    return SliverToBoxAdapter(child: this);
  }
}
