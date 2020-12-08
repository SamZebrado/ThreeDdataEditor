function viewer_hndl = window_builder_viewer()
%% create window if called for the first time, return existing window if has
% been called before.
qDebug = true;

%% outer-accessible nested functions: they look similar to methods of classes but they are not the same
viewer_hndl.Methods.clear_pers = @clear_pers;                                            % clear persistent variables
viewer_hndl.Methods.set_data = @set_data;
viewer_hndl.Methods.set_coords = @set_coords;                                      % change coordinates of the cross hair
viewer_hndl.Methods.redraw = @redraw;                                                    % redraw all subplots

%% create figure structure
viewer_hndl.Objects.Figure = figure(...
    'CreateFcn',@FigureCreateFcn,...
    'DeleteFcn',@DeleteFcn,...
    'KeyPressFcn',@KeyPressFcn,...
    'KeyReleaseFcn',@KeyReleaseFcn);
%
s_sag = subplot(2,2,1,...
    'Xdir','reverse',... to plot front to the left
    'ButtonDownFcn',@SAG_ButtonDown...
    );
title('sagittal');% title will be used later to pick subplot, through handles.Title.Text.string
%
s_cor = subplot(2,2,2,'Title',text('String','coronal'),...% this kind of calling cannot be directly used when no subplots exists in the figure
    'ButtonDownFcn',@COR_ButtonDown...
    );
%
s_hor = subplot(2,2,3,...
    'Title',text('String','horizontal'),...
    'ButtonDownFcn',@HOR_ButtonDown...
    );

%% collect the handles (after all properties have been defined)
viewer_hndl.Objects.Subplots.s_sag = s_sag;
viewer_hndl.Objects.Subplots.s_cor = s_cor;
viewer_hndl.Objects.Subplots.s_hor = s_hor;

viewer_hndl.ImgData.D3Data = zeros([1,1,1]);
viewer_hndl.ViewPoint.Coords = [1,1,1];
%% viewing functions
    function set_data(data)
        % direction of data:
        % x: left -> right
        % y: back -> front
        % z: bottom -> top
        viewer_hndl.ImgData.D3Data = data;
        % plot the current slice in each subplot
        redraw();
    end
    function set_coords(varargin)
        %         set_coords([x,y,z])
        %         set_coords(x,y,z)
        %         set_coords({x,y,z})
        % in the latter two casesx, y, z could be empty to maintain the
        % original value
        
        switch nargin
            case 1
                coords = varargin{1};
            otherwise
                coords = varargin;
                coords(end+1:3) = {[]};
        end
        % supporting set some coordinates empty to keep the original value
        origin_coords = viewer_hndl.ViewPoint.Coords;
        
        if iscell(coords)
            ind_empty = cellfun(@isempty,coords);
            coords(ind_empty) = {nan};% set empty value as nan
            coords = cell2mat(coords);
            coords(ind_empty) = origin_coords(ind_empty);
        end
        
        % avoid exceeding data limits
        coords = max([1,1,1],coords);
        coords = min(size(viewer_hndl.ImgData.D3Data,1,2,3),coords);
        
        viewer_hndl.ViewPoint.Coords = coords;
        redraw();
    end
    function redraw()
        data = viewer_hndl.ImgData.D3Data;
        coords = viewer_hndl.ViewPoint.Coords;
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
        proplist = {'CLim',[v_min,v_max]};
        crossHairProp = {'Color','k','LineWidth',2};
        % sagital view: plot the y-z plane
        imag_data = permute(data(x,:,:),[2,3,1]);
        subplot(s_sag,proplist{:});
        TitleText = sprintf('sagittal\nx = %i',x);
        replaceImg(gca,imag_data,{});
        drawCrossHair(gca,[y,z],crossHairProp);
        title(TitleText);
        % <a flaw: other properties will not be resume>
        % coronal view: plot the x-z plane
        imag_data = permute(data(:,y,:),[1,3,2]);
        subplot(s_cor);
        TitleText = sprintf('coronal\ny = %i',y);
        replaceImg(gca,imag_data,{});
        drawCrossHair(gca,[x,z],crossHairProp);
        title(TitleText);
        
        % horizontal view: plot the x-y plane
        imag_data = data(:,:,z);
        subplot(s_hor);
        TitleText = sprintf('horizontal\nz = %i',z);
        replaceImg(gca,imag_data,{});
        drawCrossHair(gca,[x,y],crossHairProp);
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
                    set_coords(viewer_hndl.ViewPoint.Coords+((Key(1)=='u')*2-1)*[0,1,0]);
                else
                    set_coords(viewer_hndl.ViewPoint.Coords+((Key(1)=='u')*2-1)*[0,0,1]);
                end
            case {'leftarrow','rightarrow'}
                set_coords(viewer_hndl.ViewPoint.Coords+((Key(1)=='r')*2-1)*[1,0,0]);
        end
        
    end
% mouse interactivity
    function SAG_ButtonDown(src,eventdata)
        if qDebug
            fprintf('SAG clicked!\n')
        end
        yz  = round(eventdata.IntersectionPoint([1,2]));
        set_coords([],yz(1),yz(2));
    end
    function COR_ButtonDown(src,eventdata)
        if qDebug
            fprintf('COR clicked!\n')
        end
        xz  = round(eventdata.IntersectionPoint([1,2]));
        set_coords(xz(1),[],xz(2));
    end
    function HOR_ButtonDown(src,eventdata)
        if qDebug
            fprintf('HOR clicked!\n')
        end
        xy  = round(eventdata.IntersectionPoint([1,2]));
        set_coords(xy(1),xy(2),[]);
    end
%% nested functions: handle controls
    function clear_pers()
        %
        %
        viewer_hndl = [];
    end

hndl = viewer_hndl;
end
function replaceImg(c_a,imag_data,proplist)
hold on;% to keep all other properties of the axis
imagesc(imag_data,'HitTest','off','Tag','Image',proplist{:});% to hit the axes instead of the image when clicked
ind_img = find(strcmp(arrayfun(@(x)x.Tag,c_a.Children,'UniformOutput',false),'Image'));
if length(ind_img)>1
    % remove the most bottom image
    delete(c_a.Children(ind_img(end)));
end
ax = size(imag_data);
axis([0,ax(1),0,ax(2)]+0.5);
hold off;
end
function drawCrossHair(c_a,ch,proplist)
hold on;
ax = axis;
plot([ax([1,2]),NaN,ch([1,1])],[ch([2,2]),NaN,ax([3,4])],'Tag','CrossHair',proplist{:});
ind_ch = find(strcmp(arrayfun(@(x)x.Tag,c_a.Children,'UniformOutput',false),'CrossHair'));
if length(ind_ch)>1
    delete(c_a.Children(ind_ch(end)));    
end
hold off;
end