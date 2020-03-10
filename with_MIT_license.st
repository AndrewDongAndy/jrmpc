'
Copyright 2020 Team Dijkstra. Written for the 2020 JRMPC Conetst

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'!

RobotMind subclass: #SJWM
	instanceVariableNames: 'INF MAX_ROWS MAX_COLS ROWS COLS DIRS MAX_DIST NODE_THRESHOLD GAIN_WEIGHT AROUND_WEIGHT robot allRobots otherRobots whereRobots robotsNear moves mbeg mend tgts tgtInd n g scc t ptr stk onStk pre low numSccs sccSize cells dist gain lastCell lastDir psa q beg end movesLeft'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JRMPC-Phase1-Minds'!

!SJWM methodsFor: 'competition-api' stamp: 'AndrewDong 3/6/2020 23:41'!
determineDirectionForRobot: sketchRobot
	| bestNeighbors move x y |
	robot := sketchRobot.
	movesLeft := movesLeft - 1.
	allRobots := robot map robots.
	otherRobots := allRobots reject: [ :rr | rr id = robot id ].
	whereRobots := otherRobots collect: [ :rr | rr location ].
	allRobots := robot map robots.
	allRobots do: [ :r |
		((cells at: r location x) at: r location y) energy: 0.
	].
	1 to: MAX_ROWS do: [ :i |
		1 to: MAX_COLS do: [ :j |
			(robotsNear at: i) at: j put: 0.
		].
	].
	whereRobots do: [ :pt |
		-2 to: 2 do: [ :i |
			-2 to: 2 do: [ :j |
				x := self normRow: (pt x + i).
				y := self normRow: (pt y + j).
				(robotsNear at: x) at: y put: (((robotsNear at: x) at: y) + 1).
			].
		].
	].
	mbeg <= mend
	ifTrue: [
		move := moves at: mbeg.
		mbeg := mbeg + 1.
	]
	ifFalse: [
		bestNeighbors := robot fourNeighbors sorted: [ :cellA :cellB |
			| valA valB |
			valA := (cellA isKindOf: EnergyCell) ifTrue: [ cellA energy ] ifFalse: [ INF negated ].
			valB := (cellB isKindOf: EnergyCell) ifTrue: [ cellB energy ] ifFalse: [ INF negated ].
			valA > valB
		].
		(bestNeighbors first isKindOf: EnergyCell) ifFalse: [
			bestNeighbors := robot fourNeighbors sorted: [ :cellA :cellB |
				(cellA isKindOf: DeathCell) not
			].
		].
		move := robot wrappedVectorTo: bestNeighbors first location.
	].
	direction := RobotDirection allDirections detect: [ :dir | dir movement = move ].
	self fillPsa.
	self bfsFrom: robot location.
	move := self getMove: (self getTarget).
	direction := RobotDirection allDirections detect: [ :dir | dir movement = move ].

! !


!SJWM methodsFor: 'processing' stamp: 'AndrewDong 3/6/2020 23:41'!
bfsFrom: pt
	| v d gg r c val ncell |
	1 to: ROWS do: [ :i |
		1 to: COLS do: [ :j |
			(dist at: i) at: j put: -1.
		].
	].
	(dist at: pt x) at: pt y put: 0.
	(gain at: pt x) at: pt y put: 0.
	q at: 1 put: pt.
	beg := 1.
	end := 1.
	[ beg <= end ] whileTrue: [
		v := q at: beg.
		beg := beg + 1.
		d := (dist at: v x) at: v y.
		gg := (gain at: v x) at: v y.
		DIRS do: [ :dir |
			ncell := self adjTo: (self normPoint: (v + dir)) direction: dir.
			r := ncell location x.
			c := ncell location y.
			(ncell isKindOf: DeathCell) ifFalse: [
				val := ncell energy.
				((dist at: r) at: c) = -1 ifTrue: [
					end < NODE_THRESHOLD ifTrue: [
						(dist at: r) at: c put: d + 1.
						(gain at: r) at: c put: gg + val.
						(lastCell at: r) at: c put: v.
						(lastDir at: r) at: c put: dir.
						end := end + 1.
						q at: end put: r@c.
					].
				].
				((dist at: r) at: c) = (d + 1) ifTrue: [
					gg + val > ((gain at: r) at: c) ifTrue: [
						(gain at: r) at: c put: gg + val.
						(lastCell at: r) at: c put: v.
						(lastDir at: r) at: c put: dir.
					].
				].
			].
		].
	].
! !

!SJWM methodsFor: 'processing' stamp: 'AndrewDong 3/6/2020 23:41'!
initAroundWeight
	AROUND_WEIGHT := Array new: MAX_DIST.
	1 to: MAX_DIST do: [ :d |
		d <= 10
		ifTrue: [
			AROUND_WEIGHT at: d put: 0.
		]
		ifFalse: [
			AROUND_WEIGHT at: d put: 1/50.
		].
	].! !

!SJWM methodsFor: 'processing' stamp: 'AndrewDong 3/6/2020 23:41'!
getTarget
	| bestX bestY bestVal val aroundVal x y d curComp newComp tgt2 |
	bestX := 1.
	bestY := 1.
	bestVal := INF negated.
	curComp := (scc at: robot location x) at: robot location y.
	tgt2 := (tgtInd > 2) ifTrue: [ tgts at: (tgtInd - 2) ] ifFalse: [ 0@0 ].
	2 to: end do: [ :i |
		x := (q at: i) x.
		y := (q at: i) y.
		((((dist at: x) at: y) <= movesLeft) and: ((x@y) ~= tgt2)) ifTrue: [
			newComp := (scc at: x) at: y.
			(((sccSize at: newComp) >= (sccSize at: curComp)) or: (movesLeft <= ((sccSize at: newComp) // 2)))
			ifTrue: [
				d := (dist at: x) at: y.
				g := (gain at: x) at: y.
				aroundVal := (self getSumCentredAt: x@y) / (((robotsNear at: x) at: y) + 1).
				val := ((GAIN_WEIGHT at: d) * g) + ((AROUND_WEIGHT at: d) * aroundVal).
				val > bestVal ifTrue: [
					bestVal := val.
					bestX := x.
					bestY := y.
				].
			].
		].
	].
	tgts at: tgtInd put: bestX@bestY.
	tgtInd := tgtInd + 1.
	^ bestX@bestY.




! !

!SJWM methodsFor: 'processing' stamp: 'AndrewDong 3/6/2020 23:41'!
initGainWeight
	GAIN_WEIGHT := Array new: MAX_DIST.
	1 to: MAX_DIST do: [ :d |
		GAIN_WEIGHT at: d put: (1 / (self roundTo100th: (d raisedTo: 1.1))).
	].! !


!SJWM methodsFor: 'tarjan' stamp: 'AndrewDong 3/6/2020 23:41'!
dfs: v
	pre at: v put: t.
	low at: v put: t.
	t := t + 1.
	stk at: ptr put: v.
	ptr := ptr + 1.
	onStk at: v put: true.
	(g at: v) do: [ :to |
		(((pre at: to) ~= -1) and: ((onStk at: to) not))
		ifFalse: [
			(pre at: to) ~= -1
			ifTrue: [
				low at: v put: ((low at: v) min: (pre at: to)).
			]
			ifFalse: [
				self dfs: to.
				low at: v put: ((low at: v) min: (low at: to)).
			].
		].
	].
	(low at: v) = (pre at: v) ifTrue: [
		| u |
		u := -1.
		numSccs := numSccs + 1.
		[ u = v ] whileFalse: [
			ptr := ptr - 1.
			u := stk at: ptr.
			onStk at: u put: false.
			self setScc: u scc: numSccs.
		].
		self setScc: v scc: numSccs.
	].
! !

!SJWM methodsFor: 'tarjan' stamp: 'AndrewDong 3/6/2020 23:41'!
findScc
	| id s y |
	t := 0.
	ptr := 1.
	numSccs := 0.
	pre := (Array new: n) collect: [ :x | -1 ].
	low := (Array new: n) collect: [ :x | -1 ].
	1 to: ROWS do: [ :i |
		1 to: COLS do: [ :j |
			id := self getId: i@j.
			(((pre at: id) = -1) and: ((((cells at: i) at: j) isKindOf: DeathCell) not)) ifTrue: [
				self dfs: id.
			].
		].
	].
	sccSize := (Array new: numSccs) collect: [ :x | 0 ].
	1 to: ROWS do: [ :i |
		1 to: COLS do: [ :j |
			(((cells at: i) at: j) isKindOf: DeathCell)
			ifFalse: [
				s := (scc at: i) at: j.
				y := sccSize at: s.
				sccSize at: s put: (y + 1).
			].
		].
	].
! !

!SJWM methodsFor: 'tarjan' stamp: 'AndrewDong 3/6/2020 23:41'!
setScc: nodeId scc: comp
	| pt |
	pt := self getPoint: nodeId.
	(scc at: pt x) at: pt y put: comp.

! !


!SJWM methodsFor: 'running' stamp: 'AndrewDong 3/6/2020 23:41'!
recoverOn: sketchRobot
! !

!SJWM methodsFor: 'running' stamp: 'AndrewDong 3/6/2020 23:41'!
initialize
	super initialize.
	INF := 1000000.
	MAX_ROWS := 105.
	MAX_COLS := 105.
	DIRS := { 1@0. 0@1. (-1)@0. 0@(-1) }.
	NODE_THRESHOLD := 10000.
	MAX_DIST := 10000.
	self initGainWeight.
	self initAroundWeight.
	moves := Array new: MAX_DIST.
	mbeg := 1.
	mend := 0.
	scc := (Array new: MAX_ROWS) collect: [ :row | (Array new: MAX_COLS) collect: [ :x | -1 ] ].
	stk := Array new: (MAX_ROWS * MAX_COLS).
	onStk := (Array new: (MAX_ROWS * MAX_COLS)) collect: [ :x | false ].
	cells := (Array new: MAX_ROWS) collect: [ :row | Array new: MAX_COLS ].
	psa := (Array new: MAX_ROWS) collect: [ :row | (Array new: MAX_COLS) collect: [ :x | 0 ] ].
	robotsNear := (Array new: MAX_ROWS) collect: [ :row | (Array new: MAX_COLS) collect: [ :x | 0 ] ].
	tgts := Array new: 1000.
	tgtInd := 1.
	q := Array new: NODE_THRESHOLD.
	dist := (Array new: MAX_ROWS) collect: [ :row | Array new: MAX_COLS ].
	gain := (Array new: MAX_ROWS) collect: [ :row | Array new: MAX_COLS ].
	lastCell := (Array new: MAX_ROWS) collect: [ :row | Array new: MAX_COLS ].
	lastDir := (Array new: MAX_ROWS) collect: [ :row | Array new: MAX_COLS ].
	


! !

!SJWM methodsFor: 'running' stamp: 'AndrewDong 3/6/2020 23:41'!
setupOn: sketchRobot
	robot := sketchRobot.
	movesLeft := ((robot map endTime / robot map cycleTime) asInteger) + 1.
	ROWS := robot map extent x.
	COLS := robot map extent y.
	robot map cellsDo: [ :cell |
		(cells at: cell location x) at: cell location y put: cell.
	].
	self buildGraph.
	self findScc.

! !


!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getSum: pt1 to: pt2
	| x1 y1 x2 y2 |
	x1 := pt1 x.
	y1 := pt1 y.
	x2 := (pt2 x) + 1.
	y2 := (pt2 y) + 1.
	^ ((psa at: x2) at: y2) - ((psa at: x2) at: y1) - ((psa at: x1) at: y2) + ((psa at: x1) at: y1).! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getAdj: pt
	^ (DIRS collect: [ :d | self adjTo: (self normPoint: (pt + d)) direction: d.])
		reject: [ :to | to isKindOf: DeathCell ].! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
roundTo100th: x
	^ (100 * x) rounded / 100.! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getMove: pt
	| r c d tr tc |
	r := pt x.
	c := pt y.
	d := (dist at: r) at: c.
	d to: 1 by: -1 do: [ :i |
		moves at: i put: ((lastDir at: r) at: c).
		tr := ((lastCell at: r) at: c) x.
		tc := ((lastCell at: r) at: c) y.
		r := tr.
		c := tc.
	].
	mbeg := 2.
	mend := d.
	^ moves at: 1.
	



! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getSumCentredAt: pt
	| npt |
	npt := self normPoint: (pt - 1).
	^ self getSum: npt to: (npt + 2).! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getPoint: id
	^ (id + COLS - 1 // COLS)@(id - 1 \\ COLS + 1).! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
normPoint: pt
	^ (self normRow: pt x)@(self normCol: pt y).! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
normRow: r
	^ r - 1 \\ ROWS + 1.! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
fillPsa
	1 to: (MAX_ROWS - 1) do: [ :i |
		1 to: (MAX_COLS - 1) do: [ :j |
			(psa at: (i + 1)) at: (j + 1) put:
				(((psa at: (i + 1)) at: j)
				+ ((psa at: i) at: (j + 1))
				- ((psa at: i) at: j)
				+ ((cells at: (self normRow: i)) at: (self normCol: j)) energy).
		].
	].! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
normCol: c
	^ c - 1 \\ COLS + 1.! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
buildGraph
	n := ROWS * COLS.
	g := Array new: n.
	1 to: ROWS do: [ :i |
		1 to: COLS do: [ :j |
			g at: (self getId: i@j) put: ((self getAdj: i@j) collect: [ :x | self getId: (x location) ]).
		].
	].
! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
adjTo: pt direction: dir
	| cell |
	cell := (cells at: pt x) at: pt y.
	(cell isKindOf: WarpCell)
	ifTrue: [	
		^ (cells at: cell target x) at: cell target y.
	].
	(cell isKindOf: JumpCell)
	ifTrue: [
		^ (cells at: (self normRow: ((cell distance) * (dir x) + pt x))) at: (self normCol: ((cell distance) * (dir y) + pt y)).
	].
	^ cell! !

!SJWM methodsFor: 'utilities' stamp: 'AndrewDong 3/6/2020 23:41'!
getId: pt
	^ (pt x - 1) * COLS + pt y.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SJWM class
	instanceVariableNames: ''!

!SJWM class methodsFor: 'identification' stamp: 'AndrewDong 3/6/2020 23:41'!
teamName
	^ 'Team Dijkstra'! !
