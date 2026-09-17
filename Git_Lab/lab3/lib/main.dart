// ==========================================
// LAB 3: ADVANCED DART PRACTICE EXERCISES
// ==========================================

import 'dart:async';
void main() async {
  print('=== EXERCISE 1: Product Model & Repository ===');
  await exercise1();

  print('\n=== EXERCISE 2: User Repository with JSON ===');
  await exercise2();

  print('\n=== EXERCISE 3: Async + Microtask Debugging ===');
  exercise3();
  // Brief delay to allow Event Loop and Microtask queue to complete before proceeding
  await Future.delayed(Duration(milliseconds: 100));

  print('\n=== EXERCISE 4: Stream Transformation ===');
  await exercise4();

  print('\n=== EXERCISE 5: Factory Constructors & Cache ===');
  exercise5();
}

// ------------------------------------------
// EXERCISE 1: Product Model & Repository
// ------------------------------------------
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 'p1', name: 'Laptop', price: 999.99),
    Product(id: 'p2', name: 'Mouse', price: 25.00),
  ];

  // Broadcast controller to emit new real-time additions
  final StreamController<Product> _streamController = StreamController<Product>.broadcast();

  // Async fetch returning product list via Future
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 200)); // Simulate network latency
    return List.from(_products);
  }

  // Stream getter for real-time updates
  Stream<Product> liveAdded() => _streamController.stream;

  // Method to insert product and emit it to active listeners
  void addProduct(Product product) {
    _products.add(product);
    _streamController.add(product);
  }

  void dispose() {
    _streamController.close();
  }
}

Future<void> exercise1() async {
  final repo = ProductRepository();

  // Listen to stream BEFORE adding new products
  final subscription = repo.liveAdded().listen((product) {
    print('[Stream Notification] Real-time item added: $product');
  });

  // Fetch initial list
  List<Product> initialList = await repo.getAll();
  print('Initial Product Catalog: $initialList');

  // Trigger real-time stream emissions
  repo.addProduct(Product(id: 'p3', name: 'Keyboard', price: 75.50));
  repo.addProduct(Product(id: 'p4', name: 'Monitor', price: 210.00));

  await Future.delayed(Duration(milliseconds: 100));
  subscription.cancel();
  repo.dispose();
}

// ------------------------------------------
// EXERCISE 2: User Repository with JSON
// ------------------------------------------
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor for deserialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Simulated JSON string response from an API
  final String _rawApiResponse = '''
  [
    {"name": "Alice Johnson", "email": "alice@example.com"},
    {"name": "Bob Smith", "email": "bob@example.com"}
  ]
  ''';

  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(milliseconds: 200));

    // Simulated parsing step (equivalent to jsonDecode)
    List<Map<String, dynamic>> parsedList = [
      {"name": "Alice Johnson", "email": "alice@example.com"},
      {"name": "Bob Smith", "email": "bob@example.com"}
    ];

    // Map each JSON object to a User instance
    return parsedList.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> exercise2() async {
  final userRepo = UserRepository();
  print('Fetching users from simulated API...');
  List<User> users = await userRepo.fetchUsers();
  
  for (var user in users) {
    print('Parsed User: $user');
  }
}

// ------------------------------------------
// EXERCISE 3: Async + Microtask Debugging
// ------------------------------------------
void exercise3() {
  print('Start of main execution (Synchronous)');

  // 1. Scheduled on the Event Queue
  Future(() {
    print('Event Queue Callback 1 (Future)');
  });

  // 2. Scheduled on the Microtask Queue
  scheduleMicrotask(() {
    print('Microtask Queue Callback 1');
  });

  // 3. Another Microtask
  scheduleMicrotask(() {
    print('Microtask Queue Callback 2');
  });

  // 4. Another Event Queue item
  Future(() {
    print('Event Queue Callback 2 (Future)');
  });

  print('End of main execution (Synchronous)');

  /* 
   * EXPLANATION OF EXECUTION ORDER:
   * 1. Synchronous code executes first ("Start...", "End...").
   * 2. The Dart Event Loop prioritizes the Microtask Queue over the Event Queue.
   * 3. All items in the Microtask Queue complete before processing the next event from the Event Queue.
   * 4. Therefore, Microtasks 1 & 2 run before Event Queue Futures 1 & 2.
   */
}

// ------------------------------------------
// EXERCISE 4: Stream Transformation
// ------------------------------------------
Future<void> exercise4() async {
  // Source stream emitting numbers 1 through 5
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Functional transformation pipeline
  Stream<int> processedStream = numberStream
      .map((num) => num * num)      // Square each value: 1, 4, 9, 16, 25
      .where((square) => square.isEven); // Filter even squares: 4, 16

  print('Emitting transformed stream values (squared & even filtered):');
  await for (int value in processedStream) {
    print('Stream value received: $value');
  }
}

// ------------------------------------------
// EXERCISE 5: Factory Constructors & Cache
// ------------------------------------------
class Settings {
  final String theme;
  final bool notificationsEnabled;

  // Internal cache map
  static final Map<String, Settings> _cache = {};

  // Private named constructor
  Settings._internal(this.theme, this.notificationsEnabled);

  // Factory constructor returning singleton / cached instance
  factory Settings({String theme = 'dark', bool notificationsEnabled = true}) {
    String key = '$theme-$notificationsEnabled';
    
    // Return existing instance if cached, otherwise instantiate new one
    return _cache.putIfAbsent(
      key, 
      () => Settings._internal(theme, notificationsEnabled)
    );
  }
}

void exercise5() {
  // Creating multiple instances with identical parameters
  Settings configA = Settings(theme: 'dark', notificationsEnabled: true);
  Settings configB = Settings(theme: 'dark', notificationsEnabled: true);
  Settings configC = Settings(theme: 'light', notificationsEnabled: false);

  print('configA theme: ${configA.theme}');
  print('configB theme: ${configB.theme}');

  // Verification using identical()
  bool isSameInstance = identical(configA, configB);
  print('Are configA and configB identical instances? $isSameInstance'); // true

  bool isDifferentInstance = identical(configA, configC);
  print('Are configA and configC identical instances? $isDifferentInstance'); // false
}