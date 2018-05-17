function settings = mtx_to_latex_table(mtx, inputsettings)
% function mtx_to_latex_table(mtx, flag)
%
% Description:  Function receives a matrix from the user and generates a
% latex table based on that information.  The user can add several
% additional arguments to specify name of table file, number type, and
% flags as specified below.
%
% Settings:
% - method: Define table generation method.  User can control more features
% by using the 'columnwise' method; however, it may be easier to employ the
% 'threshold' method.  The 'columnwise' method involves defining a number
% type for each column in the matrix (default is described below).
% Alternatively, if the user specifies 'threshold', the table will be
% generated based on an upper lower bound convention for converting between
% standard decimal and scientific notation.
%   * 'columnwise'
%   - number_type: Specify array of number types.  If your table is comprised
%   of integers and floating point, you can specify a particular format for
%   each column. Default: {'%4.2f',...,'%4.2f'} % repeated to match number of
%   columns.
%   * 'threshold'
%   - thresh_min: lower limit for conversion to scientific. Default: '1e-3'
%   - thresh_max: upper limit for conversion to scientific. Default: '1000'
%   - thresh_f_number_type: Floating point number type. Default: '%4.2f'
%   - thresh_e_number_type: Scientific point number type. Default: '%4.2e'
%
% - table_name: User can specify a string that will be used in defining
% several features. (1) Any outputted file will match this name. (2) The
% automatic label generated for the LaTeX table will be
% "\label{tab:<table_name>}". Default: 'YYYYmmdd_hhMMss_latex_table'.
%
% - outputformat: Display to command window ('cmd_window') or write to a
% file ('file').  default: {'cmd_window', 'file'}.
%
% - column_format: Specify whether you want vertical lines between each
% column. Default: {|c|...|c|}. % repeated to match number of columns.

% - hline: Specify whether to put a horizontal line between each row.
% Default: 'off'.
%
% Written by M. Jemison     July 8, 2016
% Modified by prmiles       July 11, 2016
% Modified by prmiles       August 17, 2016
% Modified by prmiles       March 21, 2018

% unpack input arguments
if nargin < 2 || isempty(inputsettings)
    inputsettings.defined = 0;
end

% Determine size of input matrix
[rows,columns] = size(mtx);

% default settings
% table name
settings.table_name = strcat(datestr(now,'YYYYmmdd_hhMMss'),'_latex_table');
% method
settings.method = 'columnwise';
% output format: file or command window
settings.outputformat = {'cmd_window', 'file'};
% table column format
str = '{';
for ii=1:columns
    str = strcat(str,'|c');
end
str = strcat(str,'|}');
settings.column_format = str;
% number types
numtype = cell(columns,1);
for jj = 1:columns
    numtype{jj} = '%4.2f';
end
settings.number_type = numtype;
% head line
settings.hline = 0; % default is off
% settings for threshold
settings.thresh_min = 1e-3; % number less than 0.001 converted to scientific
settings.thresh_max = 1e3; % numbers greater than 1000 converted to scientific
settings.thresh_f_number_type = '%4.2f';
settings.thresh_e_number_type = '%4.2e';
% rows & columns
settings.rows = rows;
settings.columns = columns;

% check directory settings
settings = check_settings(settings, inputsettings);

% Generate table and print
if any(strcmp(settings.outputformat, 'file'))
    fid = fopen(strcat(settings.table_name,'.txt'),'w');
    print_latex_table(fid, mtx, settings);
    fclose(fid);
end

if any(strcmp(settings.outputformat, 'cmd_window')) % display to command window
    print_latex_table(1, mtx, settings);
end

end