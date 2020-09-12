# solver
Toy equation solver (`op!`s only)

E.g.:

```
do %solve.red
set-values [a: none b: 5 c: 4 d: 3 e: 2 f: 1]()
formula: [a = b + c / (d * e) - f]()
solve formula
;== [[a] [b + c / (d * e) - f]]
solve/eval formula
;== 0.5
solve/for formula c
;== [[c] [a + f * (d * e) - b]]
solve/eval/for formula c
;== 4.0
get-values
```

Exponentiation works too, but no words as exponents:

```
set-values [a: 5 b: none c: 3]()
solve/eval/for f: [a = (b ** 2 + (c ** 2)) ** 0.5] b
;== 4.0
set-value c none ()
solve/eval/for f c
;== 3.0
f
;== [[c] [a ** (1.0 / 0.5) - (b ** 2) ** (1.0 / 2)]]
```
