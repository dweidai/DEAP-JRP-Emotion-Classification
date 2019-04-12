%filespath = dir('/Users/apple/Desktop/eeglab14_1_2b/data_preprocessed_matlab/*.mat');
% the eeglab channel * data * trials
% deap is trials * channel * data
Directory = '/Users/apple/Desktop/eeglab14_1_2b/data_preprocessed_matlab/';
filename = strcat(Directory, filespath(1).name)
S = load(filename);
for k = 2:(numel(filespath))
    filename = strcat(Directory, filespath(k).name)
    S(k) = load(filename);
end
pre_filename = '/Users/apple/Desktop/eeglab14_1_2b/data_preprocessed_matlab/DEAP'
num = num2str(i)
post_filename = '.mat'
unused = 8;
[x, y, z] = size(S(1).data);
y = y - unused; %remove the unused channels
Channel = S(1).data(:,[1:y],:);
Channel = permute(Channel, [2,3,1]);
new_filename = strcat(pre_filename, num, post_filename)
save(new_filename,'Channel')
for i = 2:length(S)
    num = num2str(i)
    [x, y, z] = size(S(i).data);
    y = y - unused; %remove the unused channels
    Channel = S(i).data(:,[1:y],:);
    Channel = permute(Channel, [2,3,1]);
    new_filename = strcat(pre_filename, num, post_filename)
    save(new_filename,'Channel')
end
%should be 32 * 8064 * 1280
