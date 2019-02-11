// Roulette Wheel Selection
Dot selection() {
  float r = random(fitnessSum);
  float sum = 0;
  for (int i = 0; i < dotCopy.size(); i++) {
    sum += dotCopy.get(i).fitness;
    if (sum > r) {
      return dotCopy.get(i);
    }
  }
  // It should never get beneath
  print("Error while selection!"); 
  return new Dot(nodeStartIndex, nodeStartIndex);
}

void calculateFitnessSum() {
  fitnessSum = 0;
  for (int i = 0; i < dotCopy.size(); i++) {
    fitnessSum += dotCopy.get(i).fitness;
  }
  println("Fitness sum calculated!\tFitness: "+fitnessSum);
}
