import java.util.ArrayList;
import java.util.Arrays;

ArrayList myShapes;
Shape shapeBeingDragged;
SimpleUIManager UI = new SimpleUIManager();
String toolMode = ""; // For radio buttons
PVector savedMouse = new PVector(0, 0); //Initialize the PVector
PImage backgroundImage = null; 

int cX1 = 80, cY1 = 20, cX2 = 640, cY2 = 700; // coordinates for canvas
String[] radio_button_names = {"Fill", "Rectangle", "Circle", "Line", "Bdr Wght", "Bdr Clr", "Open Poly", "Close Poly"}; 
int buttonYcoord = 80;
int buttonXcoord = 10;
int dragX;
int dragY;

ArrayList polyPoints;

int outputNum = 0;


/* State for buttons. Key:
m : mouse or 'select', r : rectangle, c : circle
*/
char state = 'm';
String selectedColour = "Red";
color tempC = color(255,0,0);
float selectedWeight = 1;

void setup() {
  shapeBeingDragged = null;
  myShapes = new ArrayList();
  polyPoints = new ArrayList();
  size (850, 800);
  UI.addCanvas(cX1, cY1, cX2, cY2);
  
  // Button Creation
  SimpleButton  rectButton = UI.addRadioButton("Select", buttonXcoord, buttonYcoord, "group1"); // manual creation of first button for radio
  for (String s: radio_button_names){
    buttonYcoord+=30;
    UI.addRadioButton(s, buttonXcoord, buttonYcoord, "group1");
  }
  
  rectButton.selected = true;
  toolMode = rectButton.label;
  
  // Menu Creation
  String[] menu1Items =  { "Load Image", "Save Image", "New Canvas"};
  UI.addMenu("File", 0, 0, menu1Items);
  
  String[] menu2Items =  { "Red", "Green", "Blue"};
  UI.addMenu("Colour", 80, 0, menu2Items);
  
  String[] menu3Items =  { "1pt", "2pt", "4pt", "6pt", "8pt", "10pt"};
  UI.addMenu("Thickness", 160, 0, menu3Items);
  
  
}

void draw() {
   background(g.backgroundColor);

   if(this.backgroundImage != null){
    //image(backgroundImage, 200,200,100,100);
    image(backgroundImage, 200, 200);
   }
  
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
           selectInput("Open image", "loadAnImage");
           break;
     case "Save Image":
           selectFolder("Select a folder to process:", "folderSelected");
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
     case "1pt":
           selectedWeight = 1;
           break;
     case "2pt":
           selectedWeight = 2;
           break;
     case "4pt":
           selectedWeight = 4;
           break;
     case "6pt":
           selectedWeight = 6;
           break;
     case "8pt":
           selectedWeight = 8;
           break;
     case "10pt":
           selectedWeight = 10;
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
     case "Line":
           state = 'l';
           break;
     case "Bdr Wght":
           state = 'w';
           break;
     case "Bdr Clr":
           state = 'b';
           break;
     case "Open Poly":
           state = 'o';
           break;
   }
}

void loadAnImage(File fileNameObj){
  String pathAndFileName = fileNameObj.getAbsolutePath();
  PImage img = loadImage(pathAndFileName); 
  this.backgroundImage = img;
}

void folderSelected(File selection){
  if (selection == null){
    return;
  }
  else{
    String dir2 = selection.getPath() + "\\";
    save(dir2 + "Output("+outputNum+").jpg");
    outputNum += 1;
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
  
   if (selectedColour == "Red")
   tempC = color(255,0,0);
   if (selectedColour == "Green")
   tempC = color(0,255,0);
   if (selectedColour == "Blue")
   tempC = color(0,0,255);
  
  if (state == 'm'){
   for(int i = 0; i < myShapes.size(); i++){
     Shape myShape1 = (Shape)myShapes.get(i);
     if (myShape1.type!="line"){
       evaluateShapeSelection(myShape1);
     }
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
     for (int i =0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setColour(tempC);
       }
     }
   }
 }
 
 if (state == 'w'){
   if (inBounds()){
     for (int i = 0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setBorderWeight(selectedWeight);
       }
     }
   }
 }
 
 if (state == 'b'){
   if (inBounds()){
     for (int i = 0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setBorderColour(tempC);
       }
     }
   }
 }
 
 if (state == 'l'){
   if (inBounds()){
     myShapes.add(new Shape("shape" + (myShapes.size() + 1), "line", color(255,0,0), savedMouse.x, savedMouse.y, (int)savedMouse.x + 30, (int)savedMouse.y + 30));
   }
 }
 
 if (state == 'o'){
   if (inBounds()){
     if (mouseButton == LEFT){
       float[] temp = {mouseX, mouseY}; 
       polyPoints.add(temp);
       println("POLYPOINTS: " + polyPoints);
     } else if (mouseButton == RIGHT) {
       myShapes.add(new Shape("shape" + (myShapes.size() + 1), "open-poly", polyPoints));
       polyPoints.clear();
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
