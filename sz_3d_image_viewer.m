function window_handles = sz_3d_image_viewer()
% create a window, with views along each of the three dimensions of a 3D image (e.g. data from T1.vmr), another window (control panel) will also be created to contain some controls for viewing
hndl_viewer = window_builder_viewer;
hndl_control_panel = window_builder_control_panel;
window_handles = struct('Viewer',hndl_viewer,'ControlPanel',hndl_control_panel);


end