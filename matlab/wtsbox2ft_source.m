function sdata=wtsbox2ft_source(SAMHeader,data)

boxSize=100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd];

sizes=diff(boxSize);
sizes=sizes(1:2:5);
sizes=sizes/(100.*SAMHeader.StepSize)+1;
sdata=struct;
sdata.dim=sizes;
if iscell(data.time)
    sdata.time=data.time{1,1};
else
    sdata.time=data.time;
end
sdata.pos=[];
sdata.inside=[];
sdata.outside=[];
sdata.method='average';
sdata.avg.filter=[];
sdata.avg.pow=[];
end