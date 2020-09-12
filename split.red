Red [
	Date: 4-May-2020
]
split: function [
	{Break series into pieces using the provided delimiter(s)}
	series [series!] "Series to break up"
	dlm "Delimiter" 
	/at
	/tail
	/last
	/after
	/only
	/local _
][
	sys-tail: :system/words/tail
	case [
		integer? dlm [
			case [
				at [
					if tail [dlm: (length? series) - dlm]
					series: insert/only series take/part series dlm 
					append/only series take/part series sys-tail series
				]
				true [
					if dlm < 1 [cause-error 'script 'invalid-arg form dlm]
					while [part: take/part series dlm][series: insert/only series part]
				]
			]
		]
		all [block? dlm parse dlm [some integer!]][
			while [d: take dlm][
				if not all [empty? series only][
					series: insert/only series any [take/part series d copy []]
				]
			]
			if not tail? series [
				part: take/part series sys-tail series 
				if not only [append/only series part]
			]
		]
		only [
			case [
				 at [
					found: either tail [
						either last [find/last/tail series dlm][find/tail series dlm]
					][
						either last [find/last series dlm][find series dlm]
					]
					part: either found [take/part series found][copy []]
					series: insert/only series part
					insert/only series take/part series sys-tail series
				]
			]
		]
		true [
			rule: [if (at) s: skip | remove dlm s:]
			parse/case series [s: opt [ahead dlm rule]
				any [copy _ [to [dlm | end]] e: 
				(s: change/part/only s copy/part s e e) :s 
				opt rule]
			]
		]
	]
	head series
]
rejoin: func [
	"Reduces and joins a block of values." 
    block [block!] "Values to reduce and join"
	/with dlm ;[char! any-string!]
][
    if empty? block: reduce block [return block] 
	frst: either series? first block [copy first block][form first block]
	either with [
		while [block: next block][
			frst: insert insert frst dlm first block
		] 
		head frst
	][
		append frst next block
	]
]
