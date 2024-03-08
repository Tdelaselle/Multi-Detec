function Clusters = MultiAssembly(WF,Clust,epsilon,para)
    %% -------- Notes ----------------------------------------------------
%   Clust : (from pre-clustering) clusters ids of partitioned multiplets
%   Clusters : (from clusters assembly) clusters = multiplets

%   DM : Dissimilarity matrix composed of distances between each
%        representatives of clusters. 

%   Representative : for each cluster of Clust, one waveform is selected. 
%                    as no consequent variations are observed whatever the
%                    representative is choosed, we select the first WF.
%                    But can be changed if needed (rep variable).
    %% ---- Variables and cross-correlation parameters -------------------
    if para.pretrig_cut == 1
        init = para.pretrig_length+1;
    else
        init = 1;
    end
    limit = init+para.window; % Pretrig_cut and pretrig_length define a 
                              % translation of the window
    Id_clust = unique(Clust);
    Id_clust(1) = []; % Delete pre-cluster 0 (noise pts)
    m = length(Id_clust); % pre-clusters amount
    DM = zeros(m);
    
    CTD = zeros(height(WF),m);
    
    %% -------- Pre-clusters centroids database --------------------------   
   for i = 1:m
      CTD(:,i) = MultiCentroid(WF,Clust,para,Id_clust(i),0); 
   end
    
    %% -------- Dissimilarity matrix of clusters representatives ---------
    fprintf("-------- Pre-clusters assembly ----------");
    fprintf('\n');

    for i = 1:m
%         Id_i = find(Id_clust(i)==Clust);
%         [~, Id_i_max] = max(max(WF(init:limit,Id_i)));
        for j = (i+1):m
%             Id_j = find(Id_clust(j)==Clust);
%             [~, Id_j_max] = max(max(WF(init:limit,Id_j)));
            [Corr, ~] = xcorr(CTD(init:limit,i),CTD(init:limit,j),'normalized');
            DM(i,j) = abs(1-max(Corr)); % Dissimilarity measure in matrix
        end
    end
    
    %% ------- Hierarchical clustering -----------------------------------
    % rearrangement of DM in vector (order (2,1), (3,1), ..., (m,1),..., (m,m – 1))
    DM_vec = DM(1,2:end);
    for i = 2:(size(DM,2)-1)
        DM_vec = [DM_vec, DM(i,(i+1):end)];
    end
    Tree = linkage(DM_vec,"median"); % Possibilty to select other methods :
    % single, complete, median, centroid, average. NOT Ward ! 
   
    % Verification plot (if needed)
%     f = figure;
%     f.Position = [0 0 1000 400];
%     dendrogram(Tree,m,"ColorThreshold",epsilon,"Orientation",'top',"Labels",string(Id_clust));
%     ylabel("Dissimilarity");
%     xlabel("Prec-cluster id");
%     set(gca,"fontsize",15);
%     axis tight;
%     title("Pre-clusters assembly");
    
    % Clustering by dissimilarity threshold (epsilon)
    Agnes_clust = cluster(Tree,'cutoff',epsilon,"criterion","distance");
    
    % Sortering of new clusters and filtering of to small ones
    Clusters = zeros(1,length(Clust));
    for i = 1:m
        Id = find(Id_clust(i)==Clust);
        if length(Id)>para.minsize        
            Clusters(Id) = Agnes_clust(i);
        else 
            Clusters(Id) = 0;
        end
    end
    fprintf("%d pre-clusters became %d multiplets !",m,length(unique(Clusters)));
    fprintf('\n\n');
end