function epsilon = Threshold(PDM,degree)
    fprintf("-------- Determination of epsilon -------");
    fprintf('\n');    
    D(:,1) = diag(PDM,1);
    for i = 2:degree
        D(i:end,i) = diag(PDM,i);
    end
    D(find(D==0)) = NaN;
    x = linspace(0,1,degree);
    distri = Distribution(degree,1-D,0);
    minDist = islocalmin(distri);
    epsilon = x(minDist);
    epsilon = 1-epsilon(end);
    distri = fliplr(distri(3:end));
    x = x(1:(end-2));
    
%     f = figure;
%     f.Position = [0 0 800 400];
%     hold on
%     plot(x,distri,'.-');
%     plot([epsilon epsilon],[0 max(distri)]); 
%     xlabel("Dissimilarity level");
%     ylabel("Dissimilarity distribution");
%     set(gca,"fontsize",15);
%     title("Epsilon automatic determination");

    fprintf("Epsilon : %4.2f",epsilon);
    fprintf("\n\n");
end

% function epsilon=seuil3(n,M)
%     D(:,1) = diag(M,1);
%     for i = 2:n
%         D(i:end,i) = diag(M,i);
%     end
%     D(find(D==0)) = NaN;
%     x = linspace(0,1,n);
%     distri = Distribution(n,1-D,0);
%     minDist = islocalmin(distri);
%     epsilon = x(minDist);
%     epsilon = 1-epsilon(end);
%     distri = fliplr(distri);
%     figure;
%     hold on
%     plot(x,distri,'.-');
%     plot([epsilon epsilon],[0 max(distri)]); 
%     xlabel("Dissimilarity level");
%     ylabel("Dissimilarity distribution");
% end
