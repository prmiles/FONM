function [yn] = make_directory(OD, type)
% Type:
%   0 if A does not exist
%   1 if A is a variable in the workspace
%   2 if A is an M-file on MATLAB's search path.  It also returns 2 when
%        A is the full pathname to a file or when A is the name of an
%        ordinary file on MATLAB's search path
%   3 if A is a MEX-file on MATLAB's search path
%   4 if A is a Simulink model or library file on MATLAB's search path
%   5 if A is a built-in MATLAB function
%   6 if A is a P-file on MATLAB's search path
%   7 if A is a directory
%   8 if A is a class (exist returns 0 for Java classes if you

if nargin < 2 || isempty(type)
    type = 'dir'; % Directory
end

yn = exist(OD, type); % 0
% Makes directory if none existed
if yn == 0
    mkdir(OD);
end