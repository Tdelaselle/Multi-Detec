function     PDM = PartialDissimiMat(WF,Toa,dtmax,para)
    %% --------- Notes ----------
%   PDM : partial dissimilarity matrix composed of cross-correlation maximums
   
    %% --------- Variables and cross-correlation parameters 
    if para.pretrig_cut == 1
        init = para.pretrig_length+1;
    else
        init = 1;
    end
    limit = init+para.window; % Pretrig_cut and pretrig_length define a translation of the window
    
    n = length(Toa);
    PDM = ones(n);
    
    %% -------- Running cross-correlation between WF
    tic
    for i = 1:n % Main loop visiting each waveforms
        PDM(i,i) = 0; % diagonal filling
        if mod(i,1000) == 0 
            fprintf(strcat("Step : ",string(i)));
            fprintf('\n');
        end
        j = i-1;
        while j>0 && (Toa(i)-Toa(j))<dtmax % Matrix coeff calculation condition based on time proximity
            [corr, ~] = xcorr(WF(init:limit,i),WF(init:limit,j),'normalized');
            PDM(j,i) = abs(1-max(corr)); % Dissimilarity measure placed in matrix
            PDM(i,j) = PDM(j,i); % Symetrizing 
            j = j-1;
        end
    end
    fprintf("successfully completed !");
    fprintf('\n');
    toc
    fprintf('\n');
end