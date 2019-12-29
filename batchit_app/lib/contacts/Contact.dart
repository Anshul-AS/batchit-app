//class for contacts details 

class Contact{
  int _id;
  String _lastname;
  String _firstname;
  String _phone;
  String _email;

  Contact(this._firstname,this._lastname,this._phone,this._email);
  Contact.withId(this._id,this._firstname,this._lastname,this._phone,this._email);

  int get id => _id;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get phone => _phone;
  String get email => _email;

  set firstname(String newname1){
    this._firstname = newname1;
  }

  set lastname(String newname2){
    this._lastname = newname2;
  }

  set phone(String phone1){
    this._phone = phone1;
  }

  set email(String email1){
    this._email = email1;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['phone'] = _phone;
    map['email'] = _email;
    return map;
  }

  Contact.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._firstname = map['firstname'];
    this._lastname = map['lastname'];
    this._phone = map['phone'];
    this._email = map['email'];
  }

}