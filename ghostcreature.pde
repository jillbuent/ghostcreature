PVector position, target;
boolean isRunning = false;
PImage ghostCurrent, ghostWalk, hauntedHouse, ghostCool, ghostHeart, ghostEat;
int markTime = 0;
int timeout = 3000;
int foodChoice;
float triggerDistance1 = 100;
float triggerDistance2 = 5;
float movementSpeed = 0.08;
float margin = 50;
int numFoods = 10;
float botheredSpread = 5;

  boolean isHunting = false;

Food[] foods = new Food[numFoods];

void setup() { 
  size(1000, 600, P2D);
  
  for (int i=0; i<foods.length; i++){
   foods[i] = new Food(random(width) , random(height));
  }
  
  hauntedHouse = loadImage("hauntedhouse.png");
  
  position = new PVector(width/2, height/2);
  target = new PVector(random(width), random(height));  
  
  ghostCool = loadImage("ghostcool.png");
  ghostCool.resize(ghostCool.width/8, ghostCool.height/8);
  ghostWalk = loadImage("ghostwalk.png");
  ghostWalk.resize(ghostWalk.width/3, ghostWalk.height/3);
  ghostHeart = loadImage("ghosthappy.png");
  ghostHeart.resize(ghostHeart.width/11, ghostHeart.height/11);
  ghostEat = loadImage("ghosteat.png");
  ghostEat.resize(ghostEat.width/3, ghostEat.height/3);
 
  
  ghostCurrent = ghostCool;
  imageMode(CENTER);
}

void draw() {
  background(hauntedHouse);
  
  PVector mousePos = new PVector(mouseX, mouseY);
  isRunning = position.dist(mousePos) < triggerDistance1;
  
  for(int i=0; i<foods.length; i++){
   foods[i].run(); 
  }
  
  if (isRunning) {
    isHunting = false;
    markTime = millis();
    ghostCurrent = ghostWalk;
    position = position.lerp(target, movementSpeed);
    if (position.dist(target) < triggerDistance2) {
      target = new PVector(random(width), random(height));
    }
  
  if(!isHunting) {  
    pickFoodTarget();
    isHunting = true;
  }
  
  }else if (!isRunning && millis() > markTime + timeout){
    ghostCurrent = ghostHeart;
  } 
  else{
    ghostCurrent = ghostCool;
  }
  
  if (isRunning || isHunting) {
    position = position.lerp(target, movementSpeed).add(new PVector(random(-botheredSpread, botheredSpread), random(-botheredSpread, botheredSpread)));
  }
  
  if (isHunting && position.dist(target) < 5){
    foods[foodChoice].alive = false;
  }
  
  image(ghostCurrent, position.x, position.y);
 
}

void pickEscapeTarget(){
  target = new PVector(random(margin, width-margin), random(margin, height-margin));
}

void pickFoodTarget(){
  foodChoice = int(random(foods.length));
  target = foods[foodChoice].position;
}
