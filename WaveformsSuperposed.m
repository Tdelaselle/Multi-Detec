function Dt_mat = WaveformsSuperposed(WF,Multiplets,para,multi_selected)
    %/!\ According to the multiplet (or cluster) size, the calculation can be
    %relatively long ; e.g. several minutes for more than 1k waveforms (personnal standard
    % computer)

    %% --------- Variables and cross-correlation parameters 
    if para.pretrig_cut == 1
        init = para.pretrig_length+1;
    else
        init = 1;
    end
    limit = init+para.window; % Pretrig_cut and pretrig_length define a translation of the window
    
    Id_multi = find(Multiplets == multi_selected);
    n = length(Id_multi);
    h = height(WF);
    
    Dt_mat = zeros(n,n);
    Centroid = zeros(h,1);
  
    WF = WF(:,Id_multi);
    
    Support = 1:1:height(WF);
    
    %% --------- Delay matrix calculation (cross-correlation)
    % Waveforms suffer from translations (delays) that can be estimated by
    % finding the maximum of the cross-correlation between each couple of
    % waveforms within a multiplet. 
    
    % Calculation : Matrix of each delay between waveforms
    for i = 1:n
        for j = (i+1):n
            [corr, t] = xcorr(WF(init:limit,i),WF(init:limit,j),'normalized');
            [~, x] = max(corr);
            Dt_mat(i,j) = t(x);
        end
    end   
    Dt_mat = Dt_mat+Dt_mat';

    % Finding multiplet reference to align all waveforms on it
    [~, col] = find(Dt_mat<0);
    id = histcounts(col,unique(col));
    id_ref = find(id==min(id));
    
    %% -------- Centroid determination and waveforms plotting   
    % Plotting all waveforms superposed with the multiplet centroid
    f = figure;
    f.Position = [0 0 800 350];
    hold on;
    title("Multiplet waveforms superposition");
    subtitle("increasing emission time : blue towards red (green : centroid)")
    for i = 1:n
        t = Dt_mat(id_ref,i);
        fprintf(string(t));
        Signal = WF(:,i);
        if t>=0
            Centroid(1:(end-t)) = Centroid(1:(end-t))+Signal((t+1):end);
        else
            t = abs(t);
            Centroid((t+1):end) = Centroid((t+1):end)+Signal(1:(end-t));
        end
        plot(Support-t,Signal,"linewidth",1,"Color",[9*i/(10*n) 2*i/(10*n) 1-8*i/(10*n)],'HandleVisibility','off');
    end
    Centroid = Centroid./n;
    plot(Support,Centroid,'Color',[0, 1, 0, 1],'Displayname',"Centroid","linewidth",2);
    ylabel("Amplitude (V)");
    axis tight;
    xlim([0 limit]);
    legend();
    set(gca,"fontsize",15);

end