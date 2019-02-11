final int nodeSize = 10;
final int nodeStartIndex = 20;
final int nodeTargetIndexX = 77;
final int nodeTargetIndexY = 57;
final int nodesObstProbability = 5;
final int populationSize = 1;
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
  frameRate(30);
  // Creating window
  size(800, 600); 

  // Initializing
  nodes = new Node[width/nodeSize][height/nodeSize];
  CreateNodes();

  time = 0;

  dot = new ArrayList<Dot>();
  dotCopy = new ArrayList<Dot>();

  for (int i = 0; i < populationSize; i++) {
    dot.add(new Dot(nodeStartIndex, nodeStartIndex));
  }
}

/*------------------------------------------------------------------------------------*/

void CreateNodes() {  
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

  time++;

  // Genetic algorithm there
  if (time > 150 || allDotsDead()) {
    killRemainingDots();
    calculateFitnessSum();
  } else {
    
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
  /*print("Up: " + dot.get(0).searchObstUp());
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
  //println("FITNESS: " + dot.get(0).fitness);
}
