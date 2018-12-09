;hechos que se agregan al inicio
;pueden obviarse y declararse uno a uno al completar la carga de las reglas

(deffacts startup (es-animal perro) (es-animal gato) (es-animal pato) (es-animal tortuga) (sangre-caliente perro) (sangre-caliente gato) (sangre-caliente pato) (pone-huevos pato) (pone-huevos turtle) (hijo-de perro cachorro) (hijo-de gato gatito) (hijo-de turtle tortuga-bebe))

;reglas

;regla para listar los animales que se cargan al inicio
(defrule listar-animales
	(es-animal ?name)
=>
	(printout t ?name " encontrado" crlf))

(defrule sonido-pato
	(es-animal pato)
=>
	(assert (sonido-es quack)))

(defrule sonido-perro
	(es-animal perro)
=>
	(assert (sonido-es guau)))

;definicion de mamiferos
(defrule es-mamifero
	(es-animal ?name)
	(sangre-caliente ?name)
	(not (pone-huevos ?name))
=>
  	(assert (es-mamifero ?name))
  	(printout t ?name " es un mamifero" crlf))

;un hijo de un mamifero es un mamifero
(defrule crias-mamifero
	(es-mamifero ?name)
	(hijo-de ?name ?young)
=>
  	(assert (es-mamifero ?young))
  	(printout t ?young " es un mamifero" crlf))

;se pide el nombre de la cria de un animal que no se sepa
(defrule cual-es-el-hijo
        (es-animal ?name)
        (not (hijo-de ?name ?))
=>
        (printout t "Como se llama a la cria del " ?name "?")
        (assert (hijo-de ?name (readline))))

