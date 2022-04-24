#!/bin/bash

#######################################
# Function that will make a secuence of five pseudo-randomly generated integer numbers 
# Outputs:
#   Writes resulted sequence to stdout
#######################################

#####################
#CONSTANTS

#colors
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m' # No Color


#regex to check whether the provided argument is positive number
CHECK_POS_NUMBER_REGEX='^[0-9]+$'

#regex to target user input which has to be 'y'
INPUT_CHOICE_REGEX='^[Yy]?$'
#####################


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

#check if provided passphrase length is number and greater than 0
if ! [[ $1 =~ $CHECK_POS_NUMBER_REGEX ]] || [[ $1 -le 0  ]] ; then
	echo -e "${RED}Error: Please provide an integer positive number as an argument.${NC}">&2;
	exit 1
fi


#check if user wants the passphrase to be 30 or more words long
if [[ $1 -ge 30 ]]; then
	echo -e "${ORANGE}Excessive passphrase difficulty and generation may take up to several minutes.\nDo you want to proceed? (Y/N)${NC}";
	read -p "Your choice: " choice;
	#choice to uppercase
	choice=${choice^^}

	if ! [[ $choice =~ $INPUT_CHOICE_REGEX ]] && [[ "$choice" != "YES" ]]; then
		echo -e "${RED}Abort.${NC}">&2;
		exit 1
	else
		echo -e "${GREEN}OK!${NC}"
	fi

fi


#outputs number of words required for a passphrase (argument #1) 
echo -e "passphrase length: $1\n"
#variable to store total generated passphrase
totalPassphrase=""
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
	#add current word to total passphrase
	totalPassphrase=$totalPassphrase" $wordMeaning"
	#reset variable for a next iteration
	wordEncoded=""
done

echo -e "\n${ORANGE}The generated passhrase is:${NC}"
echo -e "${LIGHT_BLUE}| | | | | | | | | | | | | | |${NC}"
echo -e "${LIGHT_BLUE}▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼${NC}"
echo "=============================="
echo -e "${GREEN}$totalPassphrase${NC}"
echo -e "==============================\n"
