import 'package:flutter/material.dart';
import '../models/goal_model.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class TodoItem {
  final String id;
  String title;
  DateTime? date;
  String notes;
  String repeat;
  String tag;
  String? goalName;
  bool completed;

  TodoItem({
    required this.id,
    required this.title,
    this.date,
    this.notes = '',
    this.repeat = 'Never',
    this.tag = '',
    this.goalName,
    this.completed = false,
  });
}

class EventItem {
  final String id;
  String title;
  DateTime? date;
  String startTime;
  String endTime;
  String location;
  bool notification;
  String repeat;
  String tag;

  EventItem({
    required this.id,
    required this.title,
    this.date,
    this.startTime = '',
    this.endTime = '',
    this.location = '',
    this.notification = true,
    this.repeat = 'Never',
    this.tag = '',
  });
}

// ── App State singleton ───────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  final List<TodoItem> todos = [];
  final List<EventItem> events = [];
  final List<GoalModel> goals = List.from(sampleGoals);

  int _idCounter = 0;
  String _nextId() => 'item_${++_idCounter}';

  // ── Todos ──────────────────────────────────────────────────────────────────
  void addTodo(TodoItem item) {
    todos.add(item);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final idx = todos.indexWhere((t) => t.id == id);
    if (idx != -1) {
      todos[idx].completed = !todos[idx].completed;
      notifyListeners();
    }
  }

  TodoItem createTodo({
    required String title,
    DateTime? date,
    String notes = '',
    String repeat = 'Never',
    String tag = '',
    String? goalName,
  }) {
    return TodoItem(
      id: _nextId(),
      title: title,
      date: date,
      notes: notes,
      repeat: repeat,
      tag: tag,
      goalName: goalName,
    );
  }

  // ── Events ─────────────────────────────────────────────────────────────────
  void addEvent(EventItem item) {
    events.add(item);
    notifyListeners();
  }

  EventItem createEvent({
    required String title,
    DateTime? date,
    String startTime = '',
    String endTime = '',
    String location = '',
    bool notification = true,
    String repeat = 'Never',
    String tag = '',
  }) {
    return EventItem(
      id: _nextId(),
      title: title,
      date: date,
      startTime: startTime,
      endTime: endTime,
      location: location,
      notification: notification,
      repeat: repeat,
      tag: tag,
    );
  }

  // ── Goals ──────────────────────────────────────────────────────────────────
  void addGoal(GoalModel goal) {
    goals.add(goal);
    notifyListeners();
  }

  /// Get all todos that belong to a specific goal name
  List<TodoItem> todosForGoal(String goalName) =>
      todos.where((t) => t.goalName == goalName).toList();

  /// Get todos for a specific date
  List<TodoItem> todosForDate(DateTime date) => todos
      .where((t) =>
          t.date != null &&
          t.date!.year == date.year &&
          t.date!.month == date.month &&
          t.date!.day == date.day)
      .toList();

  /// Get events for a specific date
  List<EventItem> eventsForDate(DateTime date) => events
      .where((e) =>
          e.date != null &&
          e.date!.year == date.year &&
          e.date!.month == date.month &&
          e.date!.day == date.day)
      .toList();
}
