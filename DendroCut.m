function Clusters = DendroCut(Dendro, level, Multiplets)
    % Sortering of new clusters and filtering of to small ones
    Id_clust = unique(Multiplets);
    Id_clust(1) = []; % Delete cluster 0 (noise pts)    
    m = length(Id_clust); % multiplets amount

    % Clustering by dissimilarity threshold (epsilon)
    Agnes_clust = cluster(Dendro,'cutoff',level,"criterion","distance");
    
    % Verification plot (if needed)
    f = figure;
    f.Position = [0 0 1000 400];
    dendrogram(Dendro,m,"ColorThreshold",level,"Orientation",'top',"Labels",string(Id_clust));
    ylabel("Recomputed dissimilarity (Ward' method)");
    xlabel("Multiplets id");
    set(gca,"fontsize",15);
    axis tight;
    title("Multiplets hierarchical clustering");
    
    Clusters = zeros(1,length(Multiplets));
    for i = 1:m
        Id = find(Id_clust(i)==Multiplets);
        Clusters(Id) = Agnes_clust(i);
    end
end