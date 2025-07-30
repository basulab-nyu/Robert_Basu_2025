function [] = extract_behavior(input_folder,output_folder)
	if (exist(output_folder,'dir'))
        behav_file = strcat(output_folder,'\Behavior.mat');
        if isfile(behav_file) == 1
        %if isempty(jdir(output_folder,'Behavior.mat')) == 0
            fprintf('\nbehavior already extracted\n');
            return
        end 
	end
    fprintf('\nextracting behavior\n');
    files = jdir(input_folder,'*.csv');
    if(isempty(files))
        fprintf('\nNo .CSV file in folder %s\n',input_folder);
        return;
    end
    CSV = csvread(fullfile(input_folder,files(1).name),1,0);
    options.mindist=10; %min distance before counting a new lap (cm)
    options.acqHz=10000; % behavior acquisition frequency (Hz)
    options.textures=0; % 1= find RFID for each texture; 0 = no RFID for texture
    options.dispfig=0; % Display figure (lap, RFID)
    Behavior = behavior_lap_left_right(CSV,options);   
    stimEdges = [1.94 1.97 2.0 2.03 2.06 2.09 2.12 2.15 2.18];
    [~,stimID] = histc(CSV(:,3),stimEdges);
    Behavior.stimulus = stimID;    
    [~,name,~] = fileparts(input_folder);
    xmlFile = jdir(input_folder,sprintf('%s.xml',name));
    if(isempty(xmlFile))
        fprintf('\nNo matching .XML file in folder %s\n',input_folder);
        xmlFile = jdir(input_folder,'*.xml');
        if(isempty(xmlFile))
            return;
        else
            fprintf('\nUsing XML file %s\n',xmlFile(1).name);
        end
    end
    S = xml2structV2(fullfile(input_folder,xmlFile(1).name));
    if(iscell(S.PVScan.Sequence))
        Imaging_Time = cellfun(@(x) str2double(x.Attributes.relativeTime), S.PVScan.Sequence{1}.Frame);
    else
        Imaging_Time = cellfun(@(x) str2double(x.Attributes.relativeTime), S.PVScan.Sequence.Frame);
    end
    if(~exist(output_folder,'dir'))
        mkdir(output_folder);
    end
    save(fullfile(output_folder,'Behavior'),'Behavior','Imaging_Time');
%    save(fullfile(output_folder,'Behavior'),'Behavior');
    fprintf('\nbehavior extracted\n');    
end