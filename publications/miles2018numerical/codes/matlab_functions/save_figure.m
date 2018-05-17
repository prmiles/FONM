function save_figure(filename, figID, extensions, disp_flag)
% function save_figure(filename, figID, extensions, disp_flag)
% figID - handle of figure being saved
% filename - name a file being saved
% types - extensions of file types being created (Cell array)

% Determine if display file names as saved
if nargin < 4 || isempty(disp_flag)
    dflag = 0;
else
    dflag = disp_flag;
end

% Determine files extensions to be saved
if nargin < 3 || isempty(extensions)
    extensions = {'png'; 'fig'; 'eps'; 'pdf'};
end

% The algorithm requires the "extensions" variable to be a cell array.  If
% user inputs a string, then it will simply put that string inside a cell
% array.
if ~iscell(extensions) 
    extensions = {extensions};
end

% Remove "." from extensions - in case user specified
for i = 1:size(extensions, 1)
    if any(extensions{i} == '.')
        extensions{i} = strrep(extensions{i}, '.', '');
    end
end

% Define figure handle
if nargin < 2 || isempty(figID)
    figID = gcf;
end

% Define default file name if none is given
if nargin < 1 || isempty(filename)
    base_name = 'Fig';
    [filename] = Default_Name(base_name);
end

% Lock axes for printing
% set(gca, 'XTickMode', 'auto');
% set(gca, 'YTickMode', 'auto');
% set(gca, 'ZTickMode', 'auto');
% set(gca, 'XLimMode', 'manual');
% set(gca, 'YLimMode', 'manual');
% set(gca, 'ZLimMode', 'manual');

% set(figID,'PaperPositionMode','auto')
% Lock figure resolution
% set(figID, 'PaperUnits', 'inches');
% set(figID, 'PaperPosition', [0 0 4 3]);

for i = 1:length(extensions)
    if dflag~=0; fprintf('\t%s.%s\n', filename, extensions{i}); end;
    if strcmp(extensions{i}, 'avi');
    elseif strcmp(extensions{i}, 'eps');
        print(figID, '-depsc', '-r0', filename);
    else
        saveas(figID, filename, extensions{i});
    end
end