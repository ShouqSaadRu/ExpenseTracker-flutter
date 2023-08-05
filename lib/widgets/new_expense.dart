import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController =
      TextEditingController(); //creates objects that optemized for handling user input and objects that can be passed to TextField() to let flutter do all the heavy lifting of storing enterd value and so on
  final _amountCintroller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        //async and await that means they will be excuted in the future when the user picks a date
        context:
            context, //it means flutter should be wait before it store a value in the variable pickedDate
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          //styling only for ios
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
    } else {
      //for android
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
    }
  }

  void _submitExpenseData() {
    //to ensure that the enterd data are valid
    final enterdAmount = double.tryParse(_amountCintroller.text);
    final amountIsINValid =
        enterdAmount == null || enterdAmount <= 0; //note invalid not valid
    if (_titleController.text
            .trim()
            .isEmpty || //trim it removes the white space
        amountIsINValid ||
        _selectedDate == null) {
      _showDialog();

      return; //to make sure that no code is excuted after if we enterd the if statement in line 41
    }

    widget.onAddExpense(Expense(
        amount: enterdAmount,
        title: _titleController.text,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(
        context); //to close the window automatically after adding an expense
  }

  @override
  void dispose() {
    //important with TextEditingController() above
    _titleController
        .dispose(); //to tell flutter that this controller is not needed anymore
    _amountCintroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //i get any extra UI elements that are overlaping the ui from bottom الكيبورد يغطي على بعض الاشياء لما اميل الشاشة
    return LayoutBuilder(builder: (ctx, contraints) {
      //it cares about its parent widget not the entirly available screen size
      final width = contraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength:
                              50, //maximum amount of characters that can be input by user
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        //it better used here to make sure that the text takes place as much as it can get in the screen
                        child: TextField(
                          controller: _amountCintroller,
                          keyboardType: TextInputType
                              .number, //note that the keyboard changes when i move from title to amount it changes from alpha to numbers
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength:
                        50, //maximum amount of characters that can be input by user
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value:
                              _selectedCategory, //to ensure that the selected category will be shown in the screen
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  // //it renders a bottun for choosing a category and => after it, will be the returned value
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        //cuz we have a row inside a row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, //to push the date to the Right
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date Selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        //it better used here to make sure that the text takes place as much as it can get in the screen
                        child: TextField(
                          controller: _amountCintroller,
                          keyboardType: TextInputType
                              .number, //note that the keyboard changes when i move from title to amount it changes from alpha to numbers
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        //cuz we have a row inside a row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, //to push the date to the Right
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date Selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                          //the user entered in the input field
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'))
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value:
                              _selectedCategory, //to ensure that the selected category will be shown in the screen
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  // //it renders a bottun for choosing a category and => after it, will be the returned value
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                          //the user entered in the input field
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'))
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
