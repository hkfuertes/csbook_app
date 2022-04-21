import 'package:flutter/material.dart';

class SearchRow extends StatelessWidget {
  Function(String)? onChange;
  Function? onClose;
  TextEditingController? searchController;
  SearchRow({Key? key, this.onChange, this.onClose, this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            textAlignVertical: TextAlignVertical.center,
            onChanged: onChange,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
              hintText: "Filtrar",
            ),
          ),
        ),
        if (searchController?.text != "")
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                searchController?.clear();
                if (onClose != null) {
                  onClose!();
                }
              },
              icon: const Icon(Icons.close))
      ],
    );
  }
}
