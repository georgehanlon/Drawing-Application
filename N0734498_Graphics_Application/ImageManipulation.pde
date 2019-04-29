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

int[] makeSigmoidLUT(){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/255.0f;  // p ranges between 0...1
    float val = sigmoidCurve(p);
    lut[n] = (int)(val*255);
  }
  return lut;
}

float sigmoidCurve(float v){
  // contrast: generate a sigmoid function
  
  float f =  (1.0 / (1 + exp(-12 * (v  - 0.5))));
  
 
  return f;
}

PImage applyPointProcessing(int[] redLUT, int[] greenLUT, int[] blueLUT, PImage inputImage){
  PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  
  inputImage.loadPixels();
  outputImage.loadPixels();
  int numPixels = inputImage.width*inputImage.height;
  for(int n = 0; n < numPixels; n++){
    
    color c = inputImage.pixels[n];
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    r = redLUT[r];
    g = greenLUT[g];
    b = blueLUT[b];
    
    outputImage.pixels[n] = color(r,g,b);
    
    
  }
  
  return outputImage;
}

float getSeconds(){
  float t = millis()/1000.0;
  return t;
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
        rgb[0] = rgb[0]/255;
        rgb[1] = rgb[1]/255;
        rgb[2] = rgb[2]/255;
        int newR = (int)(sigmoidCurve(rgb[0])*255);
        int newG = (int)(sigmoidCurve(rgb[1])*255);
        int newB = (int)(sigmoidCurve(rgb[2])*255);
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