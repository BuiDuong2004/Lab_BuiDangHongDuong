class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void startEngine(){
    print("Phuong tien khoi dong");
  }
}

class Car extends Vehicle{
  bool isElectric;

  Car(String brand, int year, this.isElectric) : super(brand, year);

  // Viết Named Constructor: Car.tesla(int year) thiết lập sẵn brand="Tesla" và isElectric=true.
  Car.tesla(int year)
      : isElectric = true,
        super('Tesla', year);

  @override
  void startEngine(){
    if(isElectric){
      print('${brand} - ${year} khởi động bằng động cơ điện');
    } else {
      print('${brand} - ${year} khởi động bằng động cơ khác');
    }
  }
}

void main(){
  Car car = Car('Toyota',2000,false);
  car.startEngine();

  Car teslaCar = Car.tesla(2024);
  teslaCar.startEngine();
}