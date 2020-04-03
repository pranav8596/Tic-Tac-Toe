#!/bin/bash

#Declaration of the Arrays and Dictionaries
declare -a gameBoard
declare -A cornersAndSides

#Contants
PLAY_FIRST=0
TOTAL_PLAYERS=2
TOTAL_CORNERS=4
TOTAL_SIDES=4
TOTAL_CELLS=9

#To reset the Game Board
function resetTheBoard() {
	gameBoard=(0 1 2 3 4 5 6 7 8 9)
}

function getRandomNumbers() {
	echo $((RANDOM%$1+$2))
}

#To assign a symbol to Player and Computer
function tossAndAssignSymbols() {
	PLAY_FIRST="$(getRandomNumbers $TOTAL_PLAYERS 0)"
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
	for ((i=1; i<=$TOTAL_CELLS; i=$(($i+3)) ))
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
	for (( i=1; i<=$TOTAL_CELLS; i=$(($i+3 )) ))
	do
		if [[ ${gameBoard[$i]} == $symbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+1]} ]] && [[ ${gameBoard[$i+1]} == ${gameBoard[$i+2]} ]]
		then
			isWin=1
		fi
	done
}

#Check winning for Columns
function winConditionForColumns() {
	for (( i=1; i<=$TOTAL_CELLS; i++ ))
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
	for ((j=1; j<=$TOTAL_CELLS; j++))
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
	for ((k=1; k<=$TOTAL_CELLS; k++))
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

#Assign corners and sides to Dictionary
function cornersAndSidesDictionary() {
	cornersAndSides[1]=$1
	cornersAndSides[2]=$2
	cornersAndSides[3]=$3
	cornersAndSides[4]=$4
}

#To let the computer to take of the corners
function computerTakeCorners() {
	cornersAndSidesDictionary 1 3 7 9
	if [[ ${gameBoard[1]} != $playerSymbol && ${gameBoard[1]} != $computerSymbol ]] || [[ ${gameBoard[3]} != $playerSymbol && ${gameBoard[3]} != $computerSymbol ]] || [[  ${gameBoard[7]} != $playerSymbol && ${gameBoard[7]} != $computerSymbol ]] || [[ ${gameBoard[9]} != $playerSymbol && ${gameBoard[9]} != $computerSymbol ]]
	then
		randomCorners="$(getRandomNumbers $TOTAL_CORNERS 1)"
		cornerPosition=${cornersAndSides[$randomCorners]}
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
	cornersAndSidesDictionary 2 4 6 8
	if [[ ${gameBoard[2]} != $playerSymbol && ${gameBoard[2]} != $computerSymbol ]] || [[ ${gameBoard[4]} != $playerSymbol && ${gameBoard[4]} != $computerSymbol ]] || [[  ${gameBoard[6]} != $playerSymbol && ${gameBoard[6]} != $computerSymbol ]] || [[ ${gameBoard[8]} != $playerSymbol && ${gameBoard[8]} != $computerSymbol ]]
	then
		randomSides="$(getRandomNumbers $TOTAL_SIDES 1)"
		sidePosition=${cornersAndSides[$randomSides]}
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
	if [[ $position -gt $TOTAL_CELLS ]] || [[ $position -lt 1 ]]
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
	if [[ $count == $TOTAL_CELLS ]]
	then
		echo -e "Its a TIE!\n"
		exit
	fi
}

#To switch the turn between Player and Computer
function switchThePlayers() {
	while [[ $count != $TOTAL_CELLS ]]
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
