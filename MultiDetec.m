function [Multiplets,Dendro] = MultiDetec(WF,Toa,PDM,dtmax) 
%% ---------- About ----------------   

% /!\ if no PDM is provided : 
% run [Multiplets,Dendro] = MultiDetec(WF,Toa,[],dtmax);


%% ---------- Parameters -----------
    fprintf('\n');
    fprintf("        °=====  MULTI-DETEC  =====°      ");
    fprintf('\n\n');

    %""" Cross-correlation parameters """
    para.pretrig_cut = 1; % Keep (0) or not (1) the pretrigger during calculation of dissimilarity between WF
    para.pretrig_length = 100; % Size of pretrigger in pts
    para.window = 450; % Size of the cross-correlation window

    %""" super-user parameters """ 
    % /!\ ONLY FOR SUPER-USERS
    para.minsize = 40; 
    para.d = 0.8;    
    para.minpts = 10;
    para.mat_size = 10000;
    para.degree = 50; % factor for selecting number of diagonals in Threshold()

    %% -------- Sub-functions ---------
    addpath('functions'); 

    %% -------- Main loop : pre-clustering --------
    fprintf("______________PRE-CLUSTERING_____________");
    fprintf('\n');
    n = length(Toa);
    WF = table2array(WF);
    k_PDM = fix(n/para.mat_size)+1;
    Pre_clusters = zeros(1,n);

    if isempty(PDM) 
        for k = 1:k_PDM
            fprintf("-------- Calculation of PDM %d/%d ---------",k,k_PDM);
            fprintf('\n');

            id_begin = (k-1)*para.mat_size+1;
            id_end = min(k*para.mat_size+1,n);
            Toa_k = Toa(id_begin:id_end);

            PDM = PartialDissimiMat(WF(:,id_begin:id_end),Toa_k,dtmax,para);

            epsilon(k) = Threshold(PDM,para.mat_size/para.degree);

            tc = MultiPeriod(PDM,Toa_k,epsilon(k));

            fprintf("-------- DBSCAN on PDM ------------------");
            fprintf('\n');

            % Matrix reduction
            dtmax = tc*para.minpts/(2*para.d);
            for i = 1:length(Toa_k)
                idx = find(abs(Toa_k-Toa_k(i))>dtmax);
                PDM(i,idx) = 1;
                PDM(idx,i) = 1;
            end

            % DBSCAN
            [Clust,Corpts(id_begin:id_end)] = dbscan(PDM,epsilon(k),para.minpts,"Distance","precomputed");

            % Re-numbering of pre-clusters and assignation  
            Clust(Clust>0) = Clust(Clust>0)+max(Pre_clusters);
            Pre_clusters(id_begin:id_end) = Clust;

            fprintf("Done");
            fprintf('\n\n');
        end
    else 
%         fprintf("-------- Calculation of PDM %d/%d ---------",k,k_PDM);
%         fprintf('\n');
        
        epsilon = Threshold(PDM,para.mat_size/para.degree);

        tc = MultiPeriod(PDM,Toa,epsilon);

        fprintf("-------- DBSCAN on PDM ------------------");
        fprintf('\n');

        % Matrix reduction
        dtmax = tc*para.minpts/(2*para.d);
        for i = 1:length(Toa)
            idx = find(abs(Toa-Toa(i))>dtmax);
            PDM(i,idx) = 1;
            PDM(idx,i) = 1;
        end

        % DBSCAN
        [Pre_clusters,Corpts] = dbscan(PDM,epsilon,para.minpts,"Distance","precomputed");

        fprintf("Done");
        fprintf('\n\n');
    end
    
    %% ----- Border points suppression
    Pre_clusters(Pre_clusters<0) = 0;
    Pre_clusters(Corpts==0) = 0;

    Cl = unique(Pre_clusters);
    for i = 1:length(Cl)
        id_multi = find(Pre_clusters==Cl(i));
        if length(id_multi)<para.minpts
           Pre_clusters(id_multi) = 0;
        end
    end

    %% ------ Assembly of multiple clustering
    fprintf("________CLUSTERING and DENDROGRAM________");
    fprintf('\n');

    Multiplets = MultiAssembly(WF,Pre_clusters,mean(epsilon),para);

    %% ------ Dendrogram calculation and plot
    
    % Hierarchical clustering (Ward's method) of multiplets according 
    % to their representative waveforms dissimilarities. 
    % (Representative waveform of a multiplet is by default defined as 
    % the median waveform of this multiplet)
    
    Dendro = MultiDendro(WF,Multiplets,para);
   
    %% ------ Multiplets hierarchical clustering (optional)
    % Note : from Dendro, one can extract clusters of multiplets by cutting
    % the dendrogram links (other ways of clustering also possible).
    
    % /!\ Not tu use here, just for any complementary analysis (out of
    % MultiDetec function)
    
    % ====== Parameter selected by user ======
%     level = 1.9; % Dendrogram cutting threshold
%     
%     Clusters = DendroCut(Dendro, level, Multiplets);
end
