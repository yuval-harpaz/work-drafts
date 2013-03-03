cd /home/yuval/Data/amb
strS='Sur=ft_timelockgrandaverage(cfg,';
strD='Dur=ft_timelockgrandaverage(cfg,';
for subi=1:25
    sub=num2str(subi);
%     load ([sub,'/URc']);
%     Davg=ft_timelockanalysis([],DomURc);
%     Savg=ft_timelockanalysis([],SubURc);
%     if length(Davg.time)==2035
%         Davg.time=Davg.time(1,1:2:end);
%         Davg.avg=Davg.avg(:,1:2:end);
%         Savg.time=Savg.time(1,1:2:end);
%         Savg.avg=Savg.avg(:,1:2:end);
%     end
%     eval(['D',sub,'=Davg;'])
%     eval(['S',sub,'=Savg;'])
    strD=[strD,' D',sub,','];
    strS=[strS,' S',sub,','];
end
cfg=[];
cfg.keepindividual='yes';
strS=[strS(1:end-1),');'];
strD=[strD(1:end-1),');'];

eval(strS)
eval(strD)
save GAur Sur Dur


    
