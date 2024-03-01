function tc = MultiPeriod(PDM,Toa,epsilon)
    %% ------- Notes ----------
%     tc : approximate emission period of multiplets 
%     dt : time limit for reduction of PDM
    %% ------- Parameters
    iteration = 0;
    freq_multi = 100000;
    minpts = 10;
  
    %% ------- Main loop : estimation of tc ----------
    fprintf("-------- Estimation of tc ---------------");
    fprintf('\n');
    while 1
        iteration = iteration+1;
        [Multi1,~] = dbscan(PDM,epsilon,minpts,"Distance","precomputed");
        
        Clust = unique(Multi1);
        for i = 1:length(Clust)
            Id_multi = find(Multi1==Clust(i));
            tbh = Toa(Id_multi(2:end))-Toa(Id_multi(1:(end-1)));  % tbh pour chaque signal du multi courant
            tbh_mean(i) = mean(tbh);
            tbh_std(i) = std(tbh);
        end
        
        % Stop calculation if not multiplets
        if length(tbh_std)==1
            fprintf("Pas de multiplets");
            break;
        end
        
        [best_std,best_multi] = min(tbh_std(2:end));
        freq_multi_old = freq_multi;
        freq_multi = 1/tbh_mean(best_multi+1);
        
        tc = 1/freq_multi;

        fprintf("Iteration %d, tc = %4.2f",iteration,tc);
        fprintf("\n");
        
        % Convergence : end of tc estimation
        if abs((freq_multi-freq_multi_old)/freq_multi_old)<0.001
            fprintf("Convergence");
            fprintf("\n\n");
            break;
        end
        
        dt = tc*minpts/2; % dt update
       
        % Partial dissimilarity matrix reduction (by dt)
        for i = 1:length(Toa)
            idx = find(abs(Toa-Toa(i))>dt);
            PDM(i,idx) = 1;
            PDM(idx,i) = 1;
        end
    end
end
