function print_latex_table(fid, mtx, settings)

fprintf(fid,'\\begin{table}[!h]\n');
fprintf(fid,'\\centering\n');

% Write formatting
str2 = strcat('\\begin{tabular}',settings.column_format,'\n');
fprintf(fid,str2);
fprintf(fid,'\\hline \n');

% Write a row for the key
str = '\t';
for ii=1:settings.columns-1
    str = strcat(str,'& \t');
end

fprintf(fid, str);
fprintf(fid,'\\');
fprintf(fid,'\\ ');
fprintf(fid,'\\hline \n');

for ii=1:settings.rows
    str = '';
    for jj=1:settings.columns
        % Write data
        if strcmp(settings.method, 'columnwise')
            str2 = sprintf(settings.number_type{jj}, mtx(ii,jj));
        elseif strcmp(settings.method, 'threshold')
            % check element wrt to threshhold values
            if settings.thresh_min <= mtx(ii,jj) && mtx(ii,jj) <= settings.thresh_max
                str2 = sprintf(settings.thresh_f_number_type, mtx(ii,jj));
            else
                str2 = sprintf(settings.thresh_e_number_type, mtx(ii,jj));
            end
        end
        
        if(jj < settings.columns)
            str2 = strcat(str2,'\t & ');
        end
        
        str = strcat(str,str2);
    end
    
    %Write line to file
    fprintf(fid,str);
    
    % Write end of line
    fprintf(fid,' \t \\');
    fprintf(fid,'\\ ');
    if settings.hline == 1
        fprintf(fid,'\\hline \n');
    else
        fprintf(fid,'\n');
    end
end
% add horizontal line to bottom of table if not already there
if settings.hline ~= 1
    fprintf(fid,'\\hline \n');
end

% Write tail info
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\caption{Write caption here}\n');
fprintf(fid,strcat('\\label{tab:',settings.table_name,'}\n'));
fprintf(fid,'\\end{table}\n');