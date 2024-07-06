# Solution for CodeChef Testing Robot

def can_alice_and_bob_have_same_multiset(animals):
  """
  This function checks if Alice and Bob can have the same multiset of animals after Alice buys some.

  Args:
	  animals: A list of integers representing the type of each animal.

  Returns:
	  True if Alice and Bob can have the same multiset, False otherwise.
  """
  # Count the frequency of each animal type
  animal_counts = {}
  for animal in animals:
	animal_counts[animal] = animal_counts.get(animal, 0) + 1

  # Check if any animal type has an odd count
  for count in animal_counts.values():
	if count % 2 != 0:
	  return False  # Alice cannot buy half an animal

  return True  # All animal counts are even, Alice and Bob can have the same multiset

def main():
  """
  This function reads the input and calls the can_alice_and_bob_have_same_multiset function for each test case.
  """
  test_cases = int(input())
  for _ in range(test_cases):
	num_animals = int(input())
	animals = list(map(int, input().split()))
	if can_alice_and_bob_have_same_multiset(animals):
	  print("YES")
	else:
	  print("NO")

if __name__ == "__main__":
  main()