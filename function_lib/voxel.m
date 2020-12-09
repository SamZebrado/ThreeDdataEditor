function voxel(start_,size_,c,alpha)

%VOXEL function to draw a 3-D voxel in a 3-D plot
%
%Usage
%   voxel(start,size,color,alpha);
%
%   will draw a voxel at 'start' of size 'size' of color 'color' and
%   transparency alpha (1 for opaque, 0 for transparent)
%   Default size is 1
%   Default color is blue
%   Default alpha value is 1
%
%   start is a three element vector [x,y,z]
%   size the a three element vector [dx,dy,dz]
%   color is a character string to specify color 
%       (type 'help plot' to see list of valid colors)
%   
%
%   voxel([2 3 4],[1 2 3],'r',0.7);
%   axis([0 10 0 10 0 10]);
%

%   Suresh Joel Apr 15,2003
%           Updated Feb 25, 2004

switch(nargin)
case 0
    disp('Too few arguements for voxel');
    return;
case 1
    l=1;    %default length of side of voxel is 1
    c='b';  %default color of voxel is blue
case 2
    c='b';
case 3
    alpha=1;
case 4
    %do nothing
otherwise
    disp('Too many arguements for voxel');
end

x=[start_(1)+[0 0 0 0 size_(1) size_(1) size_(1) size_(1)]; ...
        start_(2)+[0 0 size_(2) size_(2) 0 0 size_(2) size_(2)]; ...
        start_(3)+[0 size_(3) 0 size_(3) 0 size_(3) 0 size_(3)]]';
for n=1:3,
    if n==3,
        x=sortrows(x,[n,1]);
    else
        x=sortrows(x,[n n+1]);
    end;
    temp=x(3,:);
    x(3,:)=x(4,:);
    x(4,:)=temp;
    h=patch(x(1:4,1),x(1:4,2),x(1:4,3),c);
    set(h,'FaceAlpha',alpha);
    temp=x(7,:);
    x(7,:)=x(8,:);
    x(8,:)=temp;
    h=patch(x(5:8,1),x(5:8,2),x(5:8,3),c);
    set(h,'FaceAlpha',alpha);
end
% % % Original file downloaded from
% % % https://www.mathworks.com/matlabcentral/fileexchange/3280-voxel 
% % % 
% % % Copyright (c) 2016, Suresh Joel
% % % All rights reserved.
% % % 
% % % Redistribution and use in source and binary forms, with or without
% % % modification, are permitted provided that the following conditions are
% % % met:
% % % 
% % %     * Redistributions of source code must retain the above copyright
% % %       notice, this list of conditions and the following disclaimer.
% % %     * Redistributions in binary form must reproduce the above copyright
% % %       notice, this list of conditions and the following disclaimer in
% % %       the documentation and/or other materials provided with the distribution
% % % 
% % % THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% % % AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% % % IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% % % ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% % % LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% % % CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% % % SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% % % INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% % % CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% % % ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% % % POSSIBILITY OF SUCH DAMAGE.
