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
	echo "Symbol Assigned to Computer  : $computerSymbol"
}

#To check who plays First
function checkWhoPlaysFirst() {
	if [ $((RANDOM%2)) -eq 0 ]
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

	#To determine who has won
	if [[ $isWin -eq 1 ]]
	then
		echo "$2 Won"
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
	if [[ $switchSymbol -eq 1 ]]
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

function playersTurn() {
	read -p "Its Player's turn. Enter your move: " playerPosition
	switchSymbol=1
	isEmpty $playerPosition $playerSymbol $computerSymbol
	checkWinConditions $playerSymbol "PLAYER"
	switchPlayer=1
}

function computersTurn() {
	computerPosition=$((RANDOM%9+1))
	echo "Its Computer's turn. Computer's move:  $computerPosition"
	switchSymbol=2
	isEmpty $computerPosition $playerSymbol $computerSymbol
	checkWinConditions $computerSymbol "COMPUTER"
	switchPlayer=0
}

function switchThePlayers() {
 while [[ $count -ne 9 ]]
   do
      if [[ $switchPlayer -eq 0 ]]
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
