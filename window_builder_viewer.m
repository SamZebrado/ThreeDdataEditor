function hndl = window_builder_viewer()
%% create window if called for the first time, return existing window if has
% been called before.
qDebug = true;
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
p_hndl.figure = figure(...
    'CreateFcn',@FigureCreateFcn,...
    'DeleteFcn',@DeleteFcn,...
    'KeyPressFcn',@KeyPressFcn,...
    'KeyReleaseFcn',@KeyReleaseFcn);
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

p_hndl.data = zeros([1,1,1]);
p_hndl.coords = [1,1,1];
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
                coords = varargin{1};
            case 3
                coords = cell2mat(varargin(:)');
        end
        % avoid exceeding data limits
        coords = max([1,1,1],coords);
        coords = min(size(p_hndl.data,1,2,3),coords);
        
        p_hndl.coords = coords;
        redraw();
    end
    function redraw()
        data = p_hndl.data;
        coords = p_hndl.coords;
        x = coords(1);
        y = coords(2);
        z = coords(3);
        % <unsolved: imagesc will cancel the axis title and related properties>
        
        if qDebug
            fprintf('Redrawing at coords [%i, %i, %i]\n',x,y,z)
        end
        v_max = nanmax(data(:));
        v_min = nanmin(data(:));
        if v_max ==v_min
            v_max = v_max+1;
        end
        common_proplist = {'CLim',[v_min,v_max]};
        
        % sagital view: plot the y-z plane
        imag_data = permute(data(x,:,:),[2,3,1]);
        subplot(s_sag);
        TitleText = sprintf('sagittal\nx = %i',x);
        proplist = [common_proplist];
        set(gca,'Children',imagesc(imag_data,'HitTest','off'),proplist{:})% to hit the axes instead of the image when clicked
        title(TitleText);
        % <a flaw: other properties will not be resume>
        % coronal view: plot the x-z plane
        imag_data = permute(data(:,y,:),[1,3,2]);
        subplot(s_cor);
        TitleText = sprintf('coronal\ny = %i',y);
        proplist = [common_proplist];
        set(gca,'Children',imagesc(imag_data,'HitTest','off'),proplist{:});
        title(TitleText);
        % horizontal view: plot the x-y plane
        imag_data = data(:,:,z);
        subplot(s_hor);
        TitleText = sprintf('horizontal\nz = %i',z);
        proplist = [common_proplist];
        set(gca,'Children',imagesc(imag_data,'HitTest','off'),proplist{:});
        title(TitleText);
    end
%% nested functions: interactivity
% figure properties

    function DeleteFcn(src,eventdata)
        % evoked when the figure is closed
        clear_pers();
    end

    function FigureCreateFcn(src,eventdata)
        % initialize
        initialzeStates(src,{'shiftState','controlState','altState'});
    end
    function initialzeStates(src,statelist,varargin)
        if nargin>2
            val = varargin{1};
        else
            val = num2cell(false(size(statelist)));
        end
        UserData = get(src,'UserData');
        for i_state = 1:length(statelist)
            statename = statelist{i_state};
            if ~isfield(UserData,statename)
                UserData.(statename)= val{i_state}; set(src,'UserData',UserData)
            end
        end
    end
% keyboard shotcuts
    function KeyPressFcn(src,KeyData)
        if qDebug
            UserData = get(src,'UserData');
            fprintf( 'Key %s Pressed!\nShift State: %i\n',KeyData.Key,UserData.shiftState)
        end
        
        % function keys to check
        keyNames = {'shift','control','alt'};
        stateNames = strcat(keyNames,'State');
        stateVal = true;
        for i_statekey = 1:length(keyNames)
            callback_updateKeyState(src,KeyData,keyNames{i_statekey},stateNames{i_statekey},stateVal)
        end
        % moving keys
        movingKeys(src,KeyData);
    end
    function KeyReleaseFcn(src,KeyData)
        fprintf( 'Key %s Released!\n',KeyData.Key)
        % function keys to check
        keyNames = {'shift','control','alt'};
        stateNames = strcat(keyNames,'State');
        stateVal = false;
        for i_statekey = 1:length(keyNames)
            callback_updateKeyState(src,KeyData,keyNames{i_statekey},stateNames{i_statekey},stateVal)
        end
    end

    function callback_updateKeyState(src,KeyData,keyName,stateName,stateVal)
        UserData = get(src,'UserData');
        if strcmp(KeyData.Key,keyName)
            UserData.(stateName) = stateVal; set(src,'UserData',UserData)
        end
    end

    function movingKeys(src,KeyData)
        UserData = get(src,'UserData');
        Key = KeyData.Key;
        switch Key
            case {'uparrow','downarrow'}
                if UserData.shiftState
                    set_coords(p_hndl.coords+((Key(1)=='u')*2-1)*[0,1,0]);
                else
                    set_coords(p_hndl.coords+((Key(1)=='u')*2-1)*[0,0,1]);
                end
            case {'leftarrow','rightarrow'}
                set_coords(p_hndl.coords+((Key(1)=='r')*2-1)*[1,0,0]);
        end
        
    end
%% nested functions: handle controls
    function clear_pers()
        %
        %
        p_hndl = [];
    end

hndl = p_hndl;
end
