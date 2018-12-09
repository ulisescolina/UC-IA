import random


class Punto:
    def __init__(self, l, w, h):
        self.l = l
        self.x = random.randint(0, w)
        self.y = random.randint(0, h)
        self.r = 10
        self.bg = ""
        if self.x > self.y:
            self.val = 1
        else:
            self.val = -1

    def mostrar(self):
        """
            Muestra el punto en un canvas, el metodo
            utiliza la informacion del punto para colorear
            de manera correcta el mismo.
        """
        if self.val == 1:
            self.bg = "black"
        else:
            self.bg = "blue"
        self.l.create_oval(
            self.x - self.r,
            self.y - self.r,
            self.x + self.r,
            self.y + self.r,
            fill=self.bg)
