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
    _items = [
      Fish(
        id: '1',
        name: 'Betta Halfmoon Blue Rim',
        price: 350000,
        location: 'Bandung, Jawa Barat',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCYRQ5DP9I_XaSVAIqaVQrLnpEWsexRYTnMn8FDC9u2THuZDf8M948MmhDWklOsv-Ezk9S8ZdmW6NJGZER_6g44KhMfHeBMPnSJ7NHQ2Ee0K5qOSSipuBc6PIQMgyZPR_mWX5cCPi-AlIXz1Ggm6Qjk7FxpXfdWhrU-UPCKK-Km3MRMZiTLWTbKBTQplbYqO1NnrsYzQZjS8EcOS2C45EugLmn1Je8RQ90O7gR9hiXVC7gr3CVlIcMaB-YgJNoCWjyZ3BFAIonkjoA',
        category: 'Betta',
        description: 'Ikan sehat, lincah, mental bagus. Ekor mekar sempurna 180 derajat.',
      ),
      Fish(
        id: '2',
        name: 'Goldfish Oranda Jumbo',
        price: 750000,
        location: 'Sleman, Yogyakarta',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDTDkN0sTR4Z7Q91U3VrKFJ3LMWSNgeQGLaPRio8DiVmOqGQWgPCjw4QW40hZ5OcjnrfrCnsD6205fmkaOSzIr4kLwX3p9u5I4EywBDbWYRnhSf1WZTgfYetKH0IuEZTPr-1KobNmHBLW092asgwAtATvEZUUzLtx0TDukj_pM1FjxA9vbWi7kN1DuXMFStZ7cuT_f5Xdf6Gq7ilYWLPjFd3Y6vaKj9aryjl9NfGn1jcb7ayPMUva2G9pEzRazdFQ3FPvdCdONQ8Ho',
        category: 'Goldfish',
      ),
      Fish(
        id: '3',
        name: 'Discus Pigeon Blood',
        price: 425000,
        location: 'Malang, Jawa Timur',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB74XVDo1Zm75ugaDuzH5hxEW5tH4So2dXEkuEnFKHy5aubgCVo4Oc8O3wGKgSrYM3InkuhRJZeYywEGX8olxmtypBOQO3rQQVxH0xf54txjJgxKsvy8mIhWE8pLWRmA4l4sa6v6hYjBqn7RkZtnlcZmrpVSCPL6ZqyuZU-aF_4dbVdoam0-s-aazL-QDcGJ_Pe_d5f8iqyok9f8zUgLpBV94XoohUpKsGEWR9sP3QBfte1cAP7LjU6YLV5x8pxGYK-9jjQBex_98M',
        category: 'Discus',
      ),
      Fish(
        id: '4',
        name: 'Kohaku Koi Grade A',
        price: 1200000,
        location: 'Blitar, Jawa Timur',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZ1pWJArDH313c6oWk9GsuiTGXQGXgnr3zYv-BBlyEFek5eQvAkGCrUBGo6a7bmoF9jF11I-1w7tuuNLc9GsJaKZIXRTZ4v9jPP2VDllNa8kv-_npw9ok0cog6dY3n7Iu2SLiAw82f39vsF8DdJhdwwhpXZRTswFqtYqot7jmWtS6ImDg0aNvv9KrQWcRXxfykL4rdK_PzjZezwh1N8ONjlIjUWSkwFqkr1STotokkB7COikRhTXyJBAA5t62pQcChrl0zpUcliww',
        category: 'Koi',
      ),
      Fish(
        id: '5',
        name: 'Cupang Halfmoon Blue Rim',
        price: 150000,
        location: 'Bogor, Jawa Barat',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDYMrJQ7JE9rFmXKRO3NHEnKQWNdqgwcCTolOt7sHi8kEEqL2sFMHlfm09Dsv31IxWn086aGX53cxm1S62n0TCEpCq-S0hoq9yIl2Ovsi9geWOQcrbbo4suTcSGnrp-g1f2PP5eX8de4zA7WXGlSzvcxWkJUh2olEukR4QNooqRD-VeRMb66dRdgXQhw-DQzH_ccA2dl2nvRO1AC5wPPCfy3P_MyRDCwojYaSKr5W3XNNmg0JvUKT47bjmLIAcOAxraBtkDCVW-3ag',
        category: 'Betta',
        isMine: true,
        views: 124,
        sellerName: 'Budi Setiawan',
      ),
      Fish(
        id: '6',
        name: 'Arwana Golden Red Pekanbaru',
        price: 2500000,
        location: 'Bogor, Jawa Barat',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1T5DLNykcXwjwefSjzS-LlmEdLjHnrAelNz1_Yz0-Ek3GGlPGWvUt2gpRboOI2x1YhsEi4t6YctbiOpxQJYWU3SaffxXvVxEx25jZn-nYZ9EPGKAOrkzeRceWz2wnUuUYgLMWd-yEcCrHdI6vJDVbopt7Q9HEQdGX_GMsAvyYKAjZMu9Zszmw9Y1BpUZgWeOjxyUKTleiYkTrLtOhIXf6LXhMYLI0qQDORvN6oowie-kYuhu8M7YPZ6oor7HLmKVtgelR9aU30pI',
        category: 'Arwana',
        isMine: true,
        views: 892,
        sellerName: 'Budi Setiawan',
      ),
       Fish(
        id: '7',
        name: 'Blue Rim Betta - Grade A+ Thailand Import',
        price: 1250000,
        location: 'Jakarta',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAGB9Ew4jX25WIZ0VeHmixaFzPyKw8hr4cax2zPWM00oF0VizKIzN8_gtMPt_FC1WiwKmNCaTDWRCae9xvjT0hLNPcrTTkc-d13Qw9ba5KCg6I3BvZALfATUviDuobwsrFNyhE-blz2cKBQk_j8wcxZVKBH0qZvwZh37Uh4iUgJLEPnBGOmmFU2gn5_SWWq0YCK5NoAaFBL6J0i3qNwZIVXisy_CdktFb1KJ_d7HqgHGwY5VQhJxWpBXTUMT_W1W0p8Mlf4zXN0CuI',
        category: 'Betta',
        description: 'Ikan hias Blue Rim Betta kualitas kontes. Warna rim biru sangat tegas dan bersih, badan putih mutiara tanpa noda (clean body). Ikan sangat aktif, mental petarung (galak), dan dalam kondisi kesehatan yang prima.',
        sellerName: 'AquaExotic Store',
        sellerImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDr2JFw24DSdfPriEV12tWE74YLlm95HwN-eYhyBuK7LfPUHBjjaFVprfD2x8OdmlT7655-Zujo8zLK_51W_0NoA7-Y1kIsr9k4cEV92s2MtJPLPDmmSA2xhGpi_i_wBtGhezzjYSwz2hkLUEsiWpxPvOEweherRwqPJvOtP_AKSjnzlglg6FDna2oeQtvT2KOf2H97F_5-4W9jiDwwEfr-hwJc2oNfs6qbNLJGHn36qGTVUgdKE2CntcwkYSRjEtH0o_KzEqtfVyc',
        breed: 'Halfmoon Betta',
        age: '4.5 Months',
      ),
    ];
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
