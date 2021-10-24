import glob
import re

def main():
	# searching for .vmrk files
	filenames = glob.glob('../data/*.vmrk')

	if len(filenames) == 0:
		print("No .vmrk files were found in ../data/")
		return

	# printing found .vmrk files
	print("Found the following .vmrk files in ../data/\n")
	files = [file.lstrip("../data/") for file in filenames]
	files.sort()
	print("\n".join(files))

	# procedure that combines two files if the data is split into multiple files
	# procedure that checks a file

if __name__ == "__main__":
	main()