function [critT,critClustSize]=alicePermute4Anova2contr(prefix1,prefix2,prefix3,tThresh,endFstr,permContr)
% prefix- put 3 names of files per subject as prefixes
% tThresh- T thresholds for clustering per permutation ([3 3.5 4])
% endFstr add contrast, bucket etc for real F test. example:
% '-ftr F -contr  1 -1  1 Alice_Tamil -mean 1 alice1 -mean 2 tamil -mean 3 alice2 -bucket TTnew'

cd /home/yuval/Copy/MEGdata/alice/func
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
if ~exist('tThresh','var')
    tThresh=[];
end
if isempty(tThresh)
    tThresh=3;%2.044;
end
if ~exist('endFstr')
    endFstr='';
end
if isempty(endFstr)
    endFstr='-fa TTnew';
end
if ~exist('permContr','var')
    permContr='';
end
%if exist('tMax.txt','file')
    !rm tMax*.txt
%end
%if exist('tMaxReal.txt','file')
    !rm tMaxReal*.txt
%end
if exist(['A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc.BRIK'],'file')
    eval(['!rm A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc*'])
end
if exist('pos+tlrc.BRIK','file')
    !rm pos+tlrc*
end


% making 1000 permutations list
n = 8 ;
if strcmp(prefix2,'seg10M210')
    n=7; % bad Mark!
end

M = (dec2bin(0:(2^n)-1)=='1');
M4=M(find(sum(M')==4),:);
if n==7
    M3=M(find(sum(M')==3),:);
    M=[M3;M4];
else
    M=M4;
end
notM=abs(1-M);
Mrand=notM.*randi([2 5],size(M))+M;

combs=[1 2 3;1 3 2;2 1 3;2 3 1;3 1 2; 3 2 1]; % 6 possible orders for 3 conditions
% M = dec2base(0:(6^n)-1,6); % the possible arrangements for n subjects by 6 orders
% M1 = M=='0'; % first index is zero here
% M6 = M=='5'; % one and six are "true", real cond 2 is in the middle
% Mtrue=M6+M1;
% M4=M(find(sum(Mtrue')==4),:);
% if n==7
%     M3=M(find(sum(Mtrue')==3),:);
%     Mstr=[M3;M4];
% else
%     Mstr=M4;
% end
% M=ones(size(Mstr));
% for digiti=1:5
%     M=M+digiti*(Mstr==num2str(digiti));
% end
% M1=Mstr=='0';
%     M3=M(find(sum(M')==3),:);
% 
% 
%  M = dec2base(0:(3^7)-1,3);
% M1 = M=='2';
% M6 = M=='1'; 
% M=M(2:2^(n-1),:);
% if n==8
%     M=M(find(sum(M')==4),:);
% elseif n==7
%     M4=M(find(sum(M')==4),:);
%     M3=M(find(sum(M')==3),:);
%     M=[M4;M3];
% end
% M=M+1;

% M=randi(6,1000,n);
% eqcond=(M(:,1)==M(:,2)) + (M(:,1)==M(:,3)) + (M(:,1)==M(:,4)) + (M(:,1)==M(:,5)) + (M(:,1)==M(:,6));
% if ~isempty(find(eqcond==6))
%     M(eqcond==6,:)=[]; % remove permutation, equal to real comparison
% end
M=Mrand;
M(end+1,:)=1;

clustSize=zeros(length(M)-1,1);
conds={prefix1,prefix2,prefix3};
for permi=1:length(M)
    if exist('./TTnew+tlrc.BRIK','file')
        !rm TTnew+tlrc*
    end
    str=['3dANOVA2 -type 3 -alevels 3 -blevels ',num2str(n),' -mask ~/SAM_BIU/docs/MASKctx+tlrc'];
    for condi=1:3
        for subi=1:n
            str=[str,' -dset ',num2str(condi),' ',num2str(subi),' ',conds{combs(M(permi,subi),condi)},'_',num2str(subi),'+tlrc'];
        end
    end
    if isempty(permContr)
        permStr=' -fa TTnew'; % by default take the fixed var
    else
        permStr=[' ',permContr];
    end
    str1 = [str, permStr];
    [~, ~] = unix(str1);
    if permi==length(M)
        str2 = [str,' ',endFstr];
        eval(['!',str2])
    end
    for thri=1:length(tThresh)
        eval(['!~/abin/3dcalc -a TTnew+tlrc''','[1]''',' -exp ''','ispositive(a-',num2str(tThresh(thri)),')*a''',' -prefix pos'])
        eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh(thri)),' 5 125 pos+tlrc > posClust.txt'])
        posClust=importdata('posClust.txt');
        if iscell(posClust)
            posClustSize=0;
        else
            posClustSize=posClust(1)/125;
        end
        !rm pos+tlrc*
        !rm *Clust.txt
        % read max f value
        if permi==length(M)
            eval(['!~/abin/3dcalc -a TTnew+tlrc''','[1]''',' -exp ''','ispositive(',num2str(tThresh(thri)),'-a)*a''',' -prefix neg'])
            eval(['!~/abin/3dclust -quiet -1clip ',num2str(tThresh(thri)),' 5 125 neg+tlrc > negClust.txt'])
            negClust=importdata('negClust.txt');
            if iscell(negClust)
                negClustSizeReal(thri)=0;
            else
                negClustSizeReal(thri)=negClust(1)/125;
            end
            !rm neg+tlrc*
            !rm *Clust.txt
            if thri==1
                !~/abin/3dBrickStat -max TTnew+tlrc'[1]' >> tMaxReal.txt
                !~/abin/3dBrickStat -min TTnew+tlrc'[1]' >> tMinReal.txt
            end
            clustSizeReal(thri)=posClustSize;
        else
            if thri==1
                !~/abin/3dBrickStat -max TTnew+tlrc'[1]' >> tMax.txt
            end
            % compute volume of largest positive and negative clusters
            clustSize(permi,thri)=posClustSize;
        end
    end
end
clustSize=sort(clustSize,'descend');
% take the 5% greatest volumes (in voxels) as critical cluster size
critClustSize=clustSize(ceil(0.05*(permi-1)),:);critClustSize(2,:)=clustSize(ceil(0.1*(permi-1)),:);
% take the 5% extreme f values as criticat f
tList=importdata('tMax.txt');
for ti=1:length(tList)
    flist(ti)=str2num(tList{ti}(1:8));
end

tList=sort(flist,'descend');
critT=tList(ceil(0.05*(permi-1)));critT(2,1)=tList(ceil(0.1*(permi-1)));
!rm tMax.txt

% real ttest data
tMaxReal=importdata('tMaxReal.txt');
tReal=str2num(tMaxReal{end,1}(1:8));
tMinReal=importdata('tMinReal.txt');
tReal(1,2)=str2num(tMinReal{end,1}(1:8));

threshDisp='';
for thri=1:length(tThresh)
    threshDisp=[threshDisp,num2str(tThresh(thri)),'  '];
end
diary ('log.txt');
disp('===========================================');
disp(['A2_',prefix1,'_',prefix2,'_',prefix3,'_4+tlrc'])
disp(['critical T value  (two sided)      : ',num2str(critT(1))]);
disp(['critical T value  (one sided)      : ',num2str(critT(2))]);
disp(['the largets T value                : ',num2str(max(abs(tReal)))])
disp(['T threshold                        :    ', threshDisp]);
disp(['critical cluster size (two sided)  :    ', num2str(critClustSize(1,:))]);
disp(['critical cluster size (one sided)  :    ', num2str(critClustSize(2,:))]);
disp(['largest positive cluster           :    ', num2str(clustSizeReal)]); % FIXME take also negClustSizeReal
disp(['largest negative cluster           :    ', num2str(negClustSizeReal)]);
disp('===========================================');
diary off;
% % make log
% !echo =========================================== >> log.txt
% eval(['!echo A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc >> log.txt'])
% eval(['!echo critical T value      : ',num2str(critT),' >> log.txt']);
% eval(['!echo the largets T value   : ',num2str(tReal),' >> log.txt'])
% eval(['!echo T threshold             :    ', threshDisp,' >> log.txt'])
% eval(['!echo critical cluster size   :    ', num2str(critClustSize),' >> log.txt']);
% eval(['!echo largest cluster         :    ', num2str(clustSizeReal),' >> log.txt'])
% !echo =========================================== >> log.txt
% !~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc &
