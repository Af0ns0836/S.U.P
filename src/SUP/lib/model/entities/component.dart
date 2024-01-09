class Component{
  int id;
  String name;
  double grade;
  double weight;
  int subject_id;

  Component(
      {int this.id,
      String this.name,
      double this.grade,
      double this.weight,
      int this.subject_id});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'grade': grade,
      'weight': weight,
      'subject_id': subject_id
    };
  }

  @override
  bool operator ==(Object other) {
    if(other is Component){
      return other.id == this.id;
    }
    return false;
  }
}