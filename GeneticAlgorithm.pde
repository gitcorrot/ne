void newPopulation() {
  population++;
  println("New population! It's " + population);

  killRemainingDots();
  calculateFitnessSum();

  dot = new ArrayList<Dot>();

  for (int i = 0; i < dotCopy.size(); i++) {
    dot.add(crossover(selection(), selection()));
  }

  println("New dot size : " + dot.size());

  dotCopy = new ArrayList<Dot>();
  createNodes();
}

/*------------------------------------------------------------------------------------*/

// Roulette Wheel Selection x2
// (select 2 best dots and crossover them)
Dot selection() {
  float r = random(fitnessSum);
  float sum = 0;
  int index = 0;
  
  while(sum < r) {
     sum += dotCopy.get(index).fitness; 
     index += 1;
  }
  
  return dotCopy.get(index-1);
  
    /*for (int i = 1; i < dotCopy.size(); i++) {
    sum += dotCopy.get(i).fitness;
    if (sum > r) {
      return dotCopy.get(i);
    }
  }

  // It should never get beneath
  println("Error while selection!"); 
  return new Dot(nodeStartIndex, nodeStartIndex);*/
}

/*------------------------------------------------------------------------------------*/

Dot crossover(Dot d1, Dot d2) {

  println("Crossover of: " + d1.fitness + " + " + d2.fitness);

  // TODO: pick only 2 best dots to crossover 
  //       and check if they are not the same
  Double[] d1weights = d1.brain.getWeights();
  Double[] d2weights = d2.brain.getWeights();
  double[] newWeights = new double[d1weights.length];
  MultiLayerPerceptron brain = new MultiLayerPerceptron(5, 4, 4);

  if (d1weights.length == d2weights.length) {
    for (int i = 0; i < d2weights.length; i++) {
      if (random(1) > 0.5) {
        newWeights[i] = d1weights[i];
      } else { 
        newWeights[i] = d2weights[i];
      }
    }
    brain.setWeights(newWeights);

    if (random(1) < mutationRate) {
      brain.randomizeWeights(); 
      println("MUTATION");
    }

    return new Dot(nodeStartIndex, nodeStartIndex, brain);
  }
  println("Error while crossover! Returning dot w/o brain!");
  return new Dot(nodeStartIndex, nodeStartIndex);
}

/*------------------------------------------------------------------------------------*/

void calculateFitnessSum() {
  println("Dot size : " + dot.size());
  println("DotCopy size : " + dotCopy.size());
  fitnessSum = 0;
  for (int i = 0; i < dotCopy.size(); i++) {
    fitnessSum += dotCopy.get(i).fitness;
  }
  println("Fitness sum calculated!\tFitness: "+fitnessSum);
}

/*------------------------------------------------------------------------------------*/

boolean allDotsDead() {
  boolean allDead = true;
  for (int i = 0; i < dot.size(); i++) {
    if (dot.get(i).dead == false) {
      allDead = false;
    }
  }
  return allDead;
}

/*------------------------------------------------------------------------------------*/

void killRemainingDots() {
  for (int i = 0; i < dot.size(); i++) {
    if (dot.get(i).dead == false) {
      dot.get(i).dead();
    }
  }
}
