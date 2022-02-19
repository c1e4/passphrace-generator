# passphrase-generator
***Important note:*** this is a test project done solely for educational purposes. For critical applications and other sensetive stuff you would probably like to rely on something else. You've been warned, so use it at your own risk. 

Simple bash script that will allow you to easily generate passphrase. Source for passwords is a well-known "dice word list" in PDF format (bundled with the script).

**How it works:**
The script generates sequence of five pseudo-random integer numbers in range 1-6 via UNIX command shuff.
Then it uses pdfgrep to search for resulted word in supplied PDF file (dicewarewordlist.pdf)

**How to use:** 
1) Install pdfgrep
```
sudo apt show pdfgrep
```
2) Clone repository.
```
git clone https://github.com/c1e4/passphrase-generator.git
```
3) Navigate to cloned repository.
```
cd passphrase-generator
```
4) Make the script executable.
```
chmod u+x passphrase-generator.sh
```
5) Run the script with passing a desired number of words in your passphrase.
```
./passphrase-generator.sh 5

count is: 5
wordEncoded:55445 -> statue
wordEncoded:26443 -> fungal
wordEncoded:25415 -> fh
wordEncoded:62655 -> verdi
wordEncoded:25412 -> ffff
``` 

6) Just copy-paste generated words into an input form. 
