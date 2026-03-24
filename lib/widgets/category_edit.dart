import 'package:flutter/material.dart';
import 'package:todofrontendapi/services/api.dart';
import 'package:todofrontendapi/models/category.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;

  const CategoryEdit(this.category, {super.key});

  @override
  CategoryEditState createState() => CategoryEditState();
}

class CategoryEditState extends State<CategoryEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  ApiService apiService = ApiService();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    categoryNameController.text = widget.category.name;
  }

  Future saveCategory(context) async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    apiService
        .saveCategory(widget.category.id, categoryNameController.text)
        .then((dynamic response) => Navigator.pop(context))
        .catchError((error) {
          setState(() {
            errorMessage = 'Failed to update category';
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Edit Category'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Category Name'),
              controller: categoryNameController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category name';
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  errorMessage = '';
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // We have also added a Cancel button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveCategory(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
