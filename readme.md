# background
I plan to build something similar to the spm 3D data viewer and grant it tools to edit the data through clicking (just like editing T1.vmr in brain voyager). Of course, there are already successful viewers like xjview and neuroelf; however, it will be easier for me to write/modify a new one than to learn the prior settings.
# functions to utilize
ginput: get the coordinates of cursor
y_Call_spm_orthviews_EdgeMode: a hacked version of y_Call_spm_orthviews in DPABI to overlay edges of a brain onto another one. From this file, I might know how to use the viewer in spm. --> it is in y_spm_orthviews.m
y_spm_orthviews: it looks like a good viewer, but it has 3000+ lines... so I will skip reading it and start from "zero".
# file structure
sz_3d_image_viewer: create a window, with views along each of the three dimensions of a 3D image (e.g. data from T1.vmr), another window (control panel) will also be created to contain some controls for viewing
sz_3d_image_editor: utilize sz_3d_image_viewer to view data, additional controls for data editing will be added to the control panel.
function_lib\: some convenient functions
# git
This set of scripts should be uploaded to github for sharing and reviewing when I have time.
# matlab version
I often use 2014b, but its lose control of font size in the GUI is really annoying. So, for this tool, I will use matlab 2020b, although with my best effort to avoid some strange grammar of this higher version.