#!/bin/bash

#Declaration of the Game Board Array
declare -a gameBoard

#To reset the Game Board
function resetTheBoard() {
	gameBoard=(0 1 2 3 4 5 6 7 8 9)
}

#To assign a symbol to Player and Computer
function symbolAssignment() {
	if [ $((RANDOM%2)) -eq 0 ]
	then
		playerSymbol=X
		computerSymbol=O	
	else
		playerSymbol=O
		computerSymbol=X
	fi
	echo "Symbol Assigned to Player   :" $playerSymbol
	echo "Symbol Assigned to Computer :" $computerSymbol
}
