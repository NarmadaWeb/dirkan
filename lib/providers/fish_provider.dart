import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dirkan/models/fish_model.dart';
import 'package:uuid/uuid.dart';

class FishProvider with ChangeNotifier {
  List<Fish> _items = [];
  bool _isLoading = false;

  List<Fish> get items => [..._items];
  List<Fish> get myItems => _items.where((item) => item.isMine).toList();
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/fish_data.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        _items = jsonList.map((item) => Fish.fromJson(item)).toList();
      } else {
        _populateInitialData();
        await _saveData();
      }
    } catch (e) {
      print('Error loading data from storage: $e');
      // Fallback: If no data loaded or error (e.g. MissingPluginException), load initial data in memory
      if (_items.isEmpty) {
        _populateInitialData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _populateInitialData() {
    // Initial data is empty so that the home screen only shows user-added sales data.
    _items = [];
  }

  Future<void> _saveData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/fish_data.json');
      final jsonString = json.encode(_items.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving data to storage: $e');
      // If saving fails (e.g. MissingPluginException), we just continue with in-memory state.
      // This ensures the app doesn't crash on actions like add/delete.
    }
  }

  Future<void> addFish(Fish fish) async {
    final newFish = fish.copyWith(id: const Uuid().v4());
    _items.add(newFish);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateFish(Fish fish) async {
    final index = _items.indexWhere((item) => item.id == fish.id);
    if (index >= 0) {
      _items[index] = fish;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteFish(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _saveData();
    notifyListeners();
  }

  Fish findById(String id) {
    return _items.firstWhere((item) => item.id == id, orElse: () => _items.first);
  }
}
