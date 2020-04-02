#!/bin/bash

#Declaration of the Arrays and Dictionaries
declare -a gameBoard
declare -A corners
declare -A sides

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
		if [[ ${gameBoard[$cornerPosition]} != $playerSymbol ]] && [[ ${gameBoard[$cornerPosition]} != $computerSymbol ]]
		then
			gameBoard[$cornerPosition]=$computerSymbol
			((count++))
			displayBoard
			switchPlayer=0
			switchThePlayers
		else
			echo "This position is not Empty. Enter again."
			computerTakeCorners $playerSymbol $computerSymbol 
		fi
	fi
}

#To let the computer take centre
function computerTakeCentre(){
	center=5
	if [[ ${gameBoard[$center]} != $playerSymbol ]] && [[ ${gameBoard[$center]} != $computerSymbol ]]
	then
      echo "Its Computer's turn. Computer's move(centre): $center"
		gameBoard[5]=$computerSymbol
		((count++))
		displayBoard
		switchPlayer=0
		switchThePlayers
	fi
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
   	if [[ ${gameBoard[$sidePosition]} != $playerSymbol ]] && [[ ${gameBoard[$sidePosition]} != $computerSymbol ]]
   	then
			gameBoard[$sidePosition]=$computerSymbol
      	((count++))
      	displayBoard
			switchPlayer=0
			switchThePlayers
   	else
      	echo "This position is not Empty. Enter again."
      	computerTakeSides $playerSymbol $computerSymbol
   	fi
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
   switchSymbol=1
   isEmpty $playerPosition $playerSymbol $computerSymbol
   checkWinConditions $playerSymbol
   winningResult "PLAYER"
   switchPlayer=1
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
