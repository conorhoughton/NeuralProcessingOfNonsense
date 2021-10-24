import glob
import re

def checkStimuli(filepath):
	# Note: This is asumming that the stimuli are numbered minStimulusValue, minStimulusValue+1 ... maxStimulusValue
	minStimulusValue = 10
	maxStimulusValue = 129

	stimuli = []
	for line in open(filepath, 'r'):
		if re.search("Stimulus", line):
			stimuli.append(line)

	# split all lines with the comma as delimiter
	stimuli = [line.split(',') for line in stimuli]
	
	# extract stimulus string
	stimuli = [line[1] for line in stimuli] # select only second field
	stimuli = [line.split()[-1].lstrip('S') for line in stimuli] # remove 'S' with .lstrip() and spaces with split()[-1]
	
	# extract stimulus integer value, remove those not in the specified range and sort
	stimuli = [int(stimulus) for stimulus in stimuli]
	beyond = [stimulus for stimulus in stimuli if stimulus > maxStimulusValue]
	beyond = list(set(beyond))
	stimuli = [stimulus for stimulus in stimuli if minStimulusValue <= stimulus and stimulus <= maxStimulusValue]
	stimuli.sort()

	# check if all the stimuli are there, exactly once
	stimulusCheck = minStimulusValue
	verify = True
	missing = []
	repeated = []

	for stimulus in stimuli:
		if stimulus == stimulusCheck:
			stimulusCheck += 1
		else:
			if stimulus == stimulusCheck-1 and stimulus not in repeated:
				repeated.append(stimulus)
			if stimulus > stimulusCheck:
				for i in range(stimulusCheck, stimulus):
					missing.append(i)
				stimulusCheck = stimulus+1
			verify = False

	if verify is True:
		print("** Found all stimuli exactly once in file " + filepath.lstrip("../data/"))
	else:
		print("** Failed to find all stimuli exactly once in file " + filepath.lstrip("../data/"))
		print("Missing: " + str(missing))
		print("Repeated: " + str(repeated))
		print("Stimuli value bigger than " + str(maxStimulusValue) +": " + str(beyond))

def findparticipantIds(filenames):
	# Note: This is assuming that the .vmrk files are of the format [participantId]_[day]_[month]_[year].vmrk
	# eg filenames input: ['S7_13_07_2018.vmrk', 'S2_03_07_2018.vmrk']
	# output: ['S7_', 'S2_']
	# we keep the underscore in order to differentiate (for eg) S1 and S11

	# find the ids
	participantIds = [filename.split('_')[0] + '_' for filename in filenames]
	
	# remove duplicates
	participantUniqIds = []
	for participantId in participantIds:
		if participantId.lower() not in participantUniqIds and participantId.upper() not in participantUniqIds:
			participantUniqIds.append(participantId)

	return participantUniqIds

def findSplittedFiles(participantId, filepaths):
	# Note: This is assuming that the splitted files still contain the participant id somewhere in the filename
	# eg: S7_13_07_2018.vmrk, s7_13_07_2018_part2.vmrk, s7_13_07_2018_part3.vmrk
	# takes care if the letter case is not consistent

	return [filepath for filepath in filepaths if participantId.lower() in filepath.lower()]

def concatenateSplittedFiles(participantId, filepaths, outputFilename):
	with open(outputFilename, 'w+') as outfile:
		for filepath in filepaths:
			with open(filepath, 'r') as infile:
				for line in infile:
					outfile.write(line)

def main():
	# searching for .vmrk files
	filepaths = glob.glob('../data/*.vmrk')

	if len(filepaths) == 0:
		print("No .vmrk files were found in ../data/")
		return

	# printing found .vmrk files
	print("Found the following .vmrk files in ../data/\n")
	filenames = [file.lstrip("../data/") for file in filepaths]
	filenames.sort()
	print("\n".join(filenames) + "\n")

	participantIds = findparticipantIds(filenames)
	
	# procedure that combines files if the participant data is split into multiple files
	for participantId in participantIds:
		paths = findSplittedFiles(participantId, filepaths)
		if len(paths) > 1: # we only concatone if there are more than one file for the same participant
			print("Participant " + participantId[:-1] + "'s data is split in multiple .vmrk files\n")
			concatenatedFilePath = "../data/" + participantId + 'concatenated.vmrk'

			if concatenatedFilePath not in filepaths: # concatenated file is not there; we add it and remove the others
				concatenateSplittedFiles(participantId, paths, concatenatedFilePath)

			filepaths = [filepath for filepath in filepaths if filepath not in paths] # remove old filepaths from the list
			filepaths.append(concatenatedFilePath) # add the new filepath to the concatenated file
	print("\n")

	# procedure that checks a file
	filepaths.sort() # easier reading
	for filepath in filepaths:
		checkStimuli(filepath)

if __name__ == "__main__":
	main()