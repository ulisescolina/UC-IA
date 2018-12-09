
;*************************** Ejecucion ***********************

;Para ejecutarlo ejecute los siguientes comandos

;Cargue el archivo File=>Load...
;Execution=> Reset
;Execution=> Run

;*************************************************************

(defrule inicio
         
;*************************************************************

;hecho inicial

;*************************************************************

	(initial-fact)
=>
	(printout t "¿ Que relacion quieres saber ?" crlf)
	(printout t "Dame el primer nombre: ")

;**************************************************************

;bind crea una nueva variables o modificar el valor de las ;variables anteriormente asociada, en el lado derecho de una ;regla. 

;sintaxis

;(bind <variable> <expresión> *)

;donde el primer argumento para obligar, <variable>, es la ;variable local o global en obligarse (puede haber sido ;vinculado con anterioridad). La función de enlace también se ;puede utilizar dentro del cuerpo de un mensaje del ;controlador para fijar el valor de una ranura.

;*************************************************************

	(bind ?name1 (read))

	(printout t "Dame el segundo nombre: ")
	(bind ?name2 (read))
	
;*************************************************************

;eq devuelve true si los dos argumentos pasados son iguales y ;false si no lo son.

;Syntax

;(eq <expression> <expression>+)

;*************************************************************

	(if (eq ?name1 ?name2) then

		(printout t "No es posible relacionar a personas con el mismo nombre" crlf)

;*************************************************************

;halt termina la ejecucion del programa.

;*************************************************************

		(halt)

	else

;*************************************************************

;assert en un su modo más sencillo, CLIPS opera manteniendo ;una lista de hechos (facts) y un conjunto de reglas (rules) ;con las que operar. Un hecho es una pieza de información tal ;como (color verde) o (padre_de Juan Pablo). Los hechos se ;crean aseverando su existencia mediante el comando assert ;command.  

;*************************************************************

(assert (relacion_entre ?name1 ?name2))

	)	
	
)

;********************* CONJUNTO DE REGLAS ********************

;*************************************************************

;defrule los hechos por sí mismo tienen una utilidad limitada. ;La aplicación de reglas es necesaria para desarrollar un ;programa capaz de realizar alguna función útil. En general, ;una regla es expresado en la forma 

;SI <precondición> ENTONCES<postcondición>

;Esta clase de regla es conocida como producción, y de ahí ;que a CLIPS y sistemas similares se les llame sistemas de ;producción. En CLIPS, una regla típica tiene el siguiente ;aspecto:

;(defrule pato
;  (animal-es pato)
;  =>
;  (assert (sonido-es quack)))

;*************************************************************

(defrule padre
	(relacion hijo_de ?hijo ?papa)
=>
	(assert (relacion padre_de ?papa ?hijo))
)

(defrule hijo
	(relacion padre_de ?papa ?hijo)
=>
	(printout t ?papa " es padre de " ?hijo "." crlf)
	(assert (relacion hijo_de ?hijo ?papa))
)

(defrule esposo
	(relacion padre_de ?papa ?hijo)
	(relacion padre_de ?mama ?hijo)
	
=>
	(if (neq ?papa ?mama) then
		(printout t ?mama " y " ?papa " son esposos." crlf)
		(assert (relacion esposo_de ?papa ?mama))
	)
)

(defrule encuentra_esposo
	(relacion padre_de ?papa ?hijo)
	(relacion esposo_de ?papa ?mama)
=>
	(printout t ?mama " es padre de " ?hijo "." crlf)
	(assert (relacion padre_de ?mama ?hijo))
)
 
(defrule encuentra_hijo
	(relacion hijo_de ?hijo ?papa)
	(relacion esposo_de ?papa ?mama)
=>
	(printout t ?hijo " es hijo de " ?mama "." crlf)
	(assert (relacion hijo_de ?hijo ?mama))
)

(defrule hermano
	(relacion hijo_de ?name1 ?papa)
	(relacion hijo_de ?name2 ?papa)
=>
	(if (neq ?name1 ?name2)  then
       		(printout t ?name1 " y " ?name2 " son hermanos. " crlf)
		(assert (relacion hermano_de ?name1 ?name2))
	)
)

(defrule abuelo
	(relacion padre_de ?name1 ?papa)
	(relacion padre_de ?papa ?name2)
=>
	(printout t ?name1 " es abuelo de " ?name2 "." crlf)
	(assert (relacion abuelo_de ?name1 ?name2))
)

(defrule nieto
	(relacion hijo_de ?name1 ?papa)
	(relacion hijo_de ?papa ?name2)
=>
	(printout t ?name1 " es nieto de " ?name2 "." crlf)
	(assert (relacion nieto_de ?name1 ?name2))
)
(defrule tio
	(relacion padre_de ?papa ?hijo)
	(relacion hermano_de ?papa ?tio)
=>
	(printout t ?tio " es tio de " ?hijo "." crlf)
	(assert (relacion tio_de ?tio ?hijo))
)

(defrule sobrino 
	(relacion hijo_de ?hijo ?papa)
	(relacion hermano_de ?papa ?tio)
=>
	(printout t ?hijo " es sobrino de " ?tio "." crlf)
	(assert (relacion sobrino_de ?hijo ?tio))

)
	
(defrule primo
	(relacion hijo_de ?primo1 ?papa)
	(relacion hijo_de ?primo2 ?tio)
	(relacion hermano_de ?papa ?tio)
=>
	(printout t ?primo1 " y " ?primo2 " son primos." crlf)
	(assert (relacion primo_de ?primo1 ?primo2))
)

(defrule bisabuelo
	(relacion padre_de ?bisabuelo ?abuelo)
	(relacion padre_de ?abuelo ?papa)
	(relacion padre_de ?papa ?hijo)
=>
	(printout t ?bisabuelo " es bisabuelo de " ?hijo "." crlf)
	(assert (relacion bisabuelo_de ?bisabuelo ?hijo))
)

(defrule bisnieto
	(relacion hijo_de ?hijo ?papa)
	(relacion hijo_de ?papa ?abuelo)
	(relacion hijo_de ?abuelo ?bisabuelo)
=>
	(printout t ?hijo " es bisnieto de " ?bisabuelo "." crlf)
	(assert (relacion bisnieto ?hijo ?bisabuelo))
)



(defrule relacion_directa
	(declare (salience -1))
	?relacion <- (relacion_entre ?name1 ?name2)
	(relacion ?parentesco ?name1 ?name2)
=>
	(retract ?relacion)
	(switch ?parentesco
		(case hijo_de then
			(printout t ?name1 " es hijo de " ?name2 "." crlf))
		(case padre_de then
			(printout t ?name1 " es padre de " ?name2 "." crlf))
		(case esposo_de then
			(printout t ?name1 " y " ?name2 " son esposos." crlf))
		(case hermano_de then
			(printout t ?name1 " y " ?name2 " son hermanos." crlf))
		(case abuelo_de then
			(printout t ?name1 " es abuelo de " ?name2 "." crlf))
		(case nieto_de then
			(printout t ?name1 " es nieto de " ?name2 "." crlf))
		(case bisabuelo_de then
			(printout t ?name1 " es bisabuelo de " ?name2 "." crlf))
		(case bisnieto_de then
			(printout t ?name1 " es bisnieto de " ?name2 "." crlf))
		(case tio_de then
			(printout t ?name1 " es tio de " ?name2 "." crlf))
		(case sobrino_de then
			(printout t ?name1 " es sobrino de " ?name2 "." crlf))
		(case primo_de then
			(printout t ?name1 " y " ?name2 " son primos." crlf))
		
		
	)
)	

;**************** FIN DEL CONJUNTO DE REGLAS *****************

;************************** HECHOS ***************************

(deffacts parentesco
	(relacion padre_de Pedro Pablo)
	(relacion padre_de Pedro Juan)
	(relacion padre_de Alma Juan)
	(relacion padre_de Alma Pablo)
	(relacion padre_de Juan Emanuel)
	(relacion padre_de Irma Emanuel)
	(relacion hijo_de Raquel Emanuel)
	(relacion esposo_de Emanuel Nancy)
	(relacion hijo_de Hugo Nancy)
	(relacion hijo_de Irma Rosa)
	(relacion esposo_de Rosa Jorge)
	(relacion hermano_de Irma Karla)
	(relacion esposo_de Karla Alberto)
)

;************************ FIN DE LOS HECHOS ******************
