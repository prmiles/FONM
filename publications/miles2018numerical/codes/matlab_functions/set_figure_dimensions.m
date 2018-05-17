function set_figure_dimensions(width, height)
% adjust figure dimensions

set(gcf,'units','inches');
pos = get(gca, 'pos');
set(gcf, 'Position', [pos(1) pos(2) width height]);