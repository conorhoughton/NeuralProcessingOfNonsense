import glob
import re

def checkStimuli(filepath):
	# note: this is asumming that the stimuli are numbered minStimulusValue, minStimulusValue+1 ... maxStimulusValue
	minStimulusValue = 10
	maxStimulusValue = 129

	stimuli = []
	for line in open(filepath, 'r'):
		if re.search("Stimulus", line):
			stimuli.append(line)

	# split all lines with the commas as delimiter
	stimuli = [line.split(',') for line in stimuli]
	
	# extract stimulus string
	stimuli = [line[1] for line in stimuli] # select only second field
	stimuli = [line.split()[-1].lstrip('S') for line in stimuli] # remove 'S' with .lstrip() and spaces with split()[-1]
	
	# extract stimulus integer value, remove those not in the specified range and sort
	stimuli = [int(stimulus) for stimulus in stimuli]
	stimuli = [stimulus for stimulus in stimuli if minStimulusValue <= stimulus and stimulus <= maxStimulusValue]
	stimuli.sort()

	# check if all the stimuli are there, exactly once
	stimulusCheck = minStimulusValue
	verify = True
	for stimulus in stimuli:
		if stimulus == stimulusCheck:
			stimulusCheck += 1
		else:
			verify = False
			break

	if verify is True:
		print("Found all stimuli in file", filepath.lstrip("../data/"))

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