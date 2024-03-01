function Dendro = MultiDendro(WF,Clusters,para)
    %% ---- Variables and cross-correlation parameters -------------------
    rep = 1; % clusters representative determination
    if para.pretrig_cut == 1
        init = para.pretrig_length+1;
    else
        init = 1;
    end
    limit = init+para.window; % Pretrig_cut and pretrig_length define a 
                              % translation of the window
    Id_clust = unique(Clusters);
    Id_clust(1) = []; % Delete cluster 0 (noise pts)
    m = length(Id_clust); % multiplets amount
    DM = zeros(m);
    
    %% -------- Dissimilarity matrix of clusters representatives ---------
    fprintf("--- Multiplets hierarchical clustering --");
    fprintf('\n');
    for i = 1:m
        Id_i = find(Id_clust(i)==Clusters);
        for j = (i+1):m
            Id_j = find(Id_clust(j)==Clusters);
            [Corr, ~] = xcorr(WF(init:limit,Id_i(rep)),WF(init:limit,Id_j(rep)),'normalized');
            DM(i,j) = abs(1-max(Corr)); % Dissimilarity measure in matrix
        end
    end
    
    %% ------- Hierarchical clustering -----------------------------------
    % rearrangement of DM in vector (order (2,1), (3,1), ..., (m,1),..., (m,m – 1))
    DM_vec = DM(1,2:end);
    for i = 2:(size(DM,2)-1)
        DM_vec = [DM_vec, DM(i,(i+1):end)];
    end
    Dendro = linkage(DM_vec,"ward");
    
    f = figure;
    f.Position = [0 0 1000 400];
    dendrogram(Dendro,m,"Orientation",'top',"Labels",string(Id_clust));
    ylabel("Recomputed dissimilarity (Ward' method)");
    xlabel("Multiplets id");
    set(gca,"fontsize",15);
    axis tight;
    title("Multiplets dissimilarity structure");
end