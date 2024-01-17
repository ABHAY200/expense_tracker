import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

const category = ['food', 'travel', 'sports', 'emi', 'others'];

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _AddExpense();
  }
}

class _AddExpense extends State<AddExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  var _selectedCategory = category[0];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: startDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enterAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enterAmount == null || enterAmount <= 0;
    if (amountIsInvalid ||
        _selectedDate == null ||
        _titleController.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
                title: Text('Invalid data'),
                actions: [TextButton(onPressed: null, child: Text('okay'))],
              ));
    } else {
      widget.onAddExpense(Expense(
          title: _titleController.text,
          amount: enterAmount,
          date: _selectedDate!,
          category: Category.food));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Center(
        child: Container(
            height: 400.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Add new'),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: category.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 30,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text('Amount')),
                ),
                TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(_selectedDate == null
                        ? 'Select Date'
                        : formatter.format(_selectedDate!))),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save'))
                  ],
                )
              ],
            ))));
  }
}
