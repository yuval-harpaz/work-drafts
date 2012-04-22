function showHeadInGrad(fileName)
if ~exist('fileName','var')
    fileName=findMEGfileName(1)
end
hdr=ft_read_header(fileName);
megchans=find(ismember(hdr.grad.chantype,'meg'));
chanpos=1000*hdr.grad.chanpos;
megx=chanpos(megchans,1);
megy=chanpos(megchans,2);
megz=chanpos(megchans,3);
figure;
plot3(megx,megy,megz,'o');
hold on
hs=ft_read_headshape('hs_file');
hsx=hs.pnt(:,1)*1000;
hsy=hs.pnt(:,2)*1000;
hsz=hs.pnt(:,3)*1000;
plot3(hsx,hsy,hsz,'rx');




