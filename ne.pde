/// TODO:  2D noise map
///        refactor looking aside for only 3 
///        nodes to look to first obstacle

///      !!!  too low influence on output :(


final int nodeSize = 10;
final int nodeStartIndex = 30;
 int nodeTargetIndexX = 55;
 int nodeTargetIndexY = 45;
final int nodesObstProbability = 40;
final int populationSize = 1;
final float mutationRate = 0.01;  // 10%
boolean finish;
int population;
int time;
float fitnessSum;
float maxDistToTarget;
Node[][] nodes;
Node startNode;
Node targetNode;
ArrayList<Dot> dot;
ArrayList<Dot> dotCopy;

/*------------------------------------------------------------------------------------*/

void setup() {
  // fixed framerate for constant speed of moving
  frameRate(10);
  // Creating window
  size(800, 600); 

  // Initializing
  nodes = new Node[width/nodeSize][height/nodeSize];
  createNodes();

  time = 0;
  finish = false;
  population = 1;

  dot = new ArrayList<Dot>();
  dotCopy = new ArrayList<Dot>();

  for (int i = 0; i < populationSize; i++) {
    dot.add(new Dot(nodeStartIndex, nodeStartIndex));
  }
}

/*------------------------------------------------------------------------------------*/

void createNodes() {  
  float ioff = 0;
  float joff = 0;
  
  //nodeTargetIndexX = floor(random(2, 77));
  //nodeTargetIndexY= floor(random(2, 57));

  noiseSeed(int(random(1000)));

  nodes = new Node[width/nodeSize][height/nodeSize];
  for (int i = 0; i < width/nodeSize; i++) {
    for (int j = 0; j < height/nodeSize; j++) {
      nodes[i][j] = new Node(i, j);
      // Calculating obstacles
      float obstProbability = noise(joff, ioff) * 105;
      // Creating obstacles
      if (obstProbability < nodesObstProbability) nodes[i][j].obst = true;
      joff += 0.2;
    }
    ioff += 0.2;
    joff = 0;
  }

  // Starting and target node coordinates
  startNode = nodes[nodeStartIndex][nodeStartIndex];
  startNode.startNode = true;
  startNode.obst = false;
  targetNode = nodes[nodeTargetIndexX][nodeTargetIndexY];
  targetNode.targetNode = true;
  targetNode.obst = false;

  maxDistToTarget = sqrt((targetNode.x*targetNode.x)+(targetNode.y*targetNode.y));
}

/*------------------------------------------------------------------------------------*/

void draw() {
  background(64);

  //if (finish) noLoop();

  //time++;

  // Genetic algorithm there
  if (time > 40 || allDotsDead()) {
    newPopulation();
    time = 0;
  }

  // Visualisating nodes 
  for (int i = 0; i < width; i += nodeSize) {
    for (int j = 0; j < height; j += nodeSize) {
      nodes[i/nodeSize][j/nodeSize].show();
    }
  }

  // Visualisating dots
  for (int i = 0; i < dot.size(); i++) {
    dot.get(i).update();
  }
}

/*------------------------------------------------------------------------------------*/

// Debugging function 
void keyPressed() {
  println(dot.get(0).brain.getWeights().length);
  // Moving and dist to obstacle
  if (keyCode == RIGHT)
    dot.get(0).moveRight();
  if (keyCode == LEFT)
    dot.get(0).moveLeft();
  if (keyCode == UP)
    dot.get(0).moveUp();
  if (keyCode == DOWN)
    dot.get(0).moveDown();

  // Obstacles    
  /* print("Up: " + dot.get(0).searchObstUp());
   println("    Down: " + dot.get(0).searchObstDown());
   print("Left: " + dot.get(0).searchObstLeft());
   println("     Right: " + dot.get(0).searchObstRight());*/

  // Distance
  /*dot.get(0).calculateDistToTarget();
   println(dot.get(0).calculateDistToTarget());*/

  // MLP
  dot.get(0).normalizeInputs();
   println("Input 0(right): " + dot.get(0).inputs[0]);
   println("Input 1(left): " + dot.get(0).inputs[1]);
   println("Input 2(down): " + dot.get(0).inputs[2]);
   println("Input 3(up): " + dot.get(0).inputs[3]);
   println("Input 4(distToTarget): " + dot.get(0).inputs[4]);

  // Fitness
  /*dot.get(0).calculateFitness();
   println("FITNESS: " + dot.get(0).fitness);
   println("dist to target: " + dot.get(0).calculateDistToTarget());*/
}
