from tkinter import *
from perceptron import Perceptron
from punto import Punto
import time
import sys


class App:
    def __init__(self, n=100, w=500, h=500):
        self.n = n
        self.w = w
        self.h = h
        self.puntos = []
        self.perceptron = Perceptron(2, 1)
        master = Tk()
        self.l = Canvas(master, width=self.w, height=self.h)
        self.entrenando = 0
        self.indice_equivocados = 0

    def click(self, event):
        """
            Metodo que se llama como callback al ocurrir un evento de
            click en el canvas, este realiza una ronda de entrenamiento
            con uno de los puntos.
        """
        entrenamiento_actual = self.puntos[self.entrenando]
        entradas = [entrenamiento_actual.x, entrenamiento_actual.y]
        objetivo = entrenamiento_actual.val
        self.perceptron.entrenar(entradas, objetivo)
        entrenamiento_actual.mostrar()
        self.check(entrenamiento_actual)
        self.entrenando += 1

        if self.entrenando == len(self.puntos):
            if self.indice_equivocados > 0:
                self.entrenando = 0
                self.indice_equivocados = 0
                print(
                    "Se llego al final de la primer vuelta, se vuelve a iniciar porque se hicieron ajustes.")
            else:
                print(
                    "Se llego al final de la vuelta sin ningun error, se termina el programa, los pesos son los siguientes")
                print(self.perceptron)
                sys.exit(0)

    def circulo(self, l, cx, cy, r, color="white"):
        """
            Metodo que dibuja un circulo con centro en cx y cy y radio r
        """
        l.create_oval(cx - r, cy - r, cx + r, cy + r, fill=color)

    def check(self, pt):
        """
            Permite visualizar que datos fueron estimados correctamente por el perceptron.
            colorea un circulo interno en los circulos ya existentes, este sera verde si la estimacion
            es correcta, y rojo si la estimacion es incorrecta.
        """
        entradas = [pt.x, pt.y]
        objetivo = pt.val
        estimacion = self.perceptron.estimar(entradas)
        if estimacion == objetivo:
            self.circulo(self.l, pt.x, pt.y, 5, "green")
        else:
            self.circulo(self.l, pt.x, pt.y, 5, "red")
            self.indice_equivocados += 1

    def main(self):
        self.l.configure(background='white')
        self.l.bind("<Button-1>", self.click)
        self.l.pack()

        for i in range(self.n):
            pt = Punto(self.l, self.w, self.h)
            self.puntos.append(pt)
            pt.mostrar()
            self.check(pt)

        mainloop()


if __name__ == "__main__":
    app = App(200, 1000, 1000).main()
