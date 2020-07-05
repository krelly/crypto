## Implementation of Cryptographic Algorithms in ruby

Each folder contains:
- ruby class, implementing the cipher itself
- simple CLI interface, to get help just run a script without arguments `ruby filename.rb`
- a pdf file with instructions how specific algorithm should be implemented (in Ukrainian)

List of ciphers:
1. Caesar cipher - https://en.wikipedia.org/wiki/Caesar_cipher
2. Trithemius cipher - https://en.wikipedia.org/wiki/Tabula_recta#Trithemius_cipher
3. Encryption algorithm based on XOR cipher
4. Literature fragment cipher https://en.wikipedia.org/wiki/Book_cipher
5. DES cipher (using built-in OpenSSL module) 
6. Encryption based on Knapsack problem, includes simple GTK GUI (using gtk3 gem)
7. RSA encryption (using ruby built-in OpenSSL module)
   - public&private key pair generation
   - encryption using public key
   - decrypting data with private key


