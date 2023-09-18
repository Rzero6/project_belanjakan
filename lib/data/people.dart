//* 1. Kelas Person
class Person {
  final String name;
  final String phone;
  final String picture;
  const Person(this.name, this.phone, this.picture);
}

//* 2. Variabel List dengan nama people yan memiliki data bertipe object Person, yang merupakan
//* hasil mapping data list pada baris 14 kebawah
final List<Person> people = _people
    .map((e) => Person(
        e['name'] as String, e['phone'] as String, e['picture'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "name": "Reynold Kunarto",
    "gender": "female",
    "email": "desireechandler@obliq.com",
    "phone": "+1 (962) 552-3420"
  },
  {
    "name": "Person 2",
    "gender": "female",
    "email": "desireechandler@obliq.com",
    "phone": "+1 (962) 552-3420"
  },
  {
    "name": "Person 3",
    "gender": "female",
    "email": "desireechandler@obliq.com",
    "phone": "+1 (962) 552-3420"
  },
  {
    "name": "Person 4",
    "gender": "female",
    "email": "desireechandler@obliq.com",
    "phone": "+1 (962) 552-3420"
  },
  {
    "name": "Person 5",
    "gender": "female",
    "email": "desireechandler@obliq.com",
    "phone": "+1 (962) 552-3420"
  },
];
