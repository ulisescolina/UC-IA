// Basado en el ejemplo de:
// Daniel Shiffman: The Nature of Code
// http://natureofcode.com

class Perceptron {
  constructor(n, c) {
    this.w = new Array(n);
    for (let i = 0; i < this.w.length; i++) {
      this.w[i] = random(-1, 1);
    }
    this.c = c;
  }

  train(inputs, desired) {
    let guess = this.feedforward(inputs);
    let error = desired - guess;
    for (let i = 0; i < this.w.length; i++) {
      this.w[i] += this.c * error * inputs[i];
    }
  }

  feedforward(inputs) {
    let sum = 0;
    for (let i = 0; i < this.w.length; i++) {
      sum += inputs[i] * this.w[i];
    }
    return this.activate(sum);
  }

  activate(sum) {
    if (sum > 0) return 1;
    else return -1;
  }

  getWeights() {
    return this.w;
  }
}
