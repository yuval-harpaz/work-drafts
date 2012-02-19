subStart=20;
subEnd=25;
cd /home/yuval/Data/amb
for subi=subStart:subEnd
    display(['SUBJECT ',num2str(subi)]);
    cd (['/home/yuval/Data/amb/',num2str(subi)])
    for diri=[1 3]
        cd (['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)]);
        if ~exist('rw_c,rfhp1.0Hz,lp','file')
            display(['rewriting ',num2str(subi),'/',num2str(diri)]);
            if subi>19
                rewriteData2to1k(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)],'/home/yuval/Data/amb/c,rfhp0.1Hz','c,rfhp1.0Hz,lp');
            else
                rewriteData(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)],'/home/yuval/Data/amb/c,rfhp0.1Hz','c,rfhp1.0Hz,lp');
            end
        end
        if ~exist('Dom.mrk','file') && ~exist('Sub.mrk','file')
            display(['Creating MarkerFile.mrk ',num2str(subi),'/',num2str(diri)]);
            amb(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)])
        end
        if ~exist([num2str(subi),'.rtw'],'file')
            copyfile('/home/yuval/Data/amb/YHan.rtw',[num2str(diri),'.rtw'])
        end
    end
end



