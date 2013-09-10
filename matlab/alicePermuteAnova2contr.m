function [critT,critClustSize]=alicePermuteAnova2contr(prefix1,prefix2,prefix3,tThresh,endFstr,permContr)
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

combs=[1 2 3;1 3 2;2 1 3;2 3 1;3 1 2; 3 2 1];
M=randi(6,1000,n);
eqcond=(M(:,1)==M(:,2)) + (M(:,1)==M(:,3)) + (M(:,1)==M(:,4)) + (M(:,1)==M(:,5)) + (M(:,1)==M(:,6));
if ~isempty(find(eqcond==6))
    M(eqcond==6,:)=[]; % remove perutation, equal to real comparison
end
M(end+1,:)=1;

clustSize=zeros(length(M)-1,1);
conds={prefix1,prefix2,prefix3};
for permi=1:length(M)
    if exist('./TTnew+tlrc.BRIK','file')
        !rm TTnew+tlrc*
    end
    str=['~/abin/3dANOVA2 -type 3 -alevels 3 -blevels ',num2str(n),' -mask ~/SAM_BIU/docs/MASKctx+tlrc'];
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
    if permi==length(M)
        str2 = [str,' ',endFstr];
    end
    %     eval(['!',str])
    [~, ~] = unix(str1);
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
            if thri==1
                !~/abin/3dBrickStat -max TTnew+tlrc'[1]' >> tMaxReal.txt
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
critClustSize=clustSize(ceil(0.05*(permi-1)),:);
% take the 5% extreme f values as criticat f
fList=importdata('tMax.txt');
for fi=1:length(fList)
    flist(fi)=str2num(fList{fi}(1:8));
end

fList=sort(flist,'descend');
critT=fList(ceil(0.05*(permi-1)));
!rm tMax.txt

% real ttest data
fReal=importdata('tMaxReal.txt');
fReal=str2num(fReal{end,1}(1:8));
sig={' ',' '};
nothing=true;
if fReal>critT
    sig{1}='*';
    nothing=false;
end
if sum(clustSizeReal>critClustSize)>0
    sig{2}='*';
    nothing=false;
end
threshDisp='';
for thri=1:length(tThresh)
    threshDisp=[threshDisp,num2str(tThresh(thri)),'  '];
end
disp('===========================================')
disp(['critical T value      : ',num2str(critT)]);
disp(['the largets T value   : ',num2str(fReal),' ',sig{1}])
disp('===========================================')
disp(['T threshold             :    ', threshDisp])
disp(['critical cluster size   :    ', num2str(critClustSize)]);
disp(['largest cluster         :    ', num2str(clustSizeReal),' ',sig{2}])
disp('===========================================')
disp('')
if nothing
    disp('NOTHING!!!')
end
eval(['!mv TTnew+tlrc.BRIK A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc.BRIK'])
eval(['!mv TTnew+tlrc.HEAD A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc.HEAD'])
% make log
!echo =========================================== >> log.txt
eval(['!echo A2_',prefix1,'_',prefix2,'_',prefix3,'+tlrc >> log.txt'])
eval(['!echo critical T value      : ',num2str(critT),' >> log.txt']);
eval(['!echo the largets T value   : ',num2str(fReal),' >> log.txt'])
eval(['!echo T threshold             :    ', threshDisp,' >> log.txt'])
eval(['!echo critical cluster size   :    ', num2str(critClustSize),' >> log.txt']);
eval(['!echo largest cluster         :    ', num2str(clustSizeReal),' >> log.txt'])
!echo =========================================== >> log.txt
!~/abin/afni -dset ~/SAM_BIU/docs/temp+tlrc &
