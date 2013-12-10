library turkish_numbers;

const String SIFIR = "sıfır";

const String BIR = "bir";
const String IKI = "iki";
const String UC = "üç";
const String DORT = "dört";
const String BES = "beş";
const String ALTI = "altı";
const String YEDI = "yedi";
const String SEKIZ = "sekiz";
const String DOKUZ = "dokuz";

const String ON = "on";
const String YIRMI = "yirmi";
const String OTUZ = "otuz";
const String KIRK = "kırk";
const String ELLI = "elli";
const String ALTMIS = "altmış";
const String YETMIS = "yetmiş";
const String SEKSEN = "seksen";
const String DOKSAN = "doksan";

const String YUZ = "yüz";
const String BIN = "bin";
const String MILYON = "milyon";
const String MILYAR = "milyar";
const String TRILYON = "trilyon";
const String KATRILYON = "katrilyon";

const Map<String,int> numberMap = const {
  SIFIR:0,       
  BIR:1,
  IKI:2,
  UC:3,
  DORT:4,
  BES:5 ,
  ALTI:6 ,
  YEDI:7 ,
  SEKIZ:8,
  DOKUZ:9,
  ON:10,
  YIRMI:20,
  OTUZ:30,
  KIRK:40,
  ELLI:50,
  ALTMIS:60,
  YETMIS:70,
  SEKSEN:80,
  DOKSAN:90,
  YUZ:100,
  BIN:1000,
  MILYON:1000000,
  MILYAR:1000000000,
  TRILYON:1000000000000,
  KATRILYON:1000000000000000
};

const int _MAX_NUMBER = 999999999999999999;
const int _MIN_NUMBER = -999999999999999999;

const List<String> _singleDigitNumbers = const ["", BIR, IKI, UC, DORT, BES, ALTI, YEDI, SEKIZ, DOKUZ];
const List<String> _tenToNinety = const ["", ON, YIRMI, OTUZ, KIRK, ELLI, ALTMIS, YETMIS, SEKSEN, DOKSAN];
const List<String> _thousands = const ["", BIN, MILYON, MILYAR, TRILYON, KATRILYON];

/// converts a given three digit number to Turkish text representation.
String _convertThreeDigit(int threeDigitNumber) {
  
  int hundreds = threeDigitNumber ~/ 100;
  int tens = threeDigitNumber ~/ 10 % 10;
  int singleDigit = threeDigitNumber % 10;
  StringBuffer result = new StringBuffer();
  if (hundreds > 1) {
    result.write(_singleDigitNumbers[hundreds]);
  }
  if (hundreds != 0) {
    result.write(" " + YUZ);
  }
  if(tens > 0) {
   result.write(" " + _tenToNinety[tens]); 
  }
  if(singleDigit > 0)
    result.write(" " + _singleDigitNumbers[singleDigit]);
  return result.toString().trim();
}

/**
 * returns the Turkish representation of the input. if negative "eksi" string is prepended.
 *
 * input must be between (including both) -999999999999999999L to 999999999999999999L 
 * throws ArgumentError if input value is too low or high.
 */
String turkishIntToString(int input) {
  if (input == 0)
    return SIFIR;
  if (input < _MIN_NUMBER || input > _MAX_NUMBER)
    throw new RangeError("Input number is out of bounds: ${input}");
  String result = "";
  int inputPositive = input.abs();
  int counter = 0;
  while (inputPositive > 0) {
    int threeDigit = inputPositive % 1000;
    if (threeDigit != 0) {
      if (threeDigit == 1 && counter == 1)
        result = _thousands[counter] + " " + result;
      else result = '${_convertThreeDigit(threeDigit)} ${_thousands[counter]} $result';
    }
    counter++;
    inputPositive ~/= 1000;
  }
  if (input < 0)
    return "eksi " + result.trim();
  else
    return result.trim();
}

final RegExp _spaceSplit = new RegExp(r"\s+");

/**
 * Converts a number text to an int.
 * Example:
 * 'on iki' returns 12  
 * 'bin on iki' returns 1012  
 * 'seksen iki milyon iki' returns 82000002  
 * throws FormatException if words are not parsable like 'bir,bin' 'milyon' 'on,bir,ik'
 */
int turkishStringToInt(String numberText) {
  int result = new _TurkishTextToNumberConverter().convert(numberText.split(_spaceSplit));
  if(result==-1){  
    throw new FormatException("Cannot convert $numberText to and integer.");
  }
  else return result;
}

/**
 * Converts a number from text form to digit form for turkish
 */
class _TurkishTextToNumberConverter {

  //states (used arbitrary integers because of lack of enums)
  static const int START=0,
  ST_ONES_1=1, ST_ONES_2=2, ST_ONES_3=3, ST_ONES_4=4, ST_ONES_5=5, ST_ONES_6=6,
  ST_TENS_1=10, ST_TENS_2=11, ST_TENS_3=12,
  ST_HUNDREDS_1=100, ST_HUNDREDS_2=101,
  ST_THOUSAND=1000,
  END=-1,
  ERROR=-2;

  //transitions
  static const int T_ZERO=0,
  T_ONE=1,
  T_TWO_TO_NINE=2,
  T_TENS=3,
  T_HUNDRED=4,
  T_THOUSAND=5,
  T_MILLION=6,
  T_BILLION=7,
  T_TRILLION=8,
  T_QUADRILLION=9;

  static int getTransitionByValue(int number) {
    switch (_digitCount(number)) {
      case 1:
        if (number == 1)
            return T_ONE;
        else if (number == 0)
            return T_ZERO;
        else
            return T_TWO_TO_NINE;
        break;
      case 2:
        return T_TENS;
      case 3:
        return T_HUNDRED;
      case 4:
        return T_THOUSAND;
      case 7:
        return T_MILLION;
      case 10:
        return T_BILLION;
      case 13:
        return T_TRILLION;
      case 16:
        return T_QUADRILLION;
      default:
          throw new ArgumentError('Cannot create a Transition from value: $number');
    }
  }

  static int _digitCount(int num) {
    int i = 0;
    do {
        num = num ~/ 10;
        i++;
    } while (num > 0);
    return i;
  }

  /**
   * Converts an array of digit text Strings to a int number.
   * Example:
   * [on,iki] returns 12  
   * [bin,on,iki] returns 1012  
   * [seksen,iki,milyon,iki] returns 82000002  
   * returns -1 if words are not parsable like [bir,bin] [milyon] [on,bir,iki]
   */
  int convert(List<String> words) {
      int state = START;
      for (String word in words) {
          state = acceptTransition(state, new _Transition(word));
          if (state == ERROR)
              return -1;
      }
      return valueToAdd + total;
  }

  int total = 0;
  int valueToAdd = 0;
  _Transition previousMil = new _Transition(SIFIR);

  int acceptTransition(int currentState, _Transition transition) {

      switch (transition.transition) {

          case T_ZERO:
              switch (currentState) {
                  case START:
                      return total == 0 ? END : ERROR;
              }
              break;

          case T_ONE:
              switch (currentState) {
                  case START:
                      add(1);
                      return ST_ONES_1;
                  case ST_TENS_1:
                      add(1);
                      return ST_ONES_3;
                  case ST_TENS_2:
                  case ST_HUNDREDS_1:
                      add(1);
                      return ST_ONES_4;
                  case ST_TENS_3:
                  case ST_HUNDREDS_2:
                  case ST_THOUSAND:
                      add(1);
                      return ST_ONES_5;
              }
              break;

          case T_TWO_TO_NINE:
              switch (currentState) {
                  case START:
                      add(transition.value);
                      return ST_ONES_2;
                  case ST_TENS_1:
                      add(transition.value);
                      return ST_ONES_3;
                  case ST_TENS_2:
                  case ST_HUNDREDS_1:
                      add(transition.value);
                      return ST_ONES_4;
                  case ST_TENS_3:
                  case ST_HUNDREDS_2:
                      add(transition.value);
                      return ST_ONES_5;
                  case ST_THOUSAND:
                      add(transition.value);
                      return ST_ONES_6;
              }
              break;

          case T_TENS:
              switch (currentState) {
                  case START:
                      add(transition.value);
                      return ST_TENS_1;
                  case ST_HUNDREDS_1:
                      add(transition.value);
                      return ST_TENS_2;
                  case ST_HUNDREDS_2:
                  case ST_THOUSAND:
                      add(transition.value);
                      return ST_TENS_3;
              }
              break;

          case T_HUNDRED:
              switch (currentState) {
                  case START:
                  case ST_ONES_2:
                      mul(100);
                      return ST_HUNDREDS_1;
                  case ST_THOUSAND:
                  case ST_ONES_6:
                      mul(100);
                      return ST_HUNDREDS_2;
              }
              break;

          case T_THOUSAND:
              switch (currentState) {
                  case START:
                  case ST_ONES_2:
                  case ST_ONES_3:
                  case ST_ONES_4:
                  case ST_TENS_1:
                  case ST_TENS_2:
                  case ST_HUNDREDS_1:
                      addToTotal(transition.value);
                      return ST_THOUSAND;
              }
              break;

          case T_MILLION:
          case T_BILLION:
          case T_TRILLION:
          case T_QUADRILLION:
              switch (currentState) {
                  case ST_ONES_1:
                  case ST_ONES_2:
                  case ST_ONES_3:
                  case ST_ONES_4:
                  case ST_TENS_1:
                  case ST_TENS_2:
                  case ST_HUNDREDS_1:
                      // millions, billions etc behaves the same.
                      // here we prevent "billion" comes after a "million"
                      // for this, we remember the last big number in previousMil variable..
                      if (previousMil.value == 0 || previousMil.value > transition.value) {
                          previousMil = transition;
                          addToTotal(transition.value);
                          return START;
                      } else return ERROR;
              }

      }
      return ERROR;
  }

  add(int val) { valueToAdd += val;}

  mul(int val) => valueToAdd = (valueToAdd == 0 ? val : valueToAdd * val);
  
  addToTotal(int val) {
      if (valueToAdd == 0)
          total += val;
      else
          total += valueToAdd * val;
      valueToAdd = 0;
  }
}

class _Transition {
  int value;
  int transition;

  _Transition(String str) {
    this.value = numberMap[str] ;
    this.transition = _TurkishTextToNumberConverter.getTransitionByValue(this.value);
  }

  String toString() {
    return "[$value]";
  }
}





