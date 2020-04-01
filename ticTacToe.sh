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
	echo "Symbol Assigned to Player   : $playerSymbol"
	echo "Symbol Assigned to Computer : $computerSymbol"
	echo
}

#To check who plays First
function checkWhoPlaysFirst() {
	if [ $((RANDOM%2)) -eq 0 ]
	then
		echo -e "Player plays First\n"
	else
		echo -e "Computer plays First\n"
	fi
}

function displayBoard() {
	for ((i=1; i<=9; i=$(($i+3)) ))
	do
		echo "-------------"
		echo "| ${gameBoard[$i]} | ${gameBoard[$(($i+1))]} | ${gameBoard[$(($i+2))]} |"
	done
	echo "-------------"
}

resetTheBoard
checkWhoPlaysFirst
symbolAssignment
displayBoard
