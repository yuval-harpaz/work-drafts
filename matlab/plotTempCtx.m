load /home/yuval/Data/temp_ctx
load /home/yuval/Data/template_grid
grid=template_grid;clear template_grid;

ft_plot_vol(vol);
hold on;
ind=285*8+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'gx');
ind=285*7+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'rx');
ind=285*6+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'kx');
ind=285*5+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'bx');
%ind=285*4+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'mx');
%ind=285*13+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'gx');
%ind=285*12+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'rx');
ind=285*11+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'kx');
ind=285*10+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'bx');
ind=285*9+1;plot3(grid.pos(ind:(ind+284),1),grid.pos(ind:(ind+284),2),grid.pos(ind:(ind+284),3),'mx');

%% comments
% every 285 points on grid.pos make one horizontal plane
% bottom boundary 5th layer,index 1426 (285*5+1) to 1710, z value -10  
% top boundary 11th layer, index 3136 to 3420, z value 50
% left right boundaries x=-40:40
% anterior posterior boundaries y=-75:55

% left - right, mask only 4th and 5th sagittal planes from the left x=-30:-40 
% and from the right x=30:40

% 
