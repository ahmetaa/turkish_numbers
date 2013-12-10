library turkish_numbers_test;

import 'package:unittest/unittest.dart';
import 'package:turkish_numbers/turkish_numbers.dart';

main() {
  test('toText', () {
    expect(turkishIntToString(1),"bir");
    expect(turkishIntToString(0),"sıfır");    
    expect(turkishIntToString(10),"on");    
    expect(turkishIntToString(11),"on bir");    
    expect(turkishIntToString(20),"yirmi");
    expect(turkishIntToString(99),"doksan dokuz");    
    expect(turkishIntToString(100),"yüz");    
    expect(turkishIntToString(101),"yüz bir");
    expect(turkishIntToString(-101),"eksi yüz bir");       
    expect(turkishIntToString(110),"yüz on");    
    expect(turkishIntToString(111),"yüz on bir");    
    expect(turkishIntToString(200),"iki yüz");    
    expect(turkishIntToString(230),"iki yüz otuz");    
    expect(turkishIntToString(237),"iki yüz otuz yedi");    
    expect(turkishIntToString(1000),"bin");    
    expect(turkishIntToString(1001),"bin bir");    
    expect(turkishIntToString(1010),"bin on");    
    expect(turkishIntToString(1011),"bin on bir");    
    expect(turkishIntToString(1100),"bin yüz");    
    expect(turkishIntToString(1101),"bin yüz bir");    
    expect(turkishIntToString(1110),"bin yüz on");    
    expect(turkishIntToString(1111),"bin yüz on bir");    
    expect(turkishIntToString(1300),"bin üç yüz");    
    expect(turkishIntToString(1333),"bin üç yüz otuz üç");    
    expect(turkishIntToString(4000),"dört bin");    
    expect(turkishIntToString(4044),"dört bin kırk dört");    
    expect(turkishIntToString(10000),"on bin");    
    expect(turkishIntToString(10001),"on bin bir");    
    expect(turkishIntToString(10101),"on bin yüz bir");    
    expect(turkishIntToString(17271),"on yedi bin iki yüz yetmiş bir");    
    expect(turkishIntToString(100000),"yüz bin");
    expect(turkishIntToString(100001),"yüz bin bir");    
    expect(turkishIntToString(101001),"yüz bir bin bir");    
    expect(turkishIntToString(101511),"yüz bir bin beş yüz on bir");    
    expect(turkishIntToString(501511),"beş yüz bir bin beş yüz on bir");    
    expect(turkishIntToString(1000000),"bir milyon");    
    expect(turkishIntToString(1000001),"bir milyon bir");    
    expect(turkishIntToString(1001001),"bir milyon bin bir");    
    expect(turkishIntToString(11001001),"on bir milyon bin bir");    
    expect(turkishIntToString(1000000000),"bir milyar");    
    expect(turkishIntToString(1011001001),"bir milyar on bir milyon bin bir");    
  });
  
  test('toNumber', () {
    expect(turkishStringToInt("bir"),1);
    expect(turkishStringToInt("on bir"),11);    
    expect(turkishStringToInt("on"),10);    
    expect(turkishStringToInt("yirmi iki"),22);    
    expect(turkishStringToInt("yüz"),100); 
    expect(turkishStringToInt("yüz bir"),101);    
    expect(turkishStringToInt("yüz on"),110);    
    expect(turkishStringToInt("yüz on bir"),111);    
    expect(turkishStringToInt("iki yüz"),200);    
    expect(turkishStringToInt("iki yüz otuz"),230);    
    expect(turkishStringToInt("iki yüz otuz yedi"),237);      
  });  
}
