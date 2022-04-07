import 'package:flutter/material.dart';
import 'package:iexplore/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          const Text("Please wait a few minutes ...")
        ],
      ),
    );
  }
}
