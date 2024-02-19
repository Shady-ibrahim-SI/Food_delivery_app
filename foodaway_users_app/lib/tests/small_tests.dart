bool isNumeric(String text) {
  if (text == null) {
    return false;
  }
  return int.tryParse(text) != null;
}
void main(List<String> args) {
   String text1 = "12345"; // Contains only integers
  String text2 = "12a34"; // Contains non-integer characters
  if(int.tryParse(text2)!=null){
    print('yes am not A TEXT');
  }else{
    print('I am a text');
  }
}