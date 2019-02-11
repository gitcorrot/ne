class Dot {
  int x, y;
  boolean dead;
  float fitness;
  double inputs[];
  MultiLayerPerceptron brain;

  Dot(int x, int y) {
    this.x = x;
    this.y = y;
    this.dead = false;
    this.fitness = 0;
    this.inputs = new double[5];
    brain = new MultiLayerPerceptron(5, 5, 4);
  }

  Dot(int x, int y, MultiLayerPerceptron brain) {
    this.x = x;
    this.y = y;
    this.dead = false;
    this.fitness = 0;
    this.inputs = new double[5];
    this.brain = brain;
  }

  /*------------------------------------------------------------------------------------*/

  // Moving stuff
  void moveUp() {
    if (this.y > 0)
      this.y -= 1;
    else {
      dead();
    }
  }
  void moveDown() {
    if (this.y < height/nodeSize-1)
      this.y += 1;
    else {
      dead();
    }
  }
  void moveLeft() {
    if (this.x > 0)
      this.x -= 1;
    else {
      dead();
    }
  }
  void moveRight() {
    if (this.x < width/nodeSize-1)
      this.x += 1;
    else {
      dead();
    }
  }

  int searchObstRight() {
    for (int i = 0; i <= 3; i++) {
      if (this.x + i < width/nodeSize) {
        if (nodes[this.x + i][this.y].obst) {
          return i-1;
        }
      } else {
        return width/nodeSize - this.x -1;
      }
    }
    // If there is no obstacles right
    return 3;
  }

  int searchObstLeft() {
    for (int i = 0; i <= 3; i++) {
      if (this.x - i > 0) {
        if (nodes[this.x - i][this.y].obst) {
          return i-1;
        }
      } else {
        return this.x;
      }
    }
    // If there is no obstacles left
    return 3;
  }

  int searchObstDown() {
    for (int i = 0; i <= 3; i++) {
      if (this.y + i < height/nodeSize) {
        if (nodes[this.x][this.y + i].obst) {
          return i-1;
        }
      } else {
        return height/nodeSize - this.y -1;
      }
    }
    // If there is no obstacles down
    return 3;
  }

  int searchObstUp() {
    for (int i = 0; i <= 3; i++) {
      if (this.y - i > 0) {
        if (nodes[this.x][this.y - i].obst) {
          return i-1;
        }
      } else {
        return this.y;
      }
    }
    // If there is no obstacles up
    return 3;
  }

  // Calculating distance to target using Pitagorean way
  float calculateDistToTarget() {
    int a = targetNode.x - this.x;
    int b = targetNode.y - this.y;
    float distance = sqrt((a*a)+(b*b));
    return distance;
    //return a+b;
  }

  /*------------------------------------------------------------------------------------*/

  // MLP stuff
  // TODO: add moving and seeing crosswise

  void think() {
    normalizeInputs();
    brain.setInput(inputs);
    brain.calculate();

    if (brain.getOutput()[0] > 0.50) {
      moveUp();
    }
    if (brain.getOutput()[1] > 0.50) {
      moveDown();
    }
    if (brain.getOutput()[2] > 0.50) {
      moveLeft();
    }
    if (brain.getOutput()[3] > 0.50) {
      moveRight();
    }
  }

  void normalizeInputs() {
    // Dist to obst right
    inputs[0] = map(searchObstRight(), 0, 3, 0, 1);
    // Dist to obst left
    inputs[1] = map(searchObstLeft(), 0, 3, 0, 1);
    // Dist to obst down
    inputs[2] = map(searchObstDown(), 0, 3, 0, 1);
    // Dist to obst up
    inputs[3] = map(searchObstUp(), 0, 3, 0, 1);
    // Dist to target
    inputs[4] = map(calculateDistToTarget(), 0, maxDistToTarget, 1, -1);
  }

  // TOOD: maybe consider steps made
  void calculateFitness() {
    fitness = pow(maxDistToTarget/calculateDistToTarget(), 4);
  }

  void dead() {
    dead = true;
    calculateFitness();
    dotCopy.add(this);
  }

  /*------------------------------------------------------------------------------------*/

  void update() {
    if (nodes[this.x][this.y].obst && !dead) {
      dead();
    }

    if (nodes[this.x][this.y].targetNode) {
      finish = true;
    }

    if (!dead) {
      think();
      show();
    }
  }

  void show() {
    fill(255, 200, 20, 20);
    ellipse(this.x*nodeSize+nodeSize/2, 
      this.y*(3/2)*nodeSize+nodeSize/2, nodeSize, nodeSize);
  }
}
