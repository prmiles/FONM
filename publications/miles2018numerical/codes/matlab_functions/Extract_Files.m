function [flag_files, ff_ind] = Extract_Files(flag, files)
% Identify file names matching flag
if nargin < 2 || isempty(files)
   files = Find_Files(cd); 
end
 
k = 0; ff_ind = zeros(length(files),1);
for i = 1:length(files)
    T = files{i};
    ind = strfind(T, flag);
    if isempty(ind)
    else
        k = k + 1; ff_ind(i) = i;
        flag_files{k,1} = files{i};
    end
end

if k == 0
    flag_files = {};
    ff_ind = [];
    fprintf('No files matched search criteria\n')
end
    
