The following observations were made after running the script verifyVmkr.py:

    * P1 contains many missing stimuli. It also contains stimuli > 129
    * S13 and S15 are both suffixed by _part2, I was not able to find the first part but the script found all stimuli from 10 to 129
    * S4 is missing 15
    * S7 (the concatenated version) is missing 31, 32 and 33. There are repeated stimuli - probably because of the concatenation, but this shouldn't have happened anyway, right?
    * S8 had repeated stimuli 100, 101, 102, 103, 104 (2 stimuli for each case)
    * S1, S2, S3, S5, S6, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18 are fine

The .vmrk files of the participants with missing stimuli (P1, S4, S7), along with their corresponding .vhdr files, were moved into data/other_subjects/.
A copy of the old S8 .vmrk file is here. The new one that is currently present in data/ has the second instance of the repeated stimuli removed in each case.
This leaves us with the data of 16 participants: S1, S2, S3, S5, S6, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18.
