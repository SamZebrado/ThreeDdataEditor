function hndl = window_builder_prototype()
% create window if called for the first time, return existing window if has
% been called before.
persistent figure_hndl
if isempty(figure_hndl) || ~isgraphics(figure_hndl, 'figure')
    figure_hndl = figure;
end
hndl = figure_hndl;
end
