function [pdata, h] = plot_stress_objects(pdata,yfield,subplot_settings)

% check input
if nargin<2 || isempty(yfield)
    yfield = 'sigma';
end

% determine number of objects
nds = length(pdata); % number of objects
% initialize legend
legstr = cell(nds,1);

[ positions ] = subplot_pos(subplot_settings);
nr = subplot_settings.nbrow;
nc = subplot_settings.nbcol;

% determine number of subfields
dys = fields(pdata(1).(yfield));
nys = length(dys);

h = figure;
for jj = 1:nys
    subplot(nr,nc,jj)
    for ii = 1:nds
        x = pdata(ii).x;
        % assign legend string
        legstr{ii} = pdata(ii).legstr;
        
        % check plot specifiers
        if ~isfield(pdata(ii),'color') || isempty(pdata(ii).color)
            pdata(ii).color = rand(3,1);
        end
        if ~isfield(pdata(ii),'linewidth') || isempty(pdata(ii).linewidth)
            pdata(ii).linewidth = 2;
        end
        
        hold on
        plot(x.data, pdata(ii).(yfield).(dys{jj}).data,...
            'Color',pdata(ii).color,...
            'LineWidth', pdata(ii).linewidth);
        hold off
        ylabel(pdata(ii).(yfield).(dys{jj}).str);
        xlabel(x.str);
        set(gca,'Position',positions{jj});
        
        set_figure_dimensions(subplot_settings.plotwidth,...
            subplot_settings.plotheight);
    end
end

% apply legends
legend(legstr,'Location',positions{end});
%
% figure(200);
% legend(legstr,'Location','Best');