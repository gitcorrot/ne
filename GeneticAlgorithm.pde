void newPopulation() {
  population++;
  println("New population! It's " + population);

  killRemainingDots();
  calculateFitnessSum();

  dot = new ArrayList<Dot>();

  for (int i = 0; i < dotCopy.size(); i++) {
    dot.add(selection());
  }

  println("New dot size : " + dot.size());
  
  dotCopy = new ArrayList<Dot>();
  createNodes();
}

// Roulette Wheel Selection
Dot selection() {
  float r = random(fitnessSum);
  float sum = 0;
  for (int i = 0; i < dotCopy.size(); i++) {
    sum += dotCopy.get(i).fitness;
    if (sum > r) {
      Dot child = new Dot(nodeStartIndex, nodeStartIndex, 
        dotCopy.get(i).brain);

      if (random(1) < 0.01) {
        child.brain.randomizeWeights(); 
        println("MUTATION");
      }

      return child;
    }
  }
  // It should never get beneath
  print("Error while selection!"); 
  return new Dot(nodeStartIndex, nodeStartIndex);
}

void calculateFitnessSum() {
  println("Dot size : " + dot.size());
  println("DotCopy size : " + dotCopy.size());
  fitnessSum = 0;
  for (int i = 0; i < dotCopy.size(); i++) {
    fitnessSum += dotCopy.get(i).fitness;
  }
  println("Fitness sum calculated!\tFitness: "+fitnessSum);
}

boolean allDotsDead() {
  boolean allDead = true;
  for (int i = 0; i < dot.size(); i++) {
    if (dot.get(i).dead == false) {
      allDead = false;
    }
  }
  return allDead;
}

void killRemainingDots() {
  for (int i = 0; i < dot.size(); i++) {
    if (dot.get(i).dead == false) {
      dot.get(i).dead();
    }
  }
}
