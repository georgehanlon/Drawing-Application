class Shape {
 String name;
 String type;
 color colour;
 float xPos;
 float yPos;
 int wdth;
 int hght;

 Shape(String name, String type, color tempColour, float tempXpos, float tempYpos,int tempWdth, int tempHght) {
  this.name = name;
  this.type = type;
   colour = tempColour;
  xPos = tempXpos;
  yPos = tempYpos;
  wdth = tempWdth;
  hght = tempHght;
 }
 
 public void setColour(color c){
   colour = c;
 }

 void display() {
   stroke(0);
   fill(colour);
   if (type == "rect"){
     rect(xPos,yPos,wdth,hght);
   }
   else if (type == "ellipse"){
     ellipseMode(CORNER); // needed for colour change to work else fill area was outside of shape area
     ellipse(xPos, yPos, wdth, hght);
   }
 }
 
 boolean inShape(int x, int y){
   if((x > xPos-wdth) & x < (xPos+wdth)){
     if((y > yPos-hght)  & y < (yPos+hght)){
       
       return true;
     }
   }
   return false;
 }
 
 
 
}  
