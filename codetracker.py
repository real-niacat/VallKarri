import os  
import subprocess

def count_lines_of_code():

  # Get list of files tracked by the Git repository
  result = subprocess.run(['git', 'ls-files'], capture_output=True, text=True)
  files = result.stdout.splitlines()

  total_lines = 0
  for file in files:
    # Open the file in read mode, ignoring any encoding errors
    with open(file, 'r', errors='ignore') as f:
      # Concise way to count lines using a generator expression
      total_lines += sum(1 for _ in f)

  # Print the total number of lines found
  print(f"Total lines of code: {total_lines}")

if __name__ == "__main__":
  count_lines_of_code()