# Quick code snippet to run ROT-based decryption

def decode_caesar_cipher(ciphertext, shift):
    decoded_text = []
    for char in ciphertext:
        if char.isalpha():
            shifted = ord(char) - shift
            if char.islower():
                if shifted < ord('a'):
                    shifted += 26
                decoded_text.append(chr(shifted))
            elif char.isupper():
                if shifted < ord('A'):
                    shifted += 26
                decoded_text.append(chr(shifted))
        else:
            decoded_text.append(char)
    return ''.join(decoded_text)

# turns out this is not
ciphertext = "Xjnvw lc sluxjmw jsqm wjpmcqbg jg wqcxqmnvw; xjzjmmjd lc wjpm sluxjmw jsqm bqccqm zqy.” Zlwvzjxj Zpcvcol"

for shift in range(1, 26):
    decoded_text = decode_caesar_cipher(ciphertext, shift)
    print(f"Shift {shift}: {decoded_text}")
