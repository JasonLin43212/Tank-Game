public class MyHeap {

  private int[][] data;
  private int size;
  private boolean isMax;

  public MyHeap(){
    this(true);
  }

  @SuppressWarnings("unchecked")
  public MyHeap (boolean val) {
    if (val) {
      isMax = true;
    }
    else {
      isMax = false;
    }
    data = new int[10][3];
    size = 0;
  }

  public String toString() {
    String output = "[";
    for (int i=0; i<size; i++){
      output += Arrays.toString(data[i]);
      if (i != size-1){
        output += ",";
      }
    }
    return output + "]";
  }

  public int size() {
    return size;
  }

  @SuppressWarnings("unchecked")
  private void resize() {
    int[][] newData = new int[size*2][3];
    for (int i=0; i<data.length; i++){
      newData[i] = data[i];
    }
    data = newData;
  }

  public int[] peek(){
    if (size == 0){
      return null;
    }
    else {
      return data[0];
    }
  }

  public void add(int[] s) {
    if (size == data.length){
      resize();
    }
    if (size == 0) {
      data[0] = s;
    }
    else {
      data[size] = s;
      pushUp(size);
    }
    size++;
  }

  public int[] remove() {
    if (size == 0){
      return null;
    }
    int[] removedElem = peek();
    data[0] = data[size-1];
    size--;
    pushDown(0);
    return removedElem;
  }

  private void pushUp(int index){
    int parentIndex = (index-1)/2;
    if (isMax && data[index][2] - data[parentIndex][2] > 0 ||
        !isMax && data[index][2] - data[parentIndex][2] < 0) {
      swap(index,parentIndex);
      pushUp(parentIndex);
    }
  }

  private void pushDown(int index){
    int childL = 2*index + 1;
    int childR = 2*index + 2;
    if (childL >= size){return;}
    if (childR >= size){
      if (canPushDown(index,childL)){
        swap(index,childL);
        pushDown(childL);
      }
    }
    else if (canPushDown(index,childL)){
      if (hasPriorityOver(childL,childR)){
        swap(index,childL);
        pushDown(childL);
      }
      else {
       swap(index,childR);
       pushDown(childR);
      }
    }
    else if (canPushDown(index,childR)){
      swap(index,childR);
      pushDown(childR);
    }
  }

  public boolean canPushDown(int parent, int child){
    return isMax && data[parent][2] - data[child][2] < 0 ||
      !isMax && data[parent][2] - data[child][2] > 0;
  }

  public boolean hasPriorityOver(int child1, int child2){
    return isMax && data[child1][2] - data[child2][2] >= 0 ||
      !isMax && data[child1][2] - data[child2][2] <= 0;
  }

  private void swap(int index1, int index2){
    int[] temp = data[index1];
    data[index1] = data[index2];
    data[index2] = temp;
  }
}
