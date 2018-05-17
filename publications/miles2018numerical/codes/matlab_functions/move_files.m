function move_files(filename, destination, extensions)
% move_files(filename, destination, extensions)
% Moves files with specific filename to a output directory defined by
% "destination" and be target specific file types by designating the file
% extensions.

if nargin < 3 || isempty(extensions)
    extensions = {'.png'; '.fig'; '.eps'; '.mat'; '.pdf'; '.avi'; '.txt'};
end

% The algorithm requires the "extensions" variable to be a cell array.  If
% user inputs a string, then it will simply put that string inside a cell
% array.
if ~iscell(extensions) 
    extensions = {extensions};
end

for i = 1:size(extensions, 1)
    if ~any(extensions{i} == '.')
        extensions{i} = strcat('.',extensions{i});
    end
end

for i = 1:size(extensions,1)
    flag = exist(strcat(filename, extensions{i}));
    if flag ~= 0
        movefile(strcat(filename, extensions{i}), destination);
    end
end
