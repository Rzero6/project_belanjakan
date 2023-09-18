//* 1. Kelas Person
class Person {
  final String name;
  final String npm;
  final String picture;
  final String email;
  const Person(this.name, this.npm, this.picture,this.email);
}

//* 2. Variabel List dengan nama people yan memiliki data bertipe object Person, yang merupakan
//* hasil mapping data list pada baris 14 kebawah
final List<Person> people = _people
    .map((e) => Person(
        e['name'] as String, e['npm'] as String, e['picture'] as String,e['email'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "name": "Reynold Kunarto",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
  {
    "name": "Tito",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
  {
    "name": "Hans",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
  {
    "name": "Angel",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
  {
    "name": "Daniel",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
];
