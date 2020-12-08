close all;clear all;
%% demo of the viewer
hndl = window_builder_viewer();
hndl.Methods.set_coords([1,1,1]);
hndl.Methods.set_data(rand([100,100,100]));
% try pressing your arrow keys with and without shift being pressed