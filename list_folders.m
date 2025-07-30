function folder_list = list_folders(root_folder)
    fprintf('\nlisting folders\n\n');
    struct_base_folders = dir(root_folder);
    list_base_folders = string();
    if ~contains(root_folder,'/')
        str_slash = '\';
    else
        str_slash = '/';
    end
    for i = 1:size(struct_base_folders,1)
        %str_temp = string(strcat(struct_base_folders(i).folder,'\',struct_base_folders(i).name));
        str_temp = string(strcat(struct_base_folders(i).folder,str_slash,struct_base_folders(i).name));
        if isfolder(str_temp) == 1
            if isnan(str2double(struct_base_folders(i).name)) == 0
                list_base_folders(i) = str_temp;
            end
        end
    end
    list_base_folders = transpose(list_base_folders);
    array_data_folders = string();
    list_base_folders = rmmissing(list_base_folders);
    for i = 1:size(list_base_folders,1)
        struct_data_folders = dir(list_base_folders(i));
        for j = 1:size(struct_data_folders,1)
            %str_temp = string(strcat(struct_data_folders(j).folder,'\',struct_data_folders(j).name));
            str_temp = string(strcat(struct_data_folders(j).folder,str_slash,struct_data_folders(j).name));
            if isfolder(str_temp) == 1
                if contains(str_temp,'_t-') == 1
                    array_data_folders(i,j) = str_temp;
                end
            end
        end
    end
    list_data_folders = string();
    for i = 1:size(array_data_folders,2)
        v_temp = array_data_folders(:,i);
        list_data_folders = cat(1,list_data_folders,v_temp);
    end
    list_data_folders = rmmissing(list_data_folders);
    list_data_folders = sort(list_data_folders);
    for i = 1:size(list_data_folders,1)
        disp(list_data_folders(i));
    end
    folder_list = list_data_folders;
    folder_list(cellfun('isempty',folder_list)) = [];
    fprintf('\nfolders listed\n\n');
end