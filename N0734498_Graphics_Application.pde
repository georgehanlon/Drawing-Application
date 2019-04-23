import java.util.ArrayList;
import java.util.Arrays;

ArrayList myShapes;
Shape shapeBeingDragged;
SimpleUIManager UI = new SimpleUIManager();
String toolMode = ""; // For radio buttons
PVector savedMouse = new PVector(0, 0); //Initialize the PVector
PImage backgroundImage = null; 

int cX1 = 80, cY1 = 20, cX2 = 640, cY2 = 700; // coordinates for canvas
String[] radio_button_names = {"Fill", "Bdr Wght", "Bdr Clr", "Resize", "Rectangle", "Circle", "Line", "Open Poly", "Close Poly"}; 
int buttonYcoord = 80;
int buttonXcoord = 10;
int dragX;
int dragY;

ArrayList polyPoints;

int outputNum = 0;

boolean brightnessSlider = false;
int matrixSize;


/* State for buttons. Key:
m : mouse or 'select', r : rectangle, c : circle
*/
char state = 'm';
String selectedColour = "Red";
color tempC = color(255,0,0);
float selectedWeight = 1;
String manip = "";
float selectedScale = 1;

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
  
  String[] menu4Items =  { "Monochrome", "Greyscale", "Negative", "Gaussian Blur", "Sharpen"};
  UI.addMenu("Img Manipula", 240, 0, menu4Items);
  
  String[] menu5Items =  { "50%", "75%", "150%", "200%"};
  UI.addMenu("Scale", 320, 0, menu5Items);
  
  // Slider Creation
  UI.addSlider("Brightness", 300, 730, false);
  UI.addSlider("Contrast", 80, 730, false);
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
  eventData.printMe(true,false);
  
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
     case "Monochrome":
           if (backgroundImage != null){
             for (int y = 0; y < backgroundImage.height; y++) {
               for (int x = 0; x < backgroundImage.width; x++){
                 int[] rgb = getpix(x+200, y+200);
                 color newColour;
                 newColour = monochrome(rgb[0],rgb[1],rgb[2]);
                 backgroundImage.set(x, y, newColour);
               }
             }
           }
           break;
     case "Greyscale":
           if (backgroundImage != null){
             for (int y = 0; y < backgroundImage.height; y++) {
               for (int x = 0; x < backgroundImage.width; x++){
                 int[] rgb = getpix(x+200, y+200);
                 color newColour;
                 newColour = greyscale(rgb[0],rgb[1],rgb[2]);
                 backgroundImage.set(x, y, newColour);
               }
             }
           }
           break;
     case "Negative":
           if (backgroundImage != null){
             for (int y = 0; y < backgroundImage.height; y++) {
               for (int x = 0; x < backgroundImage.width; x++){
                 int[] rgb = getpix(x+200, y+200);
                 color newColour;
                 newColour = negative(rgb[0],rgb[1],rgb[2]);
                 backgroundImage.set(x, y, newColour);
               }
             }
           }
           break;
     case "Brightness":
           println(eventData.sliderStatus);
           if (backgroundImage != null){
             if (eventData.sliderStatus == "increasing"){
               myBrightness(backgroundImage, eventData.sliderPosition * 9);
             } else if (eventData.sliderStatus == "decreasing"){
               myBrightness(backgroundImage, eventData.sliderPosition * -9);
             } else {
               break;
             }
           }
           break;
     case "Contrast":
           println(eventData.sliderStatus);
           if (backgroundImage != null){
             if (eventData.sliderStatus == "increasing"){
               myContrast(backgroundImage, eventData.sliderPosition);
             } else if (eventData.sliderStatus == "decreasing"){
               myContrast(backgroundImage, -(eventData.sliderPosition));
             } else {
               break;
             }
           }
           break;
      case "Gaussian Blur":
           matrixSize = 7;
           if (backgroundImage != null){
             for (int y = 0; y < backgroundImage.height; y++) {
               for (int x = 0; x < backgroundImage.width; x++){
                 //int[] rgb = getpix(x+200, y+200);
                 color newColour;
                 newColour = convolution(x, y, gaussianblur_matrix, matrixSize, backgroundImage);
                 backgroundImage.set(x,y,newColour);
               }
             }
           break;
           }
      case "Sharpen":
           matrixSize = 3;
           if (backgroundImage != null){
             for (int y = 0; y < backgroundImage.height; y++) {
               for (int x = 0; x < backgroundImage.width; x++){
                 //int[] rgb = getpix(x+200, y+200);
                 color newColour;
                 newColour = convolution(x, y, sharpen_matrix, matrixSize, backgroundImage);
                 backgroundImage.set(x,y,newColour);
               }
             }
           break;
           }
     case "50%":
           selectedScale = 0.5;
           break;
     case "75%":
           selectedScale = 0.75;
           break;
     case "150%":
           selectedScale = 1.5;
           break;
     case "200%":
           selectedScale = 2;
           break;
   }
   
   switch(toolMode) {
     case "Select":
           state = 'm';
           break;
     case "Fill":
           state = 'f';
           break;
     case "Resize":
           state = 's';
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
     for (int i =0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setColour(tempC);
       }
     }
   }
 }
 
 if (state == 's'){
   if (inBounds()){       
     for (int i =0; i < myShapes.size(); i++){
       Shape myShape1 = (Shape)myShapes.get(i);
       if ((mouseX > myShape1.xPos && mouseX < (myShape1.xPos + myShape1.wdth)) && (mouseY > myShape1.yPos && mouseY < (myShape1.yPos + myShape1.hght))){
         myShape1.setScale(selectedScale);
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

void moveShapeByMouse(Shape myShape1){
  if (myShape1.type != "line"){
    myShape1.xPos = mouseX + dragX;
    myShape1.yPos = mouseY + dragY;
  } else {
    myShape1.xPos = mouseX + dragX;
    myShape1.yPos = mouseY + dragY;
    myShape1.wdth = mouseX + dragX + 30;
    myShape1.hght = mouseY + dragY + 30;
  }

}


// Image manipulation functions

int[] getpix(int x, int y){
  int[] rgbvals = new int[3];   
  color thisPix = get(x,y);
  rgbvals[0] = (int)red(thisPix);
  rgbvals[1] = (int)green(thisPix);
  rgbvals[2] = (int)blue(thisPix);
  
  return rgbvals;
}

color monochrome(int r, int g, int b) { //black and white
  if (r+g+b > 382) {
    return color(255,255,255);
  }
  else {
    return color(0, 0, 0);
  }
}

color greyscale(int r, int g, int b){ //greyscale
   int average = ((r+g+b)/3);
   return color(average);
}

color negative(int r, int g, int b){ //negative
  int newR = 255 - r;
  int newG = 255 - g;
  int newB = 255 - b;
  return color(newR, newG, newB);
}

color contrast(int r, int g, int b){
  int newR = (int)sigmoidCurve(r);
  int newG = (int)sigmoidCurve(g);
  int newB = (int)sigmoidCurve(b);
  return color(newR, newG, newB);
}

float sigmoidCurve(float v){
  // contrast: generate a sigmoid function
  
  float f =  (1.0 / (1 + exp(-12 * (v  - 0.5))));
  
 
  return f;
}

void myBrightness(PImage img, float level){
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++){
      int[] rgb = getpix(x+200, y+200);
      int newR = rgb[0] + (int)level;
      int newG = rgb[1] + (int)level;
      int newB = rgb[2] + (int)level;
      if (newR > 255)
        newR = 255;
      if (newG > 255)
        newG = 255;
      if (newB > 255)
        newB = 255;
      img.set(x, y, color(newR, newG, newB));
    }
  }
}

void myContrast(PImage img, float level){
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++){
        int[] rgb = getpix(x+200, y+200);
        int newR = (int)sigmoidCurve(rgb[0]);
        int newG = (int)sigmoidCurve(rgb[1]);
        int newB = (int)sigmoidCurve(rgb[2]);
        if (newR > 255)
          newR = 255;
        if (newG > 255)
          newG = 255;
        if (newB > 255)
          newB = 255;
        img.set(x, y, color(newR, newG, newB));
    }
  }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
                     
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
                         
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };
