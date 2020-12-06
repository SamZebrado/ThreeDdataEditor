function h = fc_inherit(h,varargin)
%% function h = fc_inherit(h,prop_list) set the properties of h as values
% of the same properties of the parent of h.
% prop_list specifies the properties that needs to be copied to h.
% Example:
% figure;
% subplot(2,2,1,'ButtonDownFcn','fprintf(''printing a text\n'')')
% h = imagesc(magic(5));% if not inherited, since the image is generated on top of above the subplot, the ButtonDownFcn will not be evoked when you click the image.
% fc_inherit(h,'ButtonDownFcn');
if nargin<3
    prop_list = varargin;
end
if ischar(prop_list)
    prop_list = {prop_list};
end
for i_prop = 1:length(prop_list)
    prop_name = prop_list{i_prop};
    set(h,prop_name,get(h.Parent,prop_name));
end
end