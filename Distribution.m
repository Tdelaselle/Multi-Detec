function Distrib = Distribution(n,Cor,norm)
% Fonction calcul de la distribution  (n : nombre de pas, Cor : matrice de
% correlation, norm : 1/0 pour normalisé ou non)
    stck = find(Cor <= 1/n);
    Distrib(1) = length(stck);
    for i = 2:n
        stck = find(Cor <= i*1/n);
        Distrib(i) = length(stck)-sum(Distrib);
    end
%     Distrib(1) = 0;
    if norm == 1
        Distrib = Distrib/max(Distrib);
    end
end    

