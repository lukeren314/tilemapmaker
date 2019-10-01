boolean mouse = false;
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<ScrollBar> scrollbars = new ArrayList<ScrollBar>();
final float SPACING = 100;
int w = 100;
int h = 50;
String[] filenames;
PImage[] images;
int selectedTile = 0;
int[][] map;
PImage saveCanvas;
JSONArray jsonMap;
void mousePressed(){
  mouse = true;
}
void mouseReleased(){
  mouse = false;
}
void loadData(File selection){
  if(selection != null){
    JSONArray json = loadJSONArray(selection.getAbsolutePath());
    map = new int[w][h];
    for(int j = 0; j < this.w; j++){
      JSONArray column = json.getJSONArray(j);
      for(int k = 0; k < this.h; k++){
        map[j][k] = column.getInt(k);
      }
    }
  }
}
void saveData(File selection){
  if(selection != null){
    saveJSONArray(jsonMap,selection.getAbsolutePath()+".json");
    saveCanvas.save(selection.getAbsolutePath()+".png");
  }
}
void setup(){
  size(1600,900);
  String path = sketchPath()+"\\data";
  File file = new File(path);
  if(file.isDirectory()){
    filenames = file.list();
  }
  images = new PImage[filenames.length];
  for(int i = 0; i < this.images.length;i++){
    images[i] = loadImage(filenames[i]);
  }
  buttons.add(new Button("Save",width-SPACING,SPACING));
  buttons.add(new Button("Load",width-SPACING,SPACING*2));
  buttons.add(new Button("New",width-SPACING,SPACING*3));
  scrollbars.add(new ScrollBar("vertical",SPACING*2-20,0,0,height));
  scrollbars.add(new ScrollBar("horizontal",SPACING*2,height-20,SPACING*2,width-SPACING*2));
  scrollbars.add(new ScrollBar("vertical",width-SPACING*2,0,0,height));
  selectedTile = 0;
  map = new int[w][h];
  for(int i = 0; i < this.w; i++){
    for(int j = 0; j < this.h; j++){
      map[i][j] = -1;
    }
  }
}

void draw(){
  background(255,255,255);
  
  for(int i = 0; i < this.w; i++){
    for(int j = 0; j < this.h; j++){
      float tx = SPACING/4+i*50+SPACING*2+scrollbars.get(1).scroll()*(90*w-(width-SPACING*4));
      float ty = SPACING/4+j*50+scrollbars.get(2).scroll()*(90*h-(height-20));
      if(map[i][j] == -1){
        fill(255,255,255);
        rect(tx,ty,50,50);
      } else{
        image(this.images[map[i][j]],tx,ty);
      }
      if(mouseX > tx && mouseX < tx+50 && mouseY > ty && mouseY < ty+50){
        if(mouseX > SPACING*2 && mouseX < width-SPACING*2 && mouseY > 0 && mouseY < height-20){
          if(mouse){
            map[i][j] = selectedTile;
          }
        }
      }
    }
  }
  fill(255,192,203);
  rect(0,0,SPACING*2,height);
  rect(width-SPACING*2,0,SPACING*2,height);
  for(int i = 0; i < this.images.length;i++){
    float tx = SPACING/4*3-this.images[i].width/2;
    float ty = -SPACING/4+this.images[i].height/2+scrollbars.get(0).scroll()*(SPACING*2+50)+i*SPACING;
    float tw = SPACING;
    float th = SPACING;
    if(selectedTile == i){
      fill(255,200,200);
      rect(tx,ty,tw,th);
    }
    image(this.images[i],SPACING-this.images[i].width/2,this.images[i].height/2+ty);
    fill(0,0,0);
    textAlign(CENTER,TOP);
    text(i,tx+SPACING/2,ty);
    if(mouseX > tx && mouseX < tx+tw && mouseY > ty && mouseY < ty+th){
        if(mousePressed){
          selectedTile = i;
        }
    }
  }
  for(int i = 0; i < this.scrollbars.size();i++){
    scrollbars.get(i).update();
    scrollbars.get(i).show();
  }
  for(int i = 0; i < this.buttons.size();i++){
    buttons.get(i).update();
    buttons.get(i).show();
    if(buttons.get(i).clicked){
      buttons.get(i).clicked = false;
      switch(i){
        case 0:
          saveCanvas = createImage(w*50,h*50,ARGB);
          jsonMap = new JSONArray();
          for(int j = 0; j < this.w; j++){
            JSONArray column = new JSONArray();
            for(int k = 0; k < this.h; k++){
              if(map[j][k] == -1){
                map[j][k] = 0;
              }
              column.setInt(k,map[j][k]);
              saveCanvas.copy(images[map[j][k]],0,0,50,50,j*50,k*50,50,50);
            }
            jsonMap.setJSONArray(j,column);
          }
          selectInput("Select a file to save:","saveData"); 
          println("Done!");
          
          break;
        case 1:
          selectInput("Select a file to open:","loadData");
          
          break;
        case 2:
          map = new int[w][h];
          for(int j = 0; j < this.w; j++){
            for(int k = 0; k < this.h; k++){
              map[j][k] = -1;
            }
          }
          break;
      }
    }
  }
}
