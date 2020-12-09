# Background
I plan to build something similar to the spm 3D data viewer and grant it tools to edit the data through clicking (just like editing T1.vmr in brain voyager). Of course, there are already successful viewers like xjview and neuroelf; however, it will be easier for me to write/modify a new one than to learn the prior settings.  
Also I would like to use hotkeys while viewing and editing data.  
The ultimate version of this tool is expected to be like a brain-editing minecraft.

# File Structure
**sz_3d_image_viewer**: create a window, with views along each of the three dimensions of a 3D image (e.g. data from T1.vmr), another window (control panel) will also be created to contain some controls for viewing.  
**sz_3d_image_editor**: utilize sz_3d_image_viewer to view data, additional controls for data editing will be added to the control panel.  
**function_lib\\**: some convenient functions; but I do not know how to put the function inside a subfolder and use them without repeatedly adding path, and without addpath of that subfolder. So no files have been put inside it yet.
**voxel.m**: a really helpful function to plot voxels in 3D. It even supports alpha value! Downloaded from https://www.mathworks.com/matlabcentral/fileexchange/3280-voxel. Thanks to Suresh Joe the author!
# Coming Updates
It will be a long time before I hit the ultimate version of it, with only scattered weekends spent on it.    
So, I will list some unimplemented updates here and if anyone is interested in building this tool with me, please feel free to join/fork it (I am not an expertise in Github, let me know if you need me to do something to let you join).  
## sz_3d_image_viewer.m
1. add methods to control the image and crosshair properties, e.g. line width, color range, ...
2. fine-tune the figure and subplots' size;
3. add selecting and highlight function to select a cube of data;
4. put selected region in a new subplot (or a large background plot), visualize it in a clever way (using openGL to plot the voxels);*with the help of the voxel.m, I believe we are quite closer to the ultimate goal!*
5. add controls for visible data range;

## sz_3d_image_editor.m
1. take care about the viewer and its data sharing with the control panel.


# Matlab Version
I often use 2014b, but its losing control of font size in the GUI is really annoying. So, for this tool, I will use matlab 2020b, although with my best effort to avoid some strange grammar of this higher version.
**However,** it seems that neuroelf could not work properly under matlab 2020b, so combining this tool with the neuroelf may fail.
# Updates List
## sz_3d_image_viewer.m
1. add a cross hair to each subplot, marking the current position;
2. add mouse-related interactivity;
3. restructure the properties of the handle;

# Open Source Declaration

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
	

# List of some other interesting files to read
**y_Call_spm_orthviews_EdgeMode.m (not uploaded yet)**: a modified version of y_Call_spm_orthviews in DPABI to overlay edges of a brain onto another one. From this file, I might know how to use the viewer in spm. --> it is in y_spm_orthviews.m  
**y_spm_orthviews**: a file from spm. It looks like a good viewer, but it has 3000+ lines... so I will skip reading it and start from "zero".  
**neuroelf**: a very convenient toolbox for brain imaging data visualization.   https://github.com/neuroelf/neuroelf-matlab