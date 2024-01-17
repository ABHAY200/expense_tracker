import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/addExpense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Dinner',
        amount: 80,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Turf',
        amount: 120,
        date: DateTime.now(),
        category: Category.sports),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return (AddExpense(onAddExpense: _addExpense));
        });
  }

  void _addExpense(Expense expense) {
    print('_addExpense');
    setState(() {
      _registeredExpenses.add(expense);
    });
    Navigator.pop(context);
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3), content: Text('Expense deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: _openAddExpenseOverlay, child: const Text('add'))
          ],
        ),
        body: ExpensesList(
            expenses: _registeredExpenses, removeExpense: _removeExpense)));
  }
}

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;
  void _onRemoveExpense(Expense expense) {
    removeExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    return (ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            onDismissed: (direction) {
              _onRemoveExpense(expenses[index]);
            },
            child: ExpensesItem(expenseItem: expenses[index]))));
  }
}

class ExpensesItem extends StatelessWidget {
  const ExpensesItem({super.key, required this.expenseItem});

  final Expense expenseItem;

  @override
  Widget build(BuildContext context) {
    return (Container(
        width: 200.0,
        height: 130.0,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(expenseItem.title),
            Text(expenseItem.category.toString()),
            Text(expenseItem.amount.toString()),
            Text(expenseItem.formattedDate)
          ],
        )));
  }
}
