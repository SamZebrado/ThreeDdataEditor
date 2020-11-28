function hndl = window_builder_viewer()
%% create window if called for the first time, return existing window if has
% been called before.
persistent p_hndl% persistent handle
if ~isempty(p_hndl)
    hndl = p_hndl;
    return;
end
%% outer-accessible nested functions: they look similar to methods of classes but they are not the same
p_hndl.clear_pers = @clear_pers;                                            % clear persistent variables
p_hndl.change_coords = @change_coords;                                      % change coordinates of the cross hair
p_hndl.redraw = @redraw;                                                    % redraw all subplots
%% create figure structure
p_hndl.figure = figure;
%
s_sag = subplot(2,2,1);
title('sagittal');% title will be used later to pick subplot, through handles.Title.Text.string
%
s_cor = subplot(2,2,2,'Title',text('String','coronal'));% this kind of calling cannot be directly used when no subplots exists in the figure
%
s_hor = subplot(2,2,3,'Title',text('String','horizontal'));
%% nested functions: interactivity

%% nested functions: handle controls
    function clear_pers()
        p_hndl = [];
    end
end