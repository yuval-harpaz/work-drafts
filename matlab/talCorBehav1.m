function voxV=talCorBehav1(subs,coordinates,fName,pat)

% fName='alpha1';
% coords=[ -40 -18 -8;40 -18 -8;... %   LR hippo, Wink 2006
% -49 17 17;49 17 17;... %        Broca
% -39 29 -6;39 29 -6;... %        IFG 47
% -48 -5 -21;48 -5 -21;... %      ITG
% -57 -12 -2;57 -12 -2;... %      STG
% -14 -20 12;14 -20 12;... %      thalamus
% -34 18 2;34 18 2;...    %       insula
% -30 -61 -36;30 -61 -36;... %    cerebellum
% -35 -25 60;35 -25 60]; %        central



cd ([pat,'Results']);
for voxi=1:size(coordinates,1)
    x=num2str(coordinates(voxi,1));
    y=num2str(coordinates(voxi,2));
    z=num2str(coordinates(voxi,3));
    for si=1:length(subs)
        cd(subs{si})
        eval(['!~/abin/3dmaskdump -nbox ',x,' ',y,' ',z,' -noijk ',fName,'+tlrc > ~/Desktop/vox.txt']);
        voxV(si,voxi)=importdata('~/Desktop/vox.txt');
        cd ..
    end
end
!rm ~/Desktop/vox.txt
end