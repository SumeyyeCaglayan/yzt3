import 'dart:math';

void main() {
  GA ga = GA();
  Solution sol = ga.run();
  print("Best solution is: ${sol.genotip} -> ${sol.fitness}");
}

class GA {
  final populationSize = 100;
  final maxGeneration = 2000;
  List<Solution> population = [];
  final double targetY = 17.5398258887737;
  
  void initPopulation() {
    for (int i = 0; i < populationSize; i++) {
      population.add(Solution());
    }
  }
  
  void calculateFitness(List<Solution> population) {
    for (int i = 0; i < populationSize; i++) {
      double res = population[i].genotip[0] * sin(pow(5, 0));
      res += population[i].genotip[1] * sin(pow(5, 1));
      res += population[i].genotip[2] * cos(pow(5, 2));
      res -= population[i].genotip[3] * sin(pow(5, 3));
      res -= population[i].genotip[4] * cos(pow(5, 4));
      population[i].fitness = res;
      population[i].difference = (targetY - res).abs();
    }
  }
  
  Solution crossOver(Solution s1, Solution s2) {
    Solution newSol = Solution();
    newSol.genotip[0] = s1.genotip[0];
    newSol.genotip[1] = s1.genotip[1];
    newSol.genotip[2] = s1.genotip[2];
    newSol.genotip[3] = s2.genotip[3];
    newSol.genotip[4] = s2.genotip[4];
    return newSol;
  }
  
  void mutate(Solution s) {
    int m1 = Random().nextInt(5);
    int m2 = Random().nextInt(5);
    s.genotip[m1] = Random().nextInt(10);
    s.genotip[m2] = Random().nextInt(10);
  }
  
  void updatePopulation() {
    population.sort((a, b) => a.difference.compareTo(b.difference));
    int j = populationSize - 1;
    for (int i = 0; i < populationSize / 2; i += 2) {
      Solution newSol = crossOver(population[i], population[i + 1]);
      mutate(newSol);
      population[j] = newSol;
      j--;
    }
  }
  
  Solution run() {
    initPopulation();
    
    Solution bestSol = Solution();
    bestSol.difference = double.infinity;
    
    for (int generation = 0; generation < maxGeneration; generation++) {
      calculateFitness(population);
      
      for (Solution sol in population) {
        if (sol.difference < bestSol.difference) {
          bestSol = sol;
        }
      }
      
      updatePopulation();
      
      if (bestSol.difference == 0) {
        break;
      }
    }
    
    return bestSol;
  }
}

class Solution {
  List<int> genotip = List<int>.generate(5, (i) => Random().nextInt(10));
  double fitness = 0;
  double difference = 0;
}
