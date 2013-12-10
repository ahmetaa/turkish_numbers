turkish_numbers
===============

Provides Turkish Number-Text Conversion functions.

Usage Example:
  
	library turkish_numbers_example;
	
	import 'package:turkish_numbers/turkish_numbers.dart';
	
	main() {
	  print("101 = ${turkishIntToString(101)}");
	  print("yüz on bir = ${turkishStringToInt('yüz on bir')}");  
	}
	
	Output:    
	101 = yüz bir
	yüz on bir = 111
