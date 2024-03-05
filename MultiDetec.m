function [Multiplets,Dendro] = MultiDetec(WF,Toa,PDM,dtmax) 
    %% ---------- Parameters -----------
    fprintf('\n');
    fprintf("        °=====  MULTI-DETEC  =====°      ");
    fprintf('\n\n');

    para.pretrig_cut = 1; % Keep (0) or not (1) the pretrigger during calculation of dissimilarity between WF
    para.pretrig_length = 100; % Size of pretrigger in pts
    para.window = 450; % Size of the cross-correlation window

    %""" Infra-parameters """ 
    % /!\ ONLY FOR SUPER-USERS
    para.minsize = 40; 
    para.d = 0.15;
    para.mat_size = 10000;
    para.degree = 50; % factor for selecting number of diagonals in Threshold()
    para.minpts = 20;

    %% -------- Sub-functions ---------
    addpath('functions'); 

    %% -------- Main loop : pre-clustering --------
    fprintf("______________PRE-CLUSTERING_____________");
    fprintf('\n');
    n = length(Toa);
    WF = table2array(WF);
    k_PDM = fix(n/para.mat_size)+1;
    Pre_clusters = zeros(1,n);

    if PDM == [] 
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
        fprintf("-------- Calculation of PDM %d/%d ---------",k,k_PDM);
        fprintf('\n');
        
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
        [Clust,Corpts] = dbscan(PDM,epsilon,para.minpts,"Distance","precomputed");

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

    %% ----- Temporary results plot (pre-clusters)
    % HDD.MULTI = Pre_clusters'; % Pre_clustersers in HDD
    % % 
    % f = figure;
    % f.Position = [0 0 1000 400];
    % set(gca,"fontsize",15);
    % axis tight;
    % hold on;
    % plot(TDD.Time,TDD.PARA1,'-','Color',[0.9,0.9,0.9],'LineWidth',2);
    % gscatter(HDD.Time(find(HDD.MULTI==0)),HDD.PARA1(find(HDD.MULTI==0)),HDD.MULTI(find(HDD.MULTI==0)),"k",".",4,"off");
    % gscatter(HDD.Time(find(HDD.MULTI>0)),HDD.PARA1(find(HDD.MULTI>0)),HDD.MULTI(find(HDD.MULTI>0)),"w",".",9,"off");
    % gscatter(HDD.Time(find(HDD.MULTI>0)),HDD.PARA1(find(HDD.MULTI>0)),HDD.MULTI(find(HDD.MULTI>0)),"",".",4);
    % % title(strcat("Detected multiplets of ",Type," ",Materiau," ",Eprouvette,".",Numero));
    % xlabel("Time (s)");
    % ylabel("Load (kN)");

    %% ------ Assembly of multiple clustering
    fprintf("________CLUSTERING and DENDROGRAM________");
    fprintf('\n');

    Multiplets = MultiAssembly(WF,Pre_clusters,mean(epsilon),para);
    HDD.MULTI = Multiplets';

    f = figure;
    f.Position = [0 0 1000 400];
    set(gca,"fontsize",15);
    axis tight;
    hold on;
    plot(TDD.Time,TDD.PARA1,'-','Color',[0.9,0.9,0.9],'LineWidth',2);
    gscatter(HDD.Time(find(HDD.MULTI==0)),HDD.PARA1(find(HDD.MULTI==0)),HDD.MULTI(find(HDD.MULTI==0)),"k",".",4,"off");
    gscatter(HDD.Time(find(HDD.MULTI>0)),HDD.PARA1(find(HDD.MULTI>0)),HDD.MULTI(find(HDD.MULTI>0)),"w",".",9,"off");
    gscatter(HDD.Time(find(HDD.MULTI>0)),HDD.PARA1(find(HDD.MULTI>0)),HDD.MULTI(find(HDD.MULTI>0)),"",".",4);
    title(strcat(string(length(unique(Multiplets))-1)," detected multiplets"));
    xlabel("Time (s)");
    ylabel("Load (kN)");

    %% ------ Dendrogram calculation and plot
    Dendro = MultiDendro(WF,Multiplets,para);
end
