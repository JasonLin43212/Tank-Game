public class Maps {

  public String[][][] everyMap = new String[33][19][24];

  public Maps() {
    for (int i=0; i<everyMap.length; i++) {
      String fileName = "map" + i + ".txt";
      String[] lines = loadStrings(fileName);
      for (int j=0; j<19; j++) {
        String line = lines[j];
        for (int k=0; k<24; k++) {
          everyMap[i][j][k] = line.substring(k, k+1);
        }
      }
    }
  }

  public String[][] getMap (int id) {
    if (id != 33) {
      return everyMap[id];
    } else {
      return everyMap[32];
    }
  }
}
