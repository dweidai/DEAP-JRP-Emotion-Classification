filespath = dir('/Users/apple/Desktop/eeglab14_1_2b/DEAP/*.mat');
disp(filespath)
%EEG = eeglab();
DEAP = 'DEAP ';
ICA = ' ICA';
save_dir = '/Users/apple/Desktop/eeglab14_1_2b/DEAP_ICA/';
post_filename = '.set';
disp(numel(filespath))

for k = 1:(numel(filespath))
    Directory = '/Users/apple/Desktop/eeglab14_1_2b/DEAP/';
    filename = strcat(Directory, filespath(k).name)
    EEG = pop_importdata('dataformat','matlab','nbchan',32,'data',filename,'srate',128,'pnts',0,'xmin',0,'chanlocs','/Users/apple/Desktop/eeglab14_1_2b/DEAP.ced');
    num = num2str(k)
    cur_setname = strcat(DEAP, num, ICA);
    EEG.setname= cur_setname;
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',1,'interupt','on','pca',31);
    EEG.data = EEG.icawinv * EEG.icaact
    EEG = eeg_checkset( EEG );
    save_name = strcat(DEAP, num, post_filename);
    EEG = pop_saveset( EEG, 'filename', save_name,'filepath',save_dir);
    EEG = eeg_checkset( EEG );
end; 
