subStart=1;
subEnd=1;
cd /home/yuval/Data/amb
for subi=subStart:subEnd
    display(['SUBJECT ',num2str(subi)]);
    cd (['/home/yuval/Data/amb/',num2str(subi)])
    for diri=[1]
        cd (['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)]);
        if ~exist('rw_c,rfhp1.0Hz,lp','file')
            display(['rewriting ',num2str(subi),'/',num2str(diri)]);
            if subi>19
                rewriteData2to1k(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)],'/home/yuval/Data/amb/c,rfhp0.1Hz','c,rfhp1.0Hz,lp');
            else
                rewriteData(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)],'/home/yuval/Data/amb/c,rfhp0.1Hz','c,rfhp1.0Hz,lp');
            end
        end
%         if ~exist('Dom.mrk','file') && ~exist('Sub.mrk','file')
%             display(['Creating MarkerFile.mrk ',num2str(subi),'/',num2str(diri)]);
%             amb(['/home/yuval/Data/amb/',num2str(subi),'/',num2str(diri)])
%         end
%         if ~exist([num2str(subi),'.rtw'],'file')
%             copyfile('/home/yuval/Data/amb/YHan.rtw',[num2str(diri),'.rtw'])
%         end
%         fitMRI2hs('rw_c,rfhp1.0Hz,lp')
%         hs2afni
%         [BEG END]=beg2end;
%         cleanHB('rw_c,rfhp1.0Hz,lp',(BEG/1017.25-1),(END/1017.25+1))
        
        copyfile ../Dom.param ./
        copyfile ../Sub.param ./
        direc=num2str(diri);
        if exist ([direc,'/Dom.mrk'],'file')
%            copyfile([direc,'/Dom.mrk'],[direc,'/MarkerFile.mrk'])
            eval(['!SAMcov -r ',num2str(diri),' -d rw_c,rfhp1.0Hz,lp -m Dom -v'])
%            eval(['!SAMwts -r ',num2str(diri),' -d rw_c,rfhp1.0Hz,lp -m Dom -c DomRea -v'])
        else
%            copyfile([direc,'/Sub.mrk'],[direc,'/MarkerFile.mrk'])
%            eval(['!SAMcov -r ',num2str(diri),' -d rw_c,rfhp1.0Hz,lp -m Sub -v'])
%            eval(['!SAMwts -r ',num2str(diri),' -d rw_c,rfhp1.0Hz,lp -m Sub -c SubRea -v']) 
        end

        
    end
end



