public class FrontierPriorityQueue {
  //min heap of Locations.
  private MyHeap data;

  public FrontierPriorityQueue(boolean type){
    data = new MyHeap(type);
  }

  public int[] next(){
    return data.remove();
  }

  public void add(int[] n){
    data.add(n);
  }

  public boolean hasNext(){
    return data.size() != 0;
  }

  public String toString(){
    return data.toString();
  }
}
