import java.util.ArrayList;

ArrayList myShapes;
Shape shapeBeingDragged;
SimpleUIManager UI = new SimpleUIManager();
String toolMode = ""; // For radio buttons
PVector savedMouse = new PVector(0, 0); //Initialize the PVector
PImage backgroundImage = null; 

int cX1 = 80, cY1 = 20, cX2 = 640, cY2 = 700; // coordinates for canvas
int buttonYcoord = 80;
int dragX;
int dragY;


/* State for buttons. Key:
m : mouse or 'select', r : rectangle, c : circle
*/
char state = 'm';
String selectedColour = "Red";
color tempC = color(255,0,0);

void setup() {
  shapeBeingDragged = null;
  myShapes = new ArrayList();
  size (800, 800);
  UI.addCanvas(cX1, cY1, cX2, cY2);
  
  // Button Creation
  /*
  UI.addSimpleButton("Select", 0, buttonYcoord);
  UI.addSimpleButton("Fill", 0, buttonYcoord + 30);
  UI.addSimpleButton("Rectangle", 0, buttonYcoord + 60);
  UI.addSimpleButton("Circle", 0, buttonYcoord + 90);
  */
  SimpleButton  rectButton = UI.addRadioButton("Select", 0, buttonYcoord, "group1");
  UI.addRadioButton("Fill", 0, buttonYcoord+30, "group1");
  UI.addRadioButton("Rectangle", 0, buttonYcoord+60, "group1");
  UI.addRadioButton("Circle", 0, buttonYcoord+90, "group1");
  
  rectButton.selected = true;
  toolMode = rectButton.label;
  
  // Menu Creation
  String[] menu1Items =  { "Load Image", "Save Image", "New Canvas"};
  UI.addMenu("File", 0, 0, menu1Items);
  
  String[] menu2Items =  { "Red", "Green", "Blue"};
  UI.addMenu("Colour Fill", 80, 0, menu2Items);
}

void draw() {
   background(g.backgroundColor);

   if(this.backgroundImage != null)
    image(backgroundImage, 200,200,100,100);
  
  UI.drawMe();
  
   for(int i = 0; i < myShapes.size(); i++){
     Shape myShape1 = (Shape)myShapes.get(i);
     myShape1.display();
   }
}

// Checks if mouse position is in the bounds of the canvas so that events
// don't occur outside of canvas - even if they are removed immidiately after
boolean inBounds() {
  if ((mouseX > cX1 && mouseX < cX2) && (mouseY > cY1 && mouseY < cY2))
    return true;
  else return false;
}

void simpleUICallback(UIEventData eventData){
  eventData.printMe(false,false);
  
  if(eventData.uiComponentType == "RadioButton"){
    
    toolMode = eventData.uiLabel;
  }
  
   switch(eventData.uiLabel) {
     case "Load Image":
           // do something
           break;
     case "Save Image":
           // do something
           break;
     case "New Canvas":
           // do something
           break;
     case "Red":
           selectedColour = "Red";
           break;
     case "Green":
           selectedColour = "Green";
           break;
     case "Blue":
           selectedColour = "Blue";
           break;
   }
   
   switch(toolMode) {
     case "Select":
           state = 'm';
           break;
     case "Fill":
           state = 'f';
           break;
     case "Rectangle":
           state = 'r';
           break;
     case "Circle":
           state = 'c';
           break;
        }
}

void evaluateShapeSelection(Shape myShape1){
  if (myShape1.inShape(mouseX, mouseY) & shapeBeingDragged==null){
     dragX = (int)myShape1.xPos - mouseX;
     dragY = (int)myShape1.yPos - mouseY;
     shapeBeingDragged = myShape1;
   
  }

}


void mousePressed(){
  UI.handleMouseEvent("mousePressed",mouseX,mouseY);
  savedMouse.x = mouseX;
  savedMouse.y = mouseY;
  
  if (state == 'm'){
   for(int i = 0; i < myShapes.size(); i++){
     Shape myShape1 = (Shape)myShapes.get(i);
     evaluateShapeSelection(myShape1);
   }
 }
 if (state == 'r'){
   if (inBounds()){
     myShapes.add(new Shape("shape" + (myShapes.size() + 1), "rect", color(255,0,0), savedMouse.x, savedMouse.y, 150, 40));
   }
 }
 
 if (state == 'c'){
   if (inBounds()){
     myShapes.add(new Shape("shape" + (myShapes.size() + 1), "ellipse", color(255,0,0), savedMouse.x, savedMouse.y, 60, 60));
   }
 }
 
 if (state == 'f'){
   if (inBounds()){
     if (selectedColour == "Red")
       tempC = color(255,0,0);
     if (selectedColour == "Green")
       tempC = color(0,255,0);
     if (selectedColour == "Blue")
       tempC = color(0,0,255);
       
     for (int i =0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setColour(tempC);
       }
     }
   }
 }
}

void mouseReleased(){
  UI.handleMouseEvent("mouseReleased",mouseX,mouseY);
  shapeBeingDragged = null;
}

void mouseClicked(){
  UI.handleMouseEvent("mouseClicked",mouseX,mouseY);
}

void mouseMoved(){
    UI.handleMouseEvent("mouseMoved",mouseX,mouseY);
}

void mouseDragged(){
   UI.handleMouseEvent("mouseDragged",mouseX,mouseY);
   
   if (state == 'm'){
     if( shapeBeingDragged != null){
      println("dragging" + shapeBeingDragged.name);
     moveShapeByMouse(shapeBeingDragged);
    }
   }
}

void moveShapeByMouse(Shape myQuery1){
 myQuery1.xPos = mouseX + dragX;
 myQuery1.yPos = mouseY + dragY;


}
