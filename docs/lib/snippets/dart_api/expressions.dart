import 'package:drift/drift.dart';

import '../_shared/todo_tables.dart';
import '../_shared/todo_tables.drift.dart';

extension Snippets on CanUseCommonTables {
  // #docregion emptyCategories
  Future<List<Category>> emptyCategories() {
    final hasNoTodo = notExistsQuery(select(todoItems)
      ..where((row) => row.category.equalsExp(categories.id)));
    return (select(categories)..where((row) => hasNoTodo)).get();
  }
  // #enddocregion emptyCategories

  void queries() {
    // #docregion date1
    select(users).where((u) => u.birthDate.year.isSmallerThanValue(1950));
    // #enddocregion date1
  }

  // #docregion date2
  Future<void> increaseDueDates() async {
    final change = TodoItemsCompanion.custom(
        dueDate: todoItems.dueDate + Duration(days: 1));
    await update(todoItems).write(change);
  }
  // #enddocregion date2

  // #docregion date3
  Future<void> moveDueDateToNextMonday() async {
    final change = TodoItemsCompanion.custom(
        dueDate: todoItems.dueDate
            .modify(DateTimeModifier.weekday(DateTime.monday)));
    await update(todoItems).write(change);
  }
  // #enddocregion date3

  // #docregion window
  /// Returns all todo items, associating each item with the total length of all
  /// titles up until (and including) each todo item.
  Selectable<(TodoItem, int)> todosWithRunningLength() {
    final runningTitleLength = WindowFunctionExpression(
      todoItems.title.length.sum(),
      orderBy: [OrderingTerm.asc(todoItems.id)],
    );
    final query = select(todoItems).addColumns([runningTitleLength]);
    query.orderBy([OrderingTerm.asc(todoItems.id)]);

    return query.map((row) {
      return (row.readTable(todoItems)!, row.read(runningTitleLength)!);
    });
  }
  // #enddocregion window

  // #docregion window2
  /// Returns all todo items, also reporting the index (counting from 1) each
  /// todo item would have if all items were sorted by descending content
  /// length.
  Selectable<(TodoItem, int)> todosWithLengthRanking() {
    final lengthRanking = WindowFunctionExpression(
      todoItems.id.count(),
      orderBy: [OrderingTerm.desc(todoItems.content.length)],
    );
    final query = select(todoItems).addColumns([lengthRanking]);

    return query.map((row) {
      return (row.readTable(todoItems)!, row.read(lengthRanking)!);
    });
  }
  // #enddocregion window2
}

// #docregion bitwise
Expression<int> bitwiseMagic(Expression<int> a, Expression<int> b) {
  // Generates `~(a & b)` in SQL.
  return ~(a.bitwiseAnd(b));
}
// #enddocregion bitwise
