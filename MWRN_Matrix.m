
%load the file 
filename = '/Users/apple/Desktop/eeglab14_1_2b/data_preprocessed_matlab/s01.mat'
S = load(filename);
unused = 8;
[x, y, z] = size(S.data);
y = y - unused; %remove the unused channels
Channel = S.data(:,[1:y],:);
Channel = permute(Channel, [2,3,1]);% channel * data * trials
%z=1;
%select the trial
for count=1:z
    trial = Channel(:,:,1);
    [x, y] = size(trial);

    %equation 1
    p = y; %number of sub-signals
    N = x; %number of channels
    X = cell(N,1);
    for t =1: N
        %xk = trial(t,k);
        xk = trial(t, :);
        %mmax = 2*p+1; %2m+1 is efficient
        %   x  - scalar time series
        %   m  - delay time (if too small use dc = 1)
        %   D  - maximum embedding dimension to consider (don't go crazy)
        %   n  - number of phase space points to consider
        m = 3;% fnn(xk, 1, mmax, p);
        tau = 1; %xcorr(xk); %cross correlation of the time delay
        %it means that there is a 0.31 seconds delay between each epoch
        N1 = length(xk);
        N2 = N1 - tau * (m - 1);
        clear xe
        for mi = 1:m
            xe(:, mi) = xk([1:N2] + tau * (mi-1));
        end
        X{t} = xe;
    end

    %equation 2
    RR = 0.1;
    RP = zeros(p,1);
    for t=1:N
        disp(t)
        mat = cell2mat(X(t));
        for k = 1:p
            epsilon = 1;%RR;
            for i = 1: N
                for j = 1:N
                    epsilon_temp = 1 - norm((mat(i,:) - mat(j,:)), 2);
                    if epsilon_temp > 0 && epsilon_temp < epsilon
                        epsilon = epsilon_temp;
                    end
                end
            end
            RP(t, 1) = epsilon;
        end
    end

    %equation 3
    JRP = zeros(p,p);
    for i = 1:p
        disp(i)
        for j = 1:p
            if i == j
                JRP(i,j) = RP(i);
            else
                JRP(i,j) = RP(i) * RP(j);
            end
        end
    end

    %euqation 4
    JRR = zeros(N, N);
    for i=1:N
        for j = 1:N
            x_i = int32(32*(i-1))+1;
            x_j = int32(32*i);
            y_i = int32(32*(j-1))+1;
            y_j = int32(32*j);
            xki_xkj = JRP(x_i:x_j, y_i:y_j);
            JRR(i,j) = sum(sum(xki_xkj)) / (N*N);
        end
    end

    %equation 5
    S = zeros(N,N);
    for i=1:N
        for j = 1:N
            S(i,j) = JRR(i,j)/RR;
        end
    end

    imagesc(S)
end


