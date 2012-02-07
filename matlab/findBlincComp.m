function blinkComp=findBlinkComp(comp)
load ~/ft_BIU/matlab/files/plotwts.mat


channelL = {'A21', 'A22', 'A23', 'A24', 'A39', 'A40', 'A41', 'A42', 'A43', 'A63', 'A64', 'A65', 'A66', 'A67', 'A68', 'A91', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A123', 'A124', 'A125', 'A126', 'A127', 'A128', 'A129', 'A153', 'A154', 'A155', 'A156', 'A157', 'A177', 'A178', 'A179', 'A196', 'A197', 'A212', 'A213', 'A229', 'A230', 'A231', 'A232'};
channelR = {'A32', 'A33', 'A34', 'A35', 'A55', 'A56', 'A57', 'A58', 'A59', 'A82', 'A83', 'A84', 'A85', 'A86', 'A87', 'A113', 'A114', 'A115', 'A116', 'A117', 'A118', 'A119', 'A145', 'A146', 'A147', 'A148', 'A149', 'A150', 'A151', 'A172', 'A173', 'A174', 'A175', 'A176', 'A193', 'A194', 'A195', 'A210', 'A211', 'A227', 'A228', 'A245', 'A246', 'A247', 'A248'}
channelP = {'A27', 'A28', 'A29', 'A30', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243'};
for cmp=1:20
    L=0;
    R=0;
    P=0;
    countL=0;
    countR=0;
    countP=0;

    for chanLi=1:length(channelL)
        channum=find(strcmp(channelL(chanLi),comp.topolabel));
        if ~isempty(channum)
            L=L+comp.topo(channum,cmp);
            countL=countL+1;
        end;
    end
    L=L/countL;
    for chanRi=1:length(channelR)
        channum=find(strcmp(channelR(chanRi),comp.topolabel));
        if ~isempty(channum)
            R=R+comp.topo(channum,cmp);
            countR=countR+1;
        end;
    end
    R=R/countR;
    LdvdR=L/R;
    LminR=abs(L-R);
    for chanPi=1:length(channelP)
        channum=find(strcmp(channelP(chanPi),comp.topolabel));
        if ~isempty(channum)
            P=P+abs(comp.topo(channum,cmp));
            countP=countP+1;
        end
    end

    cmp;
    P=P/countP;
    F=abs(L)+abs(R);

    LR(cmp,1)=abs(1+L/R);
    PF(cmp,1)=(P-F)/F;
end
LRz=(LR-mean(LR))/std(LR);
PFz=(PF-mean(PF))/std(PF);
[v,blinkComp]=min(LRz+PFz);
wts.avg=comp.topo(:,blinkComp);
wts.label=comp.topolabel;
ft_topoplotER([],wts);
end
