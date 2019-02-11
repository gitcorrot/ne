class Dot {
  int x, y;
  float fitness;
  boolean dead = false;
  double inputs[];
  MultiLayerPerceptron brain;

  Dot(int x, int y) {
    this.x = x;
    this.y = y;
    this.inputs = new double[5];
    brain = new MultiLayerPerceptron(5, 4, 4);
  }

  Dot(int x, int y, MultiLayerPerceptron brain) {
    this.x = x;
    this.y = y;
    this.inputs = new double[5];
    this.brain = brain;
  }

  /*------------------------------------------------------------------------------------*/

  // Moving stuff
  void moveUp() {
    if (this.y > 0)
      this.y -= 1;
    else {
      dead = true;
    }
  }
  void moveDown() {
    if (this.y < height/nodeSize-1)
      this.y += 1;
    else {
      dead = true;
    }
  }
  void moveLeft() {
    if (this.x > 0)
      this.x -= 1;
    else {
      dead = true;
    }
  }
  void moveRight() {
    if (this.x < width/nodeSize-1)
      this.x += 1;
    else {
      dead = true;
    }
  }

  int searchObstRight() {
    for (int i = this.x; i < width/nodeSize; i++) {
      if (nodes[i][this.y].obst) {
        return i - this.x - 1;
      }
    }
    // If there is no obstacles right
    return width/nodeSize - this.x - 1;
  }

  int searchObstLeft() {
    for (int i = this.x; i > 0; i--) {
      if (nodes[i][this.y].obst) {
        return this.x - i - 1;
      }
    }
    // If there is no obstacles left
    return this.x;
  }

  int searchObstDown() {
    for (int i = this.y; i < height/nodeSize; i++) {
      if (nodes[this.x][i].obst) {
        return i - this.y - 1;
      }
    }
    // If there is no obstacles down
    return height/nodeSize - this.y - 1;
  }

  int searchObstUp() {
    for (int i = this.y; i > 0; i--) {
      if (nodes[this.x][i].obst) {
        return this.y - i - 1;
      }
    }
    // If there is no obstacles left
    return this.y;
  }

  // Calculating distance to target using Pitagorean way
  float calculateDistToTarget() {
    int a = targetNode.x - this.x;
    int b = targetNode.y - this.y;
    float distance = sqrt((a*a)+(b*b));
    return distance;
  }

  /*------------------------------------------------------------------------------------*/

  // MLP stuff
  // TODO: add moving and seeing crosswise

  void think() {
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
    inputs[0] = map(searchObstRight(), 0, width/nodeSize, 0, 1);
    // Dist to obst left
    inputs[1] = map(searchObstLeft(), 0, width/nodeSize, 0, 1);
    // Dist to obst down
    inputs[2] = map(searchObstDown(), 0, height/nodeSize, 0, 1);
    // Dist to obst up
    inputs[3] = map(searchObstUp(), 0, height/nodeSize, 0, 1);
    // Dist to target
    inputs[4] = map(calculateDistToTarget(), 0, maxDistToTarget, 1, 0);
  }

  void calculateFitness() {
    fitness = calculateDistToTarget();
  }

  /*------------------------------------------------------------------------------------*/

  void update() {
    if (nodes[this.x][this.y].obst) {
      dead = true;
    }

    if (!dead) {
      normalizeInputs();
      //think();
      show();
    }
  }

  void show() {
    fill(255, 200, 20);
    ellipse(this.x*nodeSize+nodeSize/2, 
      this.y*(3/2)*nodeSize+nodeSize/2, nodeSize, nodeSize);
  }
}
