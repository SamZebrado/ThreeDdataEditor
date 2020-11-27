function hndl = window_builder_control_panel()
% create window if called for the first time, return existing window if has
% been called before.
persistent figure_hndl
if ~isempty(figure_hndl)
    figure_hndl = figure;
end
hndl = figure_hndl;
end