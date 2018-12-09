import random


class Perceptron:
    def __init__(self, n, c=1):
        self.c = c
        self.w = []
        """Inicializo los pesos de manera aleatoria"""
        for i in range(n):
            self.w.append(random.randint(-1, 1))

    def estimar(self, Entradas):
        """
            Realiza la suma ponderada de entrada*peso
            y devuelve lo que se calculo en la funcion
            de activacion
        """
        sum = 0
        for i in range(len(self.w)):
            sum += Entradas[i] * self.w[i]
        return self.activar(sum)

    def entrenar(self, Entradas, SalidaDeseada):
        """
            Calcula el error dadas  las entradas que se brindan
            y ajusta los pesos
        """
        prediccion = self.estimar(Entradas)
        error = SalidaDeseada - prediccion
        for i in range(len(self.w)):
            self.w[i] += self.c * error * Entradas[i]

    def activar(self, valor):
        """
            Funcion de activacion de la neurona
        """
        if valor >= 0:
            return 1
        else:
            return -1

    def __str__(self):
        """
            Metodo que maneja la impresion del perceptron.
            Brinda los pesos actuales del mismo.
        """
        i = 0
        respuesta = ""
        for peso in self.w:
            respuesta += f"W{i}: {peso}\n"
            i += 1
        return respuesta

    def getW(self):
        """
            Devuelve la lista de pesos asociados al perceptron
        """
        return self.w
