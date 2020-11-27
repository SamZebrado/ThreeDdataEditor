function hndl = window_builder_viewer()
% create window if called for the first time, return existing window if has
% been called before.
persistent hndl
if isempty(hndl)
    return;
else
hndl = figure;
end

end