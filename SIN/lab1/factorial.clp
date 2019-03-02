(deffacts factorial
        (number 5)
        (factorial 1)
)

(defrule factorial
        ?f1 <- (number ?num)
        ?f2 <- (factorial ?factor)
        (test (> ?num 1))
    =>
        (retract ?f1 ?f2)
        (assert (factorial (* ?num ?factor)))
        (assert (number (- ?num 1)))
        (printout t "The factorial of " ?num " is " ?factor crlf)
)