class Chord {
  String rawchord;

  int chordnum = -1;
  String sufix;
  bool found = false;

  static RegExp chordRegex = RegExp(r'\[(.*?)\]');

  static final CHORDS_SPANISH = {
    'do': 0,
    're': 2,
    'mi': 4,
    'fa': 5,
    'sol': 7,
    'la': 9,
    'si': 11,
  };

  static final CHORDS_ENGLISH = {
    'c': 0,
    'd': 2,
    'e': 4,
    'f': 5,
    'g': 7,
    'a': 9,
    'b': 11,
  };

  static final CHORD_SET_SPANISH = [
    'do',
    'do#',
    're',
    're#',
    'mi',
    'fa',
    'fa#',
    'sol',
    'sol#',
    'la',
    'la#',
    'si'
  ];
  static final CHORD_SET_ENGLISH = [
    'c',
    'c#',
    'd',
    'd#',
    'e',
    'f',
    'f#',
    'g',
    'g#',
    'a',
    'a#',
    'b'
  ];

  Chord(String rawchord) {
    this.rawchord = rawchord;

    //Identifying the chord
    CHORDS_SPANISH.forEach((final String key, final int value) {
      if (rawchord.toLowerCase().startsWith(key) && !found) {
        this.chordnum = value;
        if (rawchord.contains('#')) this.chordnum++;
        if (rawchord.contains('b')) this.chordnum--;
        this.sufix = rawchord
            .toLowerCase()
            .replaceAll(key, '')
            .replaceAll('#', '')
            .replaceAll('b', '');
        found = true;
      }
    });
  }

  Chord transpose(int semiTones) {
    if (semiTones != 0) this.chordnum = ((this.chordnum + semiTones) % 12);
    return this;
  }

  int semiTonesDiferentWith(Chord b){
    if(b.chordnum >= this.chordnum){
      //going upwards
      return b.chordnum - this.chordnum;
    }else{
      //going downwards
      return (-1) * (this.chordnum - b.chordnum);
    }
  }

  String paint(List<String> chordset) {
    if (found){
      String printedChord = chordset[this.chordnum] + sufix;
      return (!sufix.contains('m')) ? printedChord.toUpperCase() : printedChord;
    }
    else
      return rawchord;
  }
}
