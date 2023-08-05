import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: const Color.fromARGB(255, 71, 1,
                      77))), //.copywith() it maches the main title above (look at main.dart) in size but i changed the color so it doesn't match theme colors
          //tho it better not to put .copywith so that we have a color that fit well with the theme that given by flutter

          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              //if i don't want to add $  : Text(expense.amount.toStringAsFixed(2)), // 12.3433 => 12.34
              Text('\$${expense.amount.toStringAsFixed(2)}'),
              const Spacer(), //it will push the text (above) to left and the Row (down) to right
              Row(
                children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(expense.formattedDate),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}
