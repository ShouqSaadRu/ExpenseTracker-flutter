import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //من هنا نبدأ بناء الايتم وجعله قابل للحذف
      //scrollable and builder is to make sure that the items are only created when needed
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        //to swibe the item(expense) and be removed
        key: ValueKey(expenses[index]),
        background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(
                0.75), //لما أسحب عاليمين عشان احذف فالخلفية بتصير حمرا
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            ) //نحط المارجن نفس حق الكارد.......الكارد اقصد expense item
            ),
        onDismissed: (direction) {
          //direction here means the swibe do you want swibe from left to right or from right to left
          onRemoveExpense(expenses[index]);
        }, //it trigord when an expense is removed
        child: ExpenseItem(expenses[index]),
      ), //if length is 2 at item count then  ""(ctx, index) => Text(expenses[index].title)"" will be called 2 times
    );
  }
}
