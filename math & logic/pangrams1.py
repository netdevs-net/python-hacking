# this is my code mixed with Gemini Code

def min_cost_pangram(prices, text):
  """
  Calculates the minimum cost to turn a string into a pangram.

  Args:
	  prices: A list of 26 integers representing the cost of each letter.
	  text: A string containing the initial text.

  Returns:
	  The minimum cost to make the text a pangram.
  """
  missing_letters = set(chr(i) for i in range(ord('a'), ord('z') + 1)) - set(text)
  return sum(prices[ord(char) - ord('a')] for char in missing_letters)

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