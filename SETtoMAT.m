filespath = dir('/Users/apple/Desktop/eeglab14_1_2b/DEAP_ICA/*.set');
save_dir = '/Users/apple/Desktop/eeglab14_1_2b/ICA_Data/EEGData';
MAT = '.mat';
SET = '.set';
EEG = eeglab();
for k = 1:(numel(filespath))
    num = num2str(k);
    Directory = 'DEAP';
    filename = strcat(Directory, num, SET);
    EEG = eeg_checkset( EEG );
    EEG = pop_loadset('filename',filename,'filepath','/Users/apple/Desktop/eeglab14_1_2b/DEAP_ICA/');
    EEG = eeg_checkset( EEG );
    data = EEG.data;
    save_name = strcat(save_dir, num , MAT);
    save(save_name, 'data');
end
