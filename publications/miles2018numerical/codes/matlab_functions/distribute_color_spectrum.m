function [psty] = distribute_color_spectrum(nds, cmap)
% evenly distribution color palette across nds data sets

if nargin < 2 || isempty(cmap)
    cmap = jet; % default color map
end

cmp = colormap(cmap);
[mc,~] = size(cmp);

nc = linspace(1,mc,nds)';

psty = zeros(nds,3);
for ii = 1:nds
    psty(ii,:) = interp1((1:1:mc)', cmp, nc(ii));
end

% if nds > mc
%    % map nds indices to cmp domain
%    nc = linspace(1,mc,nds)';
%    % create interpolatory colors
%    cmp = interp1((1:1:mc)',cmp,nc);
%    % reevaluate size of array
%    [mc,~] = size(cmp);
% end
% 
% skip = floor(mc/nds);
% chsclr = 1:skip:nds*skip;
% psty = cmp(chsclr,:);

