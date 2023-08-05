import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd(); //intl package

const uuid = Uuid();

enum Category { food, travel, leisure, work } //predefined values

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.amount,
    required this.title,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); //v4 generate a unique string id

  final String
      id; //we will generate unique ids for every expense so we will yse uuid package to generate automatically
  final String title;
  final double amount;
  final DateTime date; //allows us to store date information in a single value
  final Category
      category; //ممكن تحصل اخطاء املائية فعشان نتفاداها نستخدم type enum

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  //making chart one for each category
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses,
      this.category) //additional constructre function //it will go throw all the expense list and filter it to take only which belong to this category
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      //to tell flutter that we wanna go throuhg all the items in the expenses list and in every new iteration a nwe item will be picked and stored in the expense variable
      sum += expense.amount;
    }

    return sum;
  }
}
