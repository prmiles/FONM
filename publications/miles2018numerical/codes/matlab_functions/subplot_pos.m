function [ positions ] = subplot_pos(sb)
% subplot fixer - Patrick Martineau
% modified - Paul Miles
% unpack input structure
plotwidth = sb.plotwidth;
plotheight = sb.plotheight;
leftmargin = sb.margin(1); % [Left, Right, Bottom, Top]
rightmargin = sb.margin(2);
bottommargin = sb.margin(3);
topmargin = sb.margin(4);
nbcol = sb.nbcol;
nbrow = sb.nbrow;
spacecol = sb.spacecol;
spacerow = sb.spacerow;

% determine size requirements
subcolsize=(plotwidth-leftmargin-rightmargin-spacecol*(nbcol-1.0))/nbcol;
subrowsize=(plotheight-topmargin-bottommargin-spacerow*(nbrow-1.0))/nbrow;

count = nbcol*nbrow;
positions = cell(count,1);
counter = 0;
for j=nbrow:-1:1
    for i=1:nbcol
        counter = counter + 1;
        xfirst=leftmargin+(i-1.0)*(subcolsize+spacecol);
        yfirst=bottommargin+(j-1.0)*(subrowsize+spacerow);
        
        positions{counter,1}=[xfirst/plotwidth yfirst/plotheight subcolsize/plotwidth subrowsize/plotheight];
        
    end
end
end