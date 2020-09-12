Red [
	Purpose: {To solve algebraic equations} 
	Date: 4-May-2020
]
#include %split.red

cx: context [
	ops: [+ - + * / * ** **]
	vals: object []
	
	find-in: func [paren sym][
		parse paren rule: [some [sym (return true) | ahead paren! into rule | skip] end (return false)]
	]
	;encapsulate vals
	set 'set-values func [blk][vals: object blk]
	set 'set-value  func ['field value][vals/:field: value]
	set 'get-values does [vals]
	set 'solve function [formula /for 'symbol /eval /only][
		;split into left and right side
		parts: either any [block? first formula only] [formula][split formula ['=]]
		set [p1 p2] parts
		if for [
			either find words-of vals symbol [
				unless symbol = first p1 [
					;start from the end of right-hand part
					f: tail p2 
					while [
						;we haven't reached symbol (or paren containing it)
						not any [
							symbol = lst: first f: back tail f
							all [
								paren? lst
								find-in lst to-lit-word symbol
							]
						]
					][
						;put inverse op in the end of left-hand part
						append p1 select ops op: take back f 
						;move last symbol to the end of left-hand part
						either op = '** [
							append/only p1 to-paren append/only copy [1.0 /] take back tail f
						][
							move back tail f tail p1
						]
					]
					;we have found symbol (or paren containing it)
					either head? f [
						reverse parts
					][
						;need to transfer op
						op: first back f
						switch op [
							+ * [  
								;move symbol to the head of right-hand part
								move f f: head f
								;append inverse op to the end of left-hand part
								append p1 select ops take/last f: next f 
								;take and append rest of right-hand part to the end of left-hand part
								part: take/part f tail f
								part: either 1 < length? part [to-paren part][first part]
								append/only p1 part 
								reverse parts
							]
							- / [
								;move symbol to the head of left-hand part
								move f p1
								;take and append rest of left-hand part to the end of right-hand part
								part: take/part next p1 tail p1 
								part: either 1 < length? part [to-paren part][first part]
								append/only p2 part 
								;and don't reverse parts anymore
							]
						]
						
					]
					;If we have paren on left side
					if paren? first parts/1 [
						;take things out of parens as they are all on one side
						append parts/1 take parts/1
						;solve again sending symbol back to right side
						solve/for/only reverse parts :symbol
					]
				]
			][
				cause-error 'user 'message reduce [rejoin ["Unknown symbol! (" symbol ")"]]
			]
		]
		either eval [
			;set :parts/1 do bind parts/2 vals
			symbol: first parts/1
			set symbol do bind parts/2 vals
			vals/:symbol: get symbol
		][
			bind parts vals
		]
	]
]
comment {
set-values [a: none b: 5 c: 4 d: 3 e: 2 f: 1]()
formula: [a = b + c / (d * e) - f]()
solve formula
;== [[a] [b + c / (d * e) - f]]
solve/eval formula
;== 0.5
solve/for formula b
;== [[c] [a + f * (d * e) - b]]
solve/eval/for formula c
;== 4.0
get-value
}