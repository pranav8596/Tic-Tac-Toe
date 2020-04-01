#!/bin/bash -x

#Declaration of the Game Board Array
declare -a gameBoard

#To reset the Game Board
function resetTheBoard() {
	gameBoard=(0 1 2 3 4 5 6 7 8 9)
}
