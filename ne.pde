/// TODO:  2D noise map
///        look aside for only 3 nodes
///      !!!  fix selection
//       !!!  normalize fitness?


final int nodeSize = 10;
final int nodeStartIndex = 20;
final int nodeTargetIndexX = 77;
final int nodeTargetIndexY = 57;
final int nodesObstProbability = 5;
final int populationSize = 50;
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
  frameRate(60);
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
  // TODO: Create 2d noise to generate terrain
  nodes = new Node[width/nodeSize][height/nodeSize];
  for (int i = 0; i < width/nodeSize; i++) {
    for (int j = 0; j < height/nodeSize; j++) {
      nodes[i][j] = new Node(i, j);
      // Calculating obstacles
      float obstProbability = random(1) * 222;
      // Creating obstacles
      if (obstProbability < nodesObstProbability) nodes[i][j].obst = true;
    }
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

  if (finish) noLoop();

  time++;

  // Genetic algorithm there
  if (time > 120 || allDotsDead()) {
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
  /* dot.get(0).calculateDistToTarget();
   println(dot.get(0).calculateDistToTarget());*/

  // MLP
  /*dot.get(0).normalizeInputs();
   println("Input 0(right): " + dot.get(0).inputs[0]);
   println("Input 1(left): " + dot.get(0).inputs[1]);
   println("Input 2(down): " + dot.get(0).inputs[2]);
   println("Input 3(up): " + dot.get(0).inputs[3]);
   println("Input 4(distToTarget): " + dot.get(0).inputs[4]);*/

  // Fitness
  /*dot.get(0).calculateFitness();
   println("FITNESS: " + dot.get(0).fitness);*/
}
