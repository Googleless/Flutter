class Philip {
  String name;
  int age;

  Philip(this.name, this.age);

  void introduce() {
    print("Меня зовут $name, мне $age лет.");
    _displayPrivateMessage();
  }

  void sayHello() {
    print("Привет всем!");
  }

  void _displayPrivateMessage() {
    print("Это скрытое сообщение из родительского класса.");
  }
}

class Child extends Philip {
  String hobby;

  Child(String name, int age, this.hobby) : super(name, age);

  @override
  void introduce() {
    super.introduce();
    print("Моё хобби: $hobby.");
  }

  static void displayChildInfo() {
    print("Этот класс используется для описания детей.");
  }
}

void main() {
  Philip parent = Philip("Филипп", 19);
  parent.introduce();
  parent.sayHello();

  print("\n");

  Child child = Child("Ваня", 1, "рисование");
  child.introduce();
  child.sayHello();

  print("\n");

  Child.displayChildInfo();
}
