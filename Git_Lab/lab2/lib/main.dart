
// import 'async';

void main() async {
  print('=== EXERCISE 1: Basic Syntax & Data Types ===');
  exercise1();

  print('\n=== EXERCISE 2: Collections & Operators ===');
  exercise2();

  print('\n=== EXERCISE 3: Control Flow & Functions ===');
  exercise3();

  print('\n=== EXERCISE 4: Intro to OOP ===');
  exercise4();

  print('\n=== EXERCISE 5: Async, Future, Null Safety & Streams ===');
  await exercise5();
}

// ------------------------------------------
// EXERCISE 1: Basic Syntax & Data Types
// ------------------------------------------
void exercise1() {
  // Declaring core data types
  int age = 22;
  double height = 1.70;
  String name = 'Bui Duong';
  bool isStudent = true;

  // Output using string interpolation ($var and ${expr})
  print('Name: $name');
  print('Age: $age');
  print('Height: ${height}m');
  print('Is a student: $isStudent');
  print('Next year age: ${age + 1}');
}

// ------------------------------------------
// EXERCISE 2: Collections & Operators
// ------------------------------------------
void exercise2() {
  // List manipulation
  List<int> numbers = [10, 20, 30, 40];
  numbers.add(50);
  print('List of numbers: $numbers');
  print('First element: ${numbers[0]}');

  // Arithmetic & Comparison operators
  int sum = numbers[0] + numbers[1];
  bool isGreater = numbers[3] > numbers[2] && sum == 30;
  String resultMessage = isGreater ? 'Condition met' : 'Condition not met';
  print('Sum of first two: $sum');
  print('Ternary evaluation: $resultMessage');

  // Set (unique values)
  Set<String> uniqueTags = {'dart', 'flutter', 'dart'}; // Duplicate 'dart' is ignored
  uniqueTags.add('mobile');
  uniqueTags.remove('flutter');
  print('Unique tags Set: $uniqueTags');

  // Map (key-value pairs)
  Map<String, dynamic> userProfile = {
    'username': 'coder123',
    'score': 95,
  };
  userProfile['role'] = 'admin'; // Add key-value
  print('User profile Map: $userProfile');
  print('Username: ${userProfile['username']}');
}

// ------------------------------------------
// EXERCISE 3: Control Flow & Functions
// ------------------------------------------
void exercise3() {
  int score = 85;

  // 1. If/Else condition
  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');
  } else {
    print('Grade: C');
  }

  // 2. Switch statement
  String day = 'Monday';
  switch (day) {
    case 'Monday':
      print('Start of the work week.');
      break;
    case 'Friday':
      print('Weekend is near!');
      break;
    default:
      print('Midweek or weekend.');
  }

  // 3. Loops through collections
  List<String> fruits = ['Apple', 'Banana', 'Cherry'];

  print('-- Standard For Loop --');
  for (int i = 0; i < fruits.length; i++) {
    print('Fruit $i: ${fruits[i]}');
  }

  print('-- For-In Loop --');
  for (var fruit in fruits) {
    print('Item: $fruit');
  }

  print('-- ForEach Loop --');
  fruits.forEach((fruit) => print('Lambda item: $fruit'));

  // 4. Function invocations
  print('Standard function call (5 + 3): ${addNumbers(5, 3)}');
  print('Arrow function call (4 * 2): ${multiplyNumbers(4, 2)}');
}

// Standard Function
int addNumbers(int a, int b) {
  return a + b;
}

// Arrow Function Syntax
int multiplyNumbers(int a, int b) => a * b;

// ------------------------------------------
// EXERCISE 4: Intro to OOP
// ------------------------------------------
// Base Class
class Car {
  String brand;

  // Default Constructor
  Car(this.brand);

  // Named Constructor
  Car.unknown() : brand = 'Generic Brand';

  void drive() {
    print('Driving a $brand car.');
  }
}

// Subclass demonstrating Inheritance & Method Overriding
class ElectricCar extends Car {
  int batteryCapacity;

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print('Driving an electric $brand with ${batteryCapacity}kWh battery silently.');
  }
}

void exercise4() {
  // Object instantiation
  Car regularCar = Car('Toyota');
  Car unknownCar = Car.unknown();
  ElectricCar myEV = ElectricCar('Tesla', 75);

  // Invoking methods
  regularCar.drive();
  unknownCar.drive();
  myEV.drive(); // Overridden method call
}

// ------------------------------------------
// EXERCISE 5: Async, Future, Null Safety & Streams
// ------------------------------------------
Future<void> exercise5() async {
  // 1. Null Safety Practice
  String? nullableName; // Can hold null
  print('Nullable name initial value: $nullableName');

  // Null-coalescing operator (??)
  String displayName = nullableName ?? 'Guest User';
  print('Display Name: $displayName');

  // Null-aware assignment (??=)
  nullableName ??= 'Default Alice';
  print('Assigned nullable name: $nullableName');

  // Null assertion operator (!) - used when certain non-null
  String forcedName = nullableName!;
  print('Length of forced name: ${forcedName.length}');

  // 2. Async/Await and Future simulation
  print('\nFetching data asynchronously...');
  String fetchedData = await fetchUserData();
  print('Async Result: $fetchedData');

  // 3. Simple Stream demonstration
  print('\nListening to integer Stream:');
  await for (int value in countStream(3)) {
    print('Stream emitted: $value');
  }
}

// Simulated Async Network Request
Future<String> fetchUserData() async {
  // Simulate delay using Future.delayed
  await Future.delayed(Duration(seconds: 1));
  return 'User payload loaded successfully.';
}

// Integer Stream generator
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i; // Emits value to stream
  }
}