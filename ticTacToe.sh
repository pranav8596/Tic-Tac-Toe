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
	else
		playerSymbol=O
	fi
	echo -e "Symbol Assigned to Player   : $playerSymbol\n"
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

#To display to Game board
function displayBoard() {
	for ((i=1; i<=9; i=$(($i+3)) ))
	do
		echo "-------------"
		echo "| ${gameBoard[$i]} | ${gameBoard[$(($i+1))]} | ${gameBoard[$(($i+2))]} |"
	done
	echo "-------------"
}

#To check for all winning conditions
function checkWinConditions(){
	#Check for Rows
	for (( i=1; i<=9; i=$(($i+3 )) ))
	do
		if [[ ${gameBoard[$i]} == $playerSymbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+1]} ]] && [[ ${gameBoard[$i+1]} == ${gameBoard[$i+2]} ]]
		then
			echo "Won"
			exit
		fi
	done

	#Check for Columns
	for (( i=1; i<=9; i++ ))
	do
		if [[ ${gameBoard[$i]} == $playerSymbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+3]} ]] && [[ ${gameBoard[$i+3]} == ${gameBoard[$i+6]} ]]
		then
			echo "Won"
			exit
		fi
	done

	#Check for Diagonals
	if [[ ${gameBoard[1]} == $playerSymbol ]] && [[ ${gameBoard[1]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[9]} ]]
	then
		echo "Won"
		exit
	elif [[ ${gameBoard[3]} == $playerSymbol ]] && [[ ${gameBoard[3]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[7]} ]]
	then
		echo "Won"
		exit
	fi
}

#To check for tie condtion
function checkTie() {
	if [[ $count -eq 9 ]]
	then
		echo -e "Its a TIE!\n"
		exit
	fi
}

#To insert symbol at a particular position
function insertSymbol() {
	gameBoard[$position]=$playerSymbol
	((count++))
}

#To check if the position is Empty or Valid
function isEmpty() {
	if [[ $position -ge 1 ]] && [[ $position -le 9 ]]
	then
		if [[ ${gameBoard[$position]} != $playerSymbol ]]
		then
			insertSymbol
		else
			echo "This position is not Empty. Enter again."
	fi
	else
		echo "Invalid position!!"
	fi
}

#To start the Game Play
function startThePlay() {
	resetTheBoard
	checkWhoPlaysFirst
	symbolAssignment
	displayBoard
	while [[ $count -ne 10 ]]
	do
		checkTie
		read -p "Enter your position: " position
		isEmpty
		displayBoard
		checkWinConditions
	done

}

#Main
startThePlay
