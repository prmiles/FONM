function files = Find_Files(dirname)
% Identify File names
if iscell(dirname)
    dirname = dirname{1,1};
end
T = dir(dirname);
k = 0;
files = {''};
for i = 1:length(T);
    if length(T(i).name) < 1
    else
        k = k + 1;
        files{k,1} = T(i).name;
    end
end

if isempty(files)
    files = '';
end
