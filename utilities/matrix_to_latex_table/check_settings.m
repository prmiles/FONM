function settings = check_settings(settings, inputsettings)

% extract user defined settings
inputfields = fields(inputsettings);

% default settings
validfields = fields(settings);

% determine valid fields specified by user
checkfields = intersect(inputfields, validfields);
nvf = length(checkfields);

for ii = 1:nvf
    if isempty(inputsettings.(checkfields{ii}))
    else
        settings.(checkfields{ii}) = inputsettings.(checkfields{ii});
    end
end