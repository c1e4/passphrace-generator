#!/bin/bash

#######################################
# Function that will help to make a beutiful output depending on an iteration
# Globals:
#   SOMEDIR
# Arguments:
#   $1 - current iteration
#   $2 - desired message for user
# Outputs:
#   Writes location to stdout
#######################################

assemble_word() {
	for k in {1..5}
	do
		temp=$(shuf -i 1-6 | head -1)
		word=$word""$temp
	done
	echo "$word"
}


echo "count is: $1"
count=$1
for ((i = 1; i <= $1; i++))
do
	wordEncoded=$(assemble_word)
	#	if [ -z "$wordEncoded" ]; then
	#		echo "wordEncoded: $wordEncoded"
	#		echo "Exceptuion! EncodedWord is empty, generating again..."
	#		wordEncoded=$(assemble_word)
	#	fi

	if [ "$wordEncoded" = "" ]; then
		echo "wordEncoded: $wordEncoded"
		echo "Exceptuion! EncodedWord is empty, generating again..."
		wordEncoded=$(assemble_word)
	fi


	wordMeaning=$(pdfgrep -Ri $wordEncoded dicewarewordlist.pdf | grep -oE "$wordEncoded[[:space:]][A-Za-z0-9]\w*" | awk '{print $2}' | xargs)

	if [ -z "$wordMeaning" ]; then
		echo "wordMeaning: $wordMeaning"
		echo "Exceptuion! wordMeaning is empty, generating again..."
		wordMeaningu=$(assemble_word)
	fi

	echo "wordEncoded:$wordEncoded -> $wordMeaning"
	wordEncoded=""
done

