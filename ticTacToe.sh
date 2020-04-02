#!/bin/bash

#Declaration of the Arrays and Dictionaries
declare -a gameBoard
declare -A corners
declare -A sides

#Contants
PLAY_FIRST=$((RANDOM%2))

#To reset the Game Board
function resetTheBoard() {
	gameBoard=(0 1 2 3 4 5 6 7 8 9)
}

#To assign a symbol to Player and Computer
function tossAndAssignSymbols() {
	if [ $PLAY_FIRST == 0 ]
	then
		echo "PLAYER plays First"
		switchPlayer=0
		playerSymbol=X
		computerSymbol=O
	else
		echo "COMPUTER plays First"
		switchPlayer=1
		playerSymbol=O
		computerSymbol=X
	fi
	echo "Symbol Assigned to Player   : $playerSymbol"
	echo "Symbol Assigned to Computer  : $computerSymbol"
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
	symbol=$1
	isWin=0
	winConditionForRows
	winConditionForColumns
	winConditionForDiagonals

}

#Check winning for Rows
function winConditionForRows() {
	for (( i=1; i<=9; i=$(($i+3 )) ))
	do
		if [[ ${gameBoard[$i]} == $symbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+1]} ]] && [[ ${gameBoard[$i+1]} == ${gameBoard[$i+2]} ]]
		then
			isWin=1
		fi
	done
}

#Check winning for Columns
function winConditionForColumns() {
	for (( i=1; i<=9; i++ ))
	do
		if [[ ${gameBoard[$i]} == $symbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+3]} ]] && [[ ${gameBoard[$i+3]} == ${gameBoard[$i+6]} ]]
		then
			isWin=1
		fi
	done
}

#Check winning for Diagonals
function winConditionForDiagonals() {
	if [[ ${gameBoard[1]} == $symbol ]] && [[ ${gameBoard[1]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[9]} ]]
	then
		isWin=1
	elif [[ ${gameBoard[3]} == $symbol ]] && [[ ${gameBoard[3]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[7]} ]]
	then
		isWin=1
	fi
}

#To determine the winning result
function winningResult() {
	if [[ $isWin == 1 ]]
	then
		echo "$1 Won"
		exit
	fi
}

#To check the win posibilities of computer and play the move
function computerCheckWin() {
	for ((j=1; j<=9; j++))
	do
		if [[ ${gameBoard[$j]} != $playerSymbol ]] && [[ ${gameBoard[$j]} != $computerSymbol ]]
		then
			gameBoard[$j]=$computerSymbol
			checkWinConditions $computerSymbol
			if [[ $isWin == 1 ]]
			then
				echo "Its Computer's turn. Computer's move(win): $j"
				displayBoard
			fi
			winningResult "COMPUTER"
			gameBoard[$j]=$j
		fi
	done
}

#To check if player can win, then plays to Block it
function computerBlockPlayer() {
	for ((k=1; k<=9; k++))
	do
		if [[ ${gameBoard[$k]} != $playerSymbol ]] && [[ ${gameBoard[$k]} != $computerSymbol ]]
		then
			gameBoard[$k]=$playerSymbol
			checkWinConditions $playerSymbol
			if [[ $isWin == 1 ]]
			then
				echo "Its Computer's turn. Computer's move(block): $k"
				gameBoard[$k]=$computerSymbol
				((count++))
				displayBoard
				switchPlayer=0
				switchThePlayers
			else
				gameBoard[$k]=$k
			fi
		fi
	done
}

#To let the computer to take of the corners
function computerTakeCorners() {
	corners[1]=1
	corners[2]=3
	corners[3]=7
	corners[4]=9
	if [[ ${gameBoard[1]} != $playerSymbol && ${gameBoard[1]} != $computerSymbol ]] || [[ ${gameBoard[3]} != $playerSymbol && ${gameBoard[3]} != $computerSymbol ]] || [[  ${gameBoard[7]} != $playerSymbol && ${gameBoard[7]} != $computerSymbol ]] || [[ ${gameBoard[9]} != $playerSymbol && ${gameBoard[9]} != $computerSymbol ]]
	then
		random=$((RANDOM%4+1))
		cornerPosition=${corners[$random]}
		echo "Its Computer's turn. Computer's move(corners): $cornerPosition"
		isEmptyCell $cornerPosition
		insertSymbol $cornerPosition $computerSymbol
		switchPlayer=0
		switchThePlayers
	fi
}

#To let the computer take centre
function computerTakeCentre(){
	center=5
	isEmptyCell $center
	echo "Its Computer's turn. Computer's move(centre): $center"
	insertSymbol $center $computerSymbol
	switchPlayer=0
	switchThePlayers
}

#To let the computer take of the availabe sides
function computerTakeSides(){
	sides[1]=2
	sides[2]=4
	sides[3]=6
	sides[4]=8
	if [[ ${gameBoard[2]} != $playerSymbol && ${gameBoard[2]} != $computerSymbol ]] || [[ ${gameBoard[4]} != $playerSymbol && ${gameBoard[4]} != $computerSymbol ]] || [[  ${gameBoard[6]} != $playerSymbol && ${gameBoard[6]} != $computerSymbol ]] || [[ ${gameBoard[8]} != $playerSymbol && ${gameBoard[8]} != $computerSymbol ]]
	then
		randomSide=$((RANDOM%4+1))
		sidePosition=${sides[$randomSide]}
		echo "Its Computer's turn. Computer's move(sides): $sidePosition"
		isEmptyCell $sidePosition
		insertSymbol $sidePosition $computerSymbol
		switchPlayer=0
		switchThePlayers
	fi
}

#To insert symbol at a particular position
function insertSymbol() {
	local position=$1
	local symbol=$2
	gameBoard[$position]=$symbol
	((count++))
	displayBoard
}

#To check if the entered position is valid
function isvalidCell() {
	local position=$1
	if [[ $position -gt 9 ]] || [[ $position -lt 1 ]]
	then
		echo "Invalid position!!"
		switchThePlayers
	fi
}

#To check if the entered position is empty
function isEmptyCell() {
	local position=$1
	if [[ ${gameBoard[$position]} == $playerSymbol || ${gameBoard[$position]} == $computerSymbol ]]
	then
		echo "This position is not Empty. Enter again."
		switchThePlayers
	fi
}

#Computer plays on getting its turn
function computersTurn() {
	computerCheckWin
	computerBlockPlayer
	computerTakeCorners
	computerTakeCentre
	computerTakeSides
}

#Player plays on getting its turn
function playersTurn() {
	read -p "Its Player's turn. Enter your move: " playerPosition
	isvalidCell $playerPosition
	isEmptyCell $playerPosition
	insertSymbol $playerPosition $playerSymbol
	checkWinConditions $playerSymbol
	winningResult "PLAYER"
	switchPlayer=1
}

#To check for tie condtion
function checkTie() {
	if [[ $count == 9 ]]
	then
		echo -e "Its a TIE!\n"
		exit
	fi
}

#To switch the turn between Player and Computer
function switchThePlayers() {
	while [[ $count != 9 ]]
	do
		if [[ $switchPlayer == 0 ]]
		then
			playersTurn
		else
			computersTurn
		fi
	done
	checkTie
}

#To start the Tic Toc Toe Game Play
function ticTacToeGame() {
	resetTheBoard
	tossAndAssignSymbols
	displayBoard
	switchThePlayers
}

#Main
ticTacToeGame
