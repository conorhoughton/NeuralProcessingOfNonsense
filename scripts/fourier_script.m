addpath /home/viethan/fieldtrip-20211020

clearvars

filepath_data = '/home/viethan/Documents/Projects/';
filenames = importdata([filepath_data,'filenames.txt'])
filepath_save = '/home/viethan/Documents/Projects/ft_output/';
dotvhdr  = '.vhdr';


sounds = {'nonsense', {'S 10', 'S 11', 'S 12', 'S 13', 'S 14', 'S 15', 'S 16', 'S 17', 'S 18', 'S 19', 'S 20', 'S 21', 'S 22', 'S 23', 'S 24', 'S 25', 'S 26', 'S 27', 'S 28', 'S 29', 'S 30', 'S 31', 'S 32', 'S 33', 'S 34', 'S 35', 'S 36', 'S 37', 'S 38', 'S 39'};
          'sense', {'S 40' 'S 41' 'S 42' 'S 43' 'S 44' 'S 45' 'S 46' 'S 47' 'S 48' 'S 49' 'S 50' 'S 51' 'S 52' 'S 53' 'S 54' 'S 55' 'S 56' 'S 57' 'S 58' 'S 59' 'S 60' 'S 61' 'S 62' 'S 63' 'S 64' 'S 65' 'S 66' 'S 67' 'S 68' 'S 69'}
          'nonsense_ctrl', {'S 70' 'S 71' 'S 72' 'S 73' 'S 74' 'S 75' 'S 76' 'S 77' 'S 78' 'S 79' 'S 80' 'S 81' 'S 82' 'S 83' 'S 84' 'S 85' 'S 86' 'S 87' 'S 88' 'S 89' 'S 90' 'S 91' 'S 92' 'S 93' 'S 94' 'S 95' 'S 96' 'S 97' 'S 98' 'S 99'} 
          'sense_ctrl', {'S100' 'S101' 'S102' 'S103' 'S104' 'S105' 'S106' 'S107' 'S108' 'S109' 'S110' 'S111' 'S112' 'S113' 'S114' 'S115' 'S116' 'S117' 'S118' 'S119' 'S120' 'S121' 'S122' 'S123' 'S124' 'S125' 'S126' 'S127' 'S128' 'S129'} 
          };
           
lpf = 25;
sample_freq = 1000;

ms=0.001;
word_length=320*ms;
number_of_words_per_sentence=4;
number_of_sentences_per_trial=13;

sentence_length = word_length*number_of_words_per_sentence;
trial_length = word_length*number_of_words_per_sentence*number_of_sentences_per_trial;


nonsensical = sounds(1, 2:end);
sensical = sounds(2, 2:end);
nonsensical_ctrl = sounds(3, 2:end);
sensical_ctrl = sounds(4, 2:end);
all_experiment = {[sensical{1}, nonsensical{1}]};
all_ctrl = {[sensical_ctrl{1}, nonsensical_ctrl{1}]};

blocks = {'nonsensical', nonsensical{1,1};
          'sensical', sensical{1,1};
          'nonsensical_ctrl', nonsensical_ctrl{1,1};
          'sensical_ctrl', sensical_ctrl{1};
           'experiment', all_experiment{1,1};
           'control', all_ctrl{1};
         };
            

for i = 1:length(blocks)

    block = blocks(i, 2:end);
    block_name = blocks(i, 1);
    
    for ii = 1:length(filenames)
        eeg_filename = strcat(filenames{ii})
        
        % defining trials
        
        cfg = [];
        cfg.dataset = strcat(filepath_data,eeg_filename,dotvhdr);
        cfg.trialdef.eventtype  = 'Stimulus';
        cfg.trialdef.eventvalue = block{1,1};
        cfg.trialdef.prestim    = -sentence_length*1;   % this cuts out one sentence length (ie. removes the first sentence)
        cfg.trialdef.poststim   = sentence_length*13;
        cfg = ft_definetrial(cfg);

        % preprocessing

        cfg.channel = 'EEG';
        cfg.demean = 'yes';
        cfg.reref='yes';
        cfg.refchannel = 'Cz';
        cfg.lpfilter = 'yes'; 
        cfg.lpfreq = lpf;
        data = ft_preprocessing(cfg)

        % computing fft

        cfg = [];
        cfg.method = 'mtmfft';
        cfg.foilim = [0.25 4];
        cfg.taper = 'hanning';
        cfg.output = 'fourier';
        freq = ft_freqanalysis(cfg, data)

    end

end



