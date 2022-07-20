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

#Function that generates a sequence of random numbers in range [1-6] with total length 5
assemble_word() {
	for k in {1..5}
	do
		#generate random number in range [1-6] and pick only 1
		temp=$(shuf -i 1-6 | head -1)
		#on each iteration append previously generated number 
		word=$word""$temp
	done
	#echo "${ORANGE}assemble_word: ${word}${NC}"
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

#variable for actual length of a passphrase
actualLength=0

#for number of words required for a passphrase generate sequences
for ((i = 1; i <= $1; i++))
do
	#generate numbered sequence (encoded word), function invocation
	numberedSequence=$(assemble_word)

	#decode numbered sequence into a word using pdfgrep
	wordMeaning=$(pdfgrep -Ri $numberedSequence dicewarewordlist.pdf | grep -oE "$numberedSequence[[:space:]][A-Za-z0-9]\w*" | awk '{print $2}' | xargs)

	#sometimes a word cannot be decoded [unindentified root cause, approximately occurs in 1 of 25 requests]
	# until decoded word is empty
	until ! [[ -z "${wordMeaning}" ]]
	do
		#generate numbered sequence again
		numberedSequence=$(assemble_word)
		#try to decode
		wordMeaning=$(pdfgrep -Ri $numberedSequence dicewarewordlist.pdf | grep -oE "$numberedSequence[[:space:]][A-Za-z0-9]\w*" | awk '{print $2}' | xargs)
	done


	#send decoded word to stdout
	echo "numberedSequence:$numberedSequence -> $wordMeaning"

	#add current word to total passphrase
	totalPassphrase=$totalPassphrase" $wordMeaning"

	#increment actual length after adding wordMeaning on current iteration
	((actualLength++))

	#reset variable for a next iteration
	numberedSequence=""
done

totalPassphrase=$(echo "${totalPassphrase}" | xargs)

echo -e "\n${ORANGE}The generated passhrase is:${NC}"
echo -e "${LIGHT_BLUE}| | | | | | | | | | | | | | |${NC}"
echo -e "${LIGHT_BLUE}▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼${NC}"
echo "=============================="
echo -e "${GREEN}$totalPassphrase${NC}"
echo -e "==============================\n"

#final check if for some reason total number of words is less than requested
if [[ actualLength -ne $1 ]]; then
	echo -e "${RED}Something went wrong${NC}"
fi
