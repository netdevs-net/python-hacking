# This is a full revision from Gemini. 

from collections import Counter

def min_cost_pangram(prices, text):
  """
  Calculates the minimum cost to turn a string into a pangram.

  Args:
	  prices: A list of 26 integers representing the cost of each letter.
	  text: A string containing the initial text.

  Returns:
	  The minimum cost to make the text a pangram.
  """
  # Pre-calculate character indices (a-z) for faster lookups
  char_indices = {chr(i): i - ord('a') for i in range(ord('a'), ord('z') + 1)}
  
  # Count letter frequencies in the text using Counter
  text_counts = Counter(text)
  
  missing_letters = set()
  for char, count in text_counts.items():
	if count == 0:
	  missing_letters.add(char)
  
  # Calculate total cost using list comprehension and pre-calculated indices
  return sum(prices[char_indices[char]] for char in missing_letters)

def main():
  """
  Reads input, solves test cases, and prints output.
  """
  t = int(input())  # Number of test cases
  for _ in range(t):
	prices = [int(x) for x in input().split()]  # Read prices
	text = input()  # Read text
	cost = min_cost_pangram(prices, text)
	print(cost)

if __name__ == "__main__":
  main()