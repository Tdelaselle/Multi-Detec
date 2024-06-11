function [HDD,Toa] = Import_AE(filepath) % give complete file path    
    %%% Works for HDD and TDD
    % Import parameters
    opts = delimitedTextImportOptions('DataLines',9,'Delimiter',' ','ConsecutiveDelimitersRule','join','VariableNamesLine',8,"VariableTypes",'double');
    opts = setvartype(opts,{'double'});
    % Import data 
    HDD = readtable(filepath,opts);
    HDD(:,1:2) = [];
    for i = 1:width(HDD)
        HDD.(i) = str2double(HDD.(i));
    end
    HDD.Properties.VariableNames{1} = 'Time';
    Toa = HDD.Time;
end