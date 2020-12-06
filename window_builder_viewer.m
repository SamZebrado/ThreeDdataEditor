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
p_hndl.set_data = @set_data;
p_hndl.set_coords = @set_coords;                                      % change coordinates of the cross hair
p_hndl.redraw = @redraw;                                                    % redraw all subplots

%% create figure structure
p_hndl.figure = figure('DeleteFcn',p_hndl.clear_pers);
%
s_sag = subplot(2,2,1,...
    'Xdir','reverse'... to plot front to the left
    );
title('sagittal');% title will be used later to pick subplot, through handles.Title.Text.string
%
s_cor = subplot(2,2,2,'Title',text('String','coronal'),...% this kind of calling cannot be directly used when no subplots exists in the figure
    'Xdir','reverse'... to plot right to the left (viewing the data from front toward back)
    );
%
s_hor = subplot(2,2,3,'Title',text('String','horizontal'));

%% collect the handles (after all properties have been defined)
p_hndl.subplots.s_sag = s_sag;
p_hndl.subplots.s_cor = s_cor;
p_hndl.subplots.s_hor = s_hor;

p_hndl.coords = [];
%% viewing functions
    function set_data(data)
        % direction of data:
        % x: left -> right
        % y: back -> front
        % z: bottom -> top
        p_hndl.data = data;
        % plot the current slice in each subplot
        redraw();
    end
    function set_coords(varargin)
        switch nargin
            case 1
                p_hndl.coords = varargin{1};
            case 3
                p_hndl.coords = cell2mat(varargin(:)');
        end
    end
    function redraw()
        data = p_hndl.data;
        coords = p_hndl.coords;
        x = coords(1);
        y = coords(2);
        z = coords(3);
        % <unsolved: imagesc will cancel the axis title and related properties>
        
        % sagital view: plot the y-z plane
        imag_data = permute(data(x,:,:),[2,3,1]);
        subplot(s_sag);
        imagesc(imag_data);
        % coronal view: plot the x-z plane
        imag_data = permute(data(:,y,:),[1,3,2]);
        subplot(s_cor);
        imagesc(imag_data);
        % horizontal view: plot the x-y plane
        imag_data = data(:,:,z);
        subplot(s_hor);
        imagesc(imag_data);
    end
%% nested functions: interactivity

%% nested functions: handle controls
    function clear_pers()
        %
        %
        p_hndl = [];
    end

hndl = p_hndl;
end
