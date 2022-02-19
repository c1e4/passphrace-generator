#!/bin/bash

#######################################
# Function that will make a secuence of five pseudo-randomly generated integer numbers 
# Outputs:
#   Writes resulted sequence to stdout
#######################################

assemble_word() {
	for k in {1..5}
	do
		#generate random number in range [1-6] and pick only 1
		temp=$(shuf -i 1-6 | head -1)
		#on each iteration append previously generated number 
		word=$word""$temp
	done
	#send resulted secuence of numbers to stdout
	echo "$word"
}

#outputs number of words required for a passphrase (argument #1) 
echo "count is: $1"
#for number of words required for a passphrase generate sequences
for ((i = 1; i <= $1; i++))
do
	#function invocation
	wordEncoded=$(assemble_word)

	#if the word cannot be recognoized (empty), then try to generate again (still does not work, sadly)
	if [ "$wordEncoded" = "" ]; then
		echo "wordEncoded: $wordEncoded"
		echo "Exceptuion! EncodedWord is empty, generating again..."
		wordEncoded=$(assemble_word)
	fi

	#decode numbered sequence into a word using pdfgrep
	wordMeaning=$(pdfgrep -Ri $wordEncoded dicewarewordlist.pdf | grep -oE "$wordEncoded[[:space:]][A-Za-z0-9]\w*" | awk '{print $2}' | xargs)

	#again check, however still cannot be handled
	if [ -z "$wordMeaning" ]; then
		echo "wordMeaning: $wordMeaning"
		echo "Exceptuion! wordMeaning is empty, generating again..."
		wordMeaningu=$(assemble_word)
	fi
	
	#send decoded word to stdout
	echo "wordEncoded:$wordEncoded -> $wordMeaning"
	#reset variable for a next iteration
	wordEncoded=""
done

