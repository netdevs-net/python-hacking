import statistics

def is_dominant(data_list):
  """
  Checks if there's a dominant element (more than half occurrences) in the given list.

  Args:
	  data_list: A list of elements.

  Returns:
	  "YES" if there's a dominant element, "NO" otherwise.
  """
  if not data_list:
	return None  # Handle empty list gracefully

  # Find the most frequent element(s)
  mode_values = statistics.multimode(data_list)

  # Check for dominant mode (more than half occurrences)
  count = data_list.count(mode_values[0])
  if count > len(data_list) / 2:
	return "YES"  # Dominant mode found
  else:
	return "NO"  # No dominant mode

def main():
  """
  Reads the number of test cases, processes each test case, and checks for a dominant element.
  """
  test_cases = int(input())

  for _ in range(test_cases):
	N = int(input())
	data_list = list(map(int, input().split()))  # Create a new list for each test case
	dominant = is_dominant(data_list)
	print(dominant)

if __name__ == "__main__":
  main()
