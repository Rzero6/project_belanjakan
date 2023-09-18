//* 1. Kelas Person
class Person {
  final String name;
  final String npm;
  final String picture;
  final String email;
  const Person(this.name, this.npm, this.picture, this.email);
}

//* 2. Variabel List dengan nama people yan memiliki data bertipe object Person, yang merupakan
//* hasil mapping data list pada baris 14 kebawah
final List<Person> people = _people
    .map((e) => Person(e['name'] as String, e['npm'] as String,
        e['picture'] as String, e['email'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "name": "Reynold Kunarto",
    "picture": "https://picsum.photos/200",
    "email": "210711015@students.uajy.ac.id",
    "npm": "210711015"
  },
  {
    "name": "Yohanes Krisostomus Brahmantya",
    "picture": "https://picsum.photos/200",
    "email": "210711282@students.uajy.ac.id",
    "npm": "210711282"
  },
  {
    "name": "Hans Timotius Junior Sitepu",
    "picture": "https://picsum.photos/200",
    "email": "200710903@students.uajy.ac.id",
    "npm": "200710903"
  },
  {
    "name": "Angel",
    "picture": "https://picsum.photos/200",
    "email": "210711280@students.uajy.ac.id",
    "npm": "210711280"
  },
  {
    "name": "Daniel Natalius Christopper",
    "picture": "https://picsum.photos/200",
    "email": "210711346@students.uajy.ac.id",
    "npm": "210711346"
  },
];
