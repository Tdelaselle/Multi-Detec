function WF = Import_WF(path) % Give the path of the folder containing the waveforms files
%%% /!\ the waveforms files must have only one column (data points only)
    WF = [];
    skip_rows = 13;

    % Get a list of all .txt files in the directory
    fileList = dir(fullfile(path, '*.txt'));

    % Loop through each file and read its contents
    for k = 1:length(fileList)
        % Get the full file name (including path)
        fileName = fullfile(path, fileList(k).name);
        
        % Display the file name
        fprintf('Reading file: %s\n', fileName);
        
        % Read the content of the file
        fileContent = readlines(fileName); 
        Waveform = fileContent(skip_rows:end);
        WF(:,k) = str2double(Waveform);
    end
end