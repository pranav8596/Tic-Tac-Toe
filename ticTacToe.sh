#!/bin/bash

#Declaration of the Arrays and Dictionaries
declare -a gameBoard
declare -A corners

#To reset the Game Board
function resetTheBoard() {
	gameBoard=(0 1 2 3 4 5 6 7 8 9)
}

#To assign a symbol to Player and Computer
function symbolAssignment() {
	if [ $((RANDOM%2)) == 0 ]
	then
		playerSymbol=X
		computerSymbol=O
	else
		playerSymbol=O
		computerSymbol=X
	fi
	echo "Symbol Assigned to Player   : $playerSymbol"
	echo "Symbol Assigned to Computer  : $computerSymbol"
}

#To check who plays First
function checkWhoPlaysFirst() {
	if [ $((RANDOM%2)) == 0 ]
	then
		echo "Player plays First"
		switchPlayer=0
	else
		echo "Computer plays First"
		switchPlayer=1
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
	symbol=$1
	isWin=0
	#Check for Rows
	for (( i=1; i<=9; i=$(($i+3 )) ))
	do
		if [[ ${gameBoard[$i]} == $symbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+1]} ]] && [[ ${gameBoard[$i+1]} == ${gameBoard[$i+2]} ]]
		then
			isWin=1
		fi
	done

	#Check for Columns
	for (( i=1; i<=9; i++ ))
	do
		if [[ ${gameBoard[$i]} == $symbol ]] && [[ ${gameBoard[$i]} == ${gameBoard[$i+3]} ]] && [[ ${gameBoard[$i+3]} == ${gameBoard[$i+6]} ]]
		then
			isWin=1
		fi
	done

	#Check for Diagonals
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

#To check for tie condtion
function checkTie() {
	if [[ $count == 9 ]]
	then
		echo -e "Its a TIE!\n"
		exit
	fi
}

#To insert symbol at a particular position
function insertSymbol() {
	if [[ $switchSymbol == 1 ]]
	then
		gameBoard[$position]=$playerSymbol
	else
		gameBoard[$position]=$computerSymbol
	fi
	((count++))
}

#To check if the position is Empty or Valid
	function isEmpty() {
	position=$1
	if [[ $position -ge 1 ]] && [[ $position -le 9 ]]
	then
		if [[ ${gameBoard[$position]} != $playerSymbol ]] &&  [[ ${gameBoard[$position]} != $computerSymbol ]]
		then
			insertSymbol
			displayBoard
		else
			echo "This position is not Empty. Enter again."
			switchThePlayers
		fi
	else
		echo "Invalid position!!"
		switchThePlayers
	fi
}

#Player plays on getting its turn
function playersTurn() {
	read -p "Its Player's turn. Enter your move: " playerPosition
	switchSymbol=1
	isEmpty $playerPosition $playerSymbol $computerSymbol
	checkWinConditions $playerSymbol
	winningResult "PLAYER"
	switchPlayer=1
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
	random=$((RANDOM%4+1))	
	cornerPosition=${corners[$random]}
	if [[ ${gameBoard[$cornerPosition]} != $playerSymbol ]] && [[ ${gameBoard[$cornerPosition]} != $computerSymbol ]]
	then
		echo "Its Computer's turn. Computer's move(corners): $cornerPosition"
		gameBoard[$cornerPosition]=$computerSymbol
		((count++))
		displayBoard
		switchPlayer=0
		switchThePlayers
	else
		echo "This position is not Empty. Enter again."
		computerTakeCorners $playerSymbol $computerSymbol 
	fi
}

#To let the computer take centre
function computerTakeCentre(){
	center=5
	if [[ ${gameBoard[$center]} != $playerSymbol ]] && [[ ${gameBoard[$center]} != $computerSymbol ]]
	then
		gameBoard[5]=$computerSymbol
		echo "Its Computer's turn. Computer's move(centre): $center"
		displayBoard
		switchPlayer=0
		switchThePlayers
	fi
}


#Computer plays on getting its turn
function computersTurn() {
	computerCheckWin $playerSymbol $computerSymbol
	computerBlockPlayer $playerSymbol $computerSymbol
	computerTakeCorners $playerSymbol $computerSymbol
	computerTakeCentre
	computerPosition=$((RANDOM%9+1))
	echo "Its Computer's turn. Computer's move:  $computerPosition"
	switchSymbol=2
	isEmpty $computerPosition $playerSymbol $computerSymbol
	checkWinConditions $computerSymbol
	winningResult "COMPUTER"
	switchPlayer=0
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
	checkWhoPlaysFirst
	symbolAssignment
	displayBoard
	switchThePlayers
}

#Main
ticTacToeGame
