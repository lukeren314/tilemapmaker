class ScrollBar{
  String type;
  float x;
  float y;
  float min;
  float max;
  float w;
  float h;
  float offset;
  boolean clicked;
  ScrollBar(String type,float x, float y, float min,float max){
    this.type = type;
    this.x = x;
    this.y = y;
    this.min = min;
    this.max = max;
    if(this.type.equals("horizontal")){
      this.w = (max-min)/2;
      this.h = 20;
    } else{
      this.w = 20;
      this.h = (max-min)/2;
    }
    this.clicked = false;
    this.offset = 0;
  }
  void update(){
    if(mouseX > this.x && mouseX < this.x+this.w && mouseY > this.y && mouseY < this.y+this.h){
      if(mouse){
        if(this.type.equals("horizontal")){
          this.offset = mouseX - this.x;
        } else{
          this.offset = mouseY - this.y;
        }
        this.clicked = true;
        mouse = false;
      }
    }
    if(mousePressed && this.clicked){
      if(this.type.equals("horizontal")){
        this.x = mouseX-this.offset;
        this.x = max(this.min,this.x);
        this.x = min(this.max-this.w,this.x);
      } else{
        this.y = mouseY-this.offset;
        this.y = max(this.min,this.y);
        this.y = min(this.max-this.h,this.y);
      }
    } else{
      this.clicked = false;
    }
  }
  void show(){
    fill(200,200,200);
    rect(this.x,this.y,this.w,this.h);
  }
  float scroll(){
    if(this.type.equals("horizontal")){
      return(-(this.x-this.min)/(this.max-this.min));
    } else{
      return(-(this.y-this.min)/(this.max-this.min));
    }
  }
    
}
