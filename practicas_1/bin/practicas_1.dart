import 'package:practicas_1/helado';

void main(List<String> arguments) {

  saludar("Nakut");

  numerosEjemplo(5);

  stringejemplo("Hola, soy un ejemplo de texto.");

  dinamicoEjemplo(123);

  simplefuncion();

  inputFuncion(5, 10);

  funcionopcional(nombre: "Naku", age: 18);

  listaejemplo();

  mapejemplo();

  listaLoop();

  mapLoop();


  int resultado = outputfuncion(7, 3);

  // variables booleanas

  bool feliz = true;

  bool triste = false;

 
  // tipos fijos

  final String ejemplo2 = "hola soy un ejemplo fijo.";
  const String ejemplo3 = "hola soy un ejemplo constante."; // para contraseñas y otras cosas constantes

  // conversiones

  String numeroComoString = '123';
  int numeroComoEntero = int.parse(numeroComoString);
  double numeroComoDouble = double.parse(numeroComoString);
  print(numeroComoEntero);
  print(numeroComoDouble);


  int aString = 987;
  String aStringComoTexto = aString.toString();
  print(aStringComoTexto);  

}

//funciones

void saludar(String nombre){

  int edad = 18;
  print('Hola, mi nombre es $nombre y tengo $edad años' );

}

void numerosEjemplo(int numero) {
// variables numericas

  int age = 18;

  double altura = 1.75;

  num age2 = 18;
  num age3 = 18.2;

  
}

void stringejemplo(String texto) {
   // variables de cadena de texto

  String nombre = 'nakut';

  nombre = 'nahuel';
}

void dinamicoEjemplo(dynamic valor) {
  // tipo dinamico

  dynamic ejemplo = "hola soy un ejemplo.";
  print(ejemplo);

  ejemplo = 123;
  print(ejemplo);
}

/* 
 --------------------------
  
         METODOS

 --------------------------
*/

void simplefuncion() {
  print('Esta es una función simple.');
}

void inputFuncion(int a, int b) {
  int resultado = a + b;
  print('El resultado de la suma es: $resultado');
}

int outputfuncion(int a, int b) {
  int resultado = a + b;
  return resultado;
}

int funcioncompleta (int a, int b) {
  return a + b;
}

void funcionopcional({String nombre = "desconocido", int age = -1}) {

  print ('sos $nombre y tenes $age');
}

/* 
 --------------------------
  
    ESTRUCTURAS DE DATOS

 --------------------------
*/

void listaejemplo(){

  List<String> names = ["naku","juan","nacho"];
  //  print(names);
  // print(names.last);
  // print(names.first);
  // print(names.length);
  // names[2] = "mati";
  //print(names[names.length - 1]);
  // names.add("lucas");
  
  print(names);


}

void mapejemplo(){

Map<String, int> people = {

  "Naku": 18,
  "Juan": 25,
  "Nacho": 30
};
  people["Naku"] = 19;
  print(people["Naku"]);
}

void listaLoop() {

  List<int> numeros = [1, 2, 3, 4, 5];
  for (var i = 0; i < numeros.length; i++) {
    print(numeros[i]);
  }
  }

void mapLoop(){

  Map<String, int> people = {
    "Naku": 18,
    "Juan": 25,
    "Nacho": 30
  };
  for (var key in people.keys) {
    print('Key: $key, Value: ${people[key]}');
  }
}




