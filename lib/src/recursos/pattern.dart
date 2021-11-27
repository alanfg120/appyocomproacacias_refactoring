bool isAEmail(String texto){
    final reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return reg.hasMatch(texto);
  }