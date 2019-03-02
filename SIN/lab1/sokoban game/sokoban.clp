;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	SOKOBAN GAME
;;	 - by David Barbas Rebollo <Group 3E>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts start
	(level 0 robot 1 4 robotf boxes box 2 2 boxf box 3 4 boxf warehouses warehouse 7 1 1 warehousef warehouse 7 4 1 warehousef)
	(board 8 5)
	(obstacles block 1 3 block 4 1 block 4 3 block 4 4 block 4 5 block 8 3)
)
(defglobal
	?*nodes-generated* = 1
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Move NSWE the robot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule M_right
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block (+ ?x 1) ?y) $?ob)))
	(test (not (member (create$ box (+ ?x 1) ?y) $?b)))
	(test (not (member (create$ warehouse (+ ?x 1) ?y) $?w)))
	(test (< ?x ?maxX))	
	=>
	(assert (level (+ ?n 1) robot (+ ?x 1) ?y robotf boxes $?b warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule M_left
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block (- ?x 1) ?y) $?ob)))
	(test (not (member (create$ box (- ?x 1) ?y) $?b)))
	(test (not (member (create$ warehouse (- ?x 1) ?y) $?w)))
	(test (> ?x 1))	
	=>
	(assert (level (+ ?n 1) robot (- ?x 1) ?y robotf boxes $?b warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule M_up
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))	
	(test (not (member (create$ block ?x (- ?y 1)) $?ob)))
	(test (not (member (create$ box ?x (- ?y 1)) $?b)))
	(test (not (member (create$ warehouse ?x 1 (- ?y 1)) $?w)))
	(test (> ?y 1))	
	=>
	(assert (level (+ ?n 1) robot ?x (- ?y 1) robotf boxes $?b warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule M_down
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))	
	(test (not (member (create$ block ?x (+ ?y 1)) $?ob)))
	(test (not (member (create$ box ?x (+ ?y 1)) $?b)))
	(test (not (member (create$ warehouse ?x (+ ?y 1)) $?w)))
	(test (< ?y ?maxY))	
	=>
	(assert (level (+ ?n 1) robot ?x (+ ?y 1) robotf boxes $?b warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Push NSWE a box
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule P_right
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block (+ ?x 2) ?y) $?ob)))
	(test (not (member (create$ warehouse (+ ?x 2) ?y) $?w)))
	(test (not (member (create$ box (+ ?x 2) ?y boxf) $?b1)))
	(test (not (member (create$ box (+ ?x 2) ?y boxf) $?b2)))
	(test (and (= (+ ?x 1) ?bx) (= ?y ?by)))
	(test (< (+ ?x 1) ?maxX))
	=>
	(assert (level (+ ?n 1) robot (+ ?x 1) ?y robotf boxes $?b1 box (+ ?bx 1) ?by boxf $?b2 warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule P_left
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block (- ?x 2) ?y) $?ob)))
	(test (not (member (create$ warehouse (- ?x 2) ?y) $?w)))
	(test (not (member (create$ box (- ?x 2) ?y boxf) $?b1)))
	(test (not (member (create$ box (- ?x 2) ?y boxf) $?b2)))
	(test (and (= (- ?x 1) ?bx) (= ?y ?by)))
	(test (> (- ?x 1) 1))
	=>
	(assert (level (+ ?n 1) robot (- ?x 1) ?y robotf boxes $?b1 box (- ?bx 1) ?by boxf $?b2 warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule P_up
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block ?x (- ?y 2)) $?ob)))
	(test (not (member (create$ warehouse ?x (- ?y 2)) $?w)))
	(test (not (member (create$ box ?x (- ?y 2) boxf) $?b1)))
	(test (not (member (create$ box ?x (- ?y 2) boxf) $?b2)))
	(test (and (= ?x ?bx) (= (- ?y 1) ?by)))
	(test (> (- ?y 1) 1))
	=>
	(assert (level (+ ?n 1) robot ?x (- ?y 1) robotf boxes $?b1 box ?bx (- ?by 1) boxf $?b2 warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule P_down
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w)
	(obstacles $?ob)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (not (member (create$ block ?x (+ ?y 2)) $?ob)))
	(test (not (member (create$ warehouse ?x (+ ?y 2)) $?w)))
	(test (not (member (create$ box ?x (+ ?y 2) boxf) $?b1)))
	(test (not (member (create$ box ?x (+ ?y 2) boxf) $?b2)))
	(test (and (= ?x ?bx) (= (+ ?y 1) ?by)))
	(test (< (+ ?y 1) ?maxY))
	=>
	(assert (level (+ ?n 1) robot ?x (+ ?y 1) robotf boxes $?b1 box ?bx (+ ?by 1) boxf $?b2 warehouses $?w))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Insert NSWE a box into a warehouse.
;;	Only if it has capacity for it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule I_right
	(declare (salience 10))
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w1 warehouse ?wx ?wy ?wc warehousef $?w2)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (and (= (+ ?x 1) ?bx) (= ?y ?by)))
	(test (and (= (+ ?x 2) ?wx) (= ?y ?wy)))
	(test (> ?wc 0))
	;(test (< (+ ?x 1) ?maxX))
	=>
	(assert (level (+ ?n 1) robot (+ ?x 1) ?y robotf boxes $?b1 $?b2 warehouses $?w1 warehouse ?wx ?wy (- ?wc 1) warehousef $?w2))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule I_left
	(declare (salience 10))
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w1 warehouse ?wx ?wy ?wc warehousef $?w2)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (and (= (- ?x 1) ?bx) (= ?y ?by)))
	(test (and (= (- ?x 2) ?wx) (= ?y ?wy)))
	(test (> ?wc 0))
	;(test (> (- ?x 1) 1))
	=>
	(assert (level (+ ?n 1) robot (- ?x 1) ?y robotf boxes $?b1 $?b2 warehouses $?w1 warehouse ?wx ?wy (- ?wc 1) warehousef $?w2))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule I_up
	(declare (salience 10))
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w1 warehouse ?wx ?wy ?wc warehousef $?w2)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (and (= ?x ?bx) (= (- ?y 1) ?by)))
	(test (and (= ?x ?wx) (= (- ?y 2) ?wy)))
	(test (> ?wc 0))
	;(test (> (- ?y 1) 1))
	=>
	(assert (level (+ ?n 1) robot ?x (- ?y 1) robotf boxes $?b1 $?b2 warehouses $?w1 warehouse ?wx ?wy (- ?wc 1) warehousef $?w2))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)
(defrule I_down
	(declare (salience 10))
	(board ?maxX ?maxY)
	(level ?n robot ?x ?y robotf boxes $?b1 box ?bx ?by boxf $?b2 warehouses $?w1 warehouse ?wx ?wy ?wc warehousef $?w2)
	(max-depth ?md)
	(test (< ?n ?md))
	(test (and (= ?x ?bx) (= (+ ?y 1) ?by)))
	(test (and (= ?x ?wx) (= (+ ?y 2) ?wy)))
	(test (> ?wc 0))
	;(test (< (+ ?y 1) ?maxY))
	=>
	(assert (level (+ ?n 1) robot ?x (+ ?y 1) robotf boxes $?b1 $?b2 warehouses $?w1 warehouse ?wx ?wy (- ?wc 1) warehousef $?w2))
	(bind ?*nodes-generated* (+ ?*nodes-generated* 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Define max level the program may reach	
;;	(start) to execute
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deffunction start ()
    (reset)
	(printout t "Maximum depth:= " )
	(bind ?md (read))
	(printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
    (printout t " Execute run to start the program " crlf)
	(assert (max-depth ?md))	
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Detect if the goal state is reached.
;;	Return the level of the solution and
;;	the number of nodes generated
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule goal
	(declare (salience 30))
	(level ?l $? boxes $?b warehouses $?)
	(test (not (member box $?b)))
	=>
	(printout t "All boxes where stored at level " ?l " and with " ?*nodes-generated* " nodes generated." crlf)
	(halt)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Detect if the level of the sokoban 
;;	game surpassed the established by the 
;;	user. If true halt execution
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule lose
	(declare (salience -20))
	(max-depth ?md)
	(level ?l $?)
	(test (= ?l ?md))
	=>
	(printout t "Reached max-depth: " ?md crlf)
	(halt)
)