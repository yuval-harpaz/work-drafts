function SchizX0
cd /media/yuval/Elements/SchizoRestMaor
load Subs
load SubsXtimes
xSubs=find(ismember(Subs(:,3),'x'));
for subi=1:length(xSubs)
    sub=Subs{xSubs(subi),1};
    cd(sub)
    if exist('dataRest.mat','file')
        if exist('splitconds.mat','file')
            !rm dataRest.mat
        end
    end
    cd ../
end

disp('finish');
%         fileName=&& ~exist(['rs,xc,hb,lf_',source],'file')
%         try
%         p=pdf4D(fileName);
%         cleanCoefs = createCleanFile(p, fileName,...
%             'byLF',256,'Method','Adaptive',...
%             'xClean',[4,5,6],...
%             'chans2ignore',[],...
%             'byFFT',0,...
%             'HeartBeat',[],... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%             'maskTrigBits', 256);
%         catch
%             disp(['createCleanFile failed for ',sub,'.'])
%         end


