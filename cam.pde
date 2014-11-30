     import processing.video.*;

Capture cam;
PImage savedImage=createImage(640, 360, RGB);
PImage diffImage;
int threshold=20 ;



void setup() {
  size(640, 360);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[0]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  PImage newMountains = cam.get(0, 0, 1280, 720);
  newMountains.resize(640,360);
  
  int red= (int) red(newMountains.pixels[0]);
  int blue= (int) blue(newMountains.pixels[0]);
  int green= (int) green(newMountains.pixels[0]);

  
 // println(red+" "+blue+" "+green);
  
  image(newMountains, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  if (keyPressed&&key==' '){
    savedImage=newMountains;
    image(savedImage, 0, 0);
  }
  
  if (keyPressed&&keyCode==UP){
    threshold+=1;
  }
  
   if (keyPressed&&keyCode==DOWN){
    threshold+=-1;
  }
  println(threshold);
  diffImage=cacudiff(savedImage,newMountains);
  diffImage.filter(BLUR, 2);
 image(diffImage, 0, 0);
 
  if (keyPressed&&keyCode==ENTER){
 diffImage.save("picture.jpg");  }
}

PImage cacudiff(PImage x, PImage y){
  PImage img=createImage(x.width, x.height, RGB);
  for (int i=0;i<x.pixels.length;i++){
   if (
   abs((int)red(x.pixels[i])-(int)red(y.pixels[i]))<threshold&&
   abs((int)blue(x.pixels[i])-(int)blue(y.pixels[i]))<threshold&&
   abs((int)green(x.pixels[i])-(int)green(y.pixels[i]))<threshold
   ){
     img.pixels[i]=color(255,255,255);
   } else {
        // img.pixels[i]=y.pixels[i];
  img.pixels[i]=color(0,0,0);
  }
}
return img;
}
