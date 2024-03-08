function Centroid = MultiCentroid(WF,Multiplets,para,multi_selected,show)
    %% --------- Entries definition
    % WF : all waveforms of the AE dataset
    % Multiplets : list of multiplets numbers for each waveforms
    % para : structure of variables for cross-correlation 
    % multi_seleted : integer of the considered multiplet number
    % plotting : boolean for plotting centroid (1) or not (0)

    %% --------- Variables and cross-correlation parameters 
    if para.pretrig_cut == 1
        init = para.pretrig_length+1;
    else
        init = 1;
    end
    limit = init+para.window; % Pretrig_cut and pretrig_length define a translation of the window
    
    Id_multi = find(Multiplets == multi_selected);
    n = length(Id_multi);
  
    WF = WF(:,Id_multi);
    Centroid = WF(:,1);
    
    Support = 1:1:height(WF);
    
    %% -------- Centroid determination and plotting   
    % Waveforms suffer from translations (delays) that can be estimated by
    % finding the maximum of the cross-correlation between waveforms within
    % a multiplet. 
    
    % Calculation : Centroid is iteratively calculated by finding delays
    % between each waveforms and the centroid steps.
    for i = 2:n
        Signal = WF(:,i);
        [corr, t] = xcorr(Centroid(init:limit),Signal(init:limit),'normalized');
        [~, x] = max(corr);
        dt = -t(x);
        if dt>0
            Centroid(1:(end-dt)) = Centroid(1:(end-dt))+Signal((dt+1):end);
        else
            dt = abs(dt);
            Centroid((dt+1):end) = Centroid((dt+1):end)+Signal(1:(end-dt));
        end
        Centroid = Centroid./2;
    end
    
    % Plotting the centroid
    if show == 1
        f = figure; 
        hold on;
        f.Position = [0 0 800 350];
        plot(Support,Centroid,'Color',[0, 0.7, 0],'Displayname',"Centroid","linewidth",2);
        ylabel("Amplitude (V)");
        axis tight;
        xlim([0 limit]);
        legend();
        set(gca,"fontsize",15);
    end
end