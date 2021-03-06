addpath /home/viethan/fieldtrip-20211020

clearvars

filepath_data = '/home/viethan/Documents/Projects/NeuralProcessingOfNonsense/data/eeg_data/';
filenames = importdata([filepath_data,'filenames.txt']);
filepath_save = '/home/viethan/Documents/Projects/NeuralProcessingOfNonsense/data/csv_files/';

sounds = {'nonsense', {'S 10', 'S 11', 'S 12', 'S 13', 'S 14', 'S 15', 'S 16', 'S 17', 'S 18', 'S 19', 'S 20', 'S 21', 'S 22', 'S 23', 'S 24', 'S 25', 'S 26', 'S 27', 'S 28', 'S 29', 'S 30', 'S 31', 'S 32', 'S 33', 'S 34', 'S 35', 'S 36', 'S 37', 'S 38', 'S 39'};
          'sense', {'S 40' 'S 41' 'S 42' 'S 43' 'S 44' 'S 45' 'S 46' 'S 47' 'S 48' 'S 49' 'S 50' 'S 51' 'S 52' 'S 53' 'S 54' 'S 55' 'S 56' 'S 57' 'S 58' 'S 59' 'S 60' 'S 61' 'S 62' 'S 63' 'S 64' 'S 65' 'S 66' 'S 67' 'S 68' 'S 69'}
          'nonsense_ctrl', {'S 70' 'S 71' 'S 72' 'S 73' 'S 74' 'S 75' 'S 76' 'S 77' 'S 78' 'S 79' 'S 80' 'S 81' 'S 82' 'S 83' 'S 84' 'S 85' 'S 86' 'S 87' 'S 88' 'S 89' 'S 90' 'S 91' 'S 92' 'S 93' 'S 94' 'S 95' 'S 96' 'S 97' 'S 98' 'S 99'} 
          'sense_ctrl', {'S100' 'S101' 'S102' 'S103' 'S104' 'S105' 'S106' 'S107' 'S108' 'S109' 'S110' 'S111' 'S112' 'S113' 'S114' 'S115' 'S116' 'S117' 'S118' 'S119' 'S120' 'S121' 'S122' 'S123' 'S124' 'S125' 'S126' 'S127' 'S128' 'S129'} 
          };

lpf = 25;
sample_freq = 1000;
ms = 0.001;

word_length = 320 * ms;
number_of_words_per_sentence = 4;
number_of_sentences_per_trial = 13;

sentence_length = word_length * number_of_words_per_sentence;
trial_length = word_length * number_of_words_per_sentence * number_of_sentences_per_trial;

nonsensical = sounds{1,2};
sensical = sounds{2,2};
nonsensical_ctrl = sounds{3,2};
sensical_ctrl = sounds{4,2};
all_experiment = [nonsensical sensical];
all_ctrl = [nonsensical_ctrl sensical_ctrl];
all_stimuli = [all_experiment all_ctrl];


for x = 1:length(filenames)

    filename = strcat(filenames{x});
    file_out = strcat(filepath_save, filename, '_main.csv');
    file_coeff = strcat(filepath_save, filename, '_ft_coeff.csv');

    fd_out = fopen(file_out, 'w');
    fd_coeff = fopen(file_coeff, 'w');

    col_trial_number = [];
    col_electrode_number = [];

    
    for i = 1:length(all_stimuli) 
        temp = cellstr(repelem([int2str(i)], 32, 1));
        col_trial_number = [col_trial_number; temp];

        temp = rot90(arrayfun(@num2str,1:32,'Uni',0), 3);
        col_electrode_number = [col_electrode_number; temp];

        % defining trials
        
        cfg = [];
        cfg.dataset = strcat(filepath_data,filename,'.vhdr');
        cfg.trialdef.eventtype  = 'Stimulus';
        cfg.trialdef.eventvalue = all_stimuli{i}; % select one stimulus
        cfg.trialdef.prestim    = -sentence_length*1;   % this cuts out one sentence length (ie. removes the first sentence)
        cfg.trialdef.poststim   = sentence_length*13;
        cfg = ft_definetrial(cfg);

        % preprocessing

        cfg.channel = 'EEG';
        cfg.demean = 'yes';
        cfg.reref='yes';
        cfg.refchannel = 'all';
        cfg.lpfilter = 'yes'; 
        cfg.lpfreq = lpf;
        data = ft_preprocessing(cfg);

        % computing fft

        cfg = [];
        cfg.method = 'mtmfft';
        cfg.foilim = [0.25 4];
        cfg.taper = 'hanning';
        cfg.output = 'fourier';
        freq = ft_freqanalysis(cfg, data);
        
        for j = 1:32
            disp(strcat(all_stimuli{i}, ',', int2str(j)));
            coeff = num2cell(reshape(freq.fourierspctrm(:,j,:), [1,58]));
            writecell(coeff, file_coeff,'WriteMode','append');
        end

    end

    fclose(fd_coeff);

    cols_fourier_coeff = readcell(file_coeff);
    output = [col_trial_number col_electrode_number cols_fourier_coeff];
    writecell(output, file_out);

    fclose(fd_out);
end
