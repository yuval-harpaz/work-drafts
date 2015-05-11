
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
for subi=1:8
    subj=['alice',upper(sf{subi}(1)),sf{subi}(2:end)];
    cd /usr/local/freesurfer/subjects/
    cd (subj)
    cd bem
    str=['ln -s watershed/',subj,'_inner_skull_surface inner_skull.surf'];
    [~,w]=unix(str);
    if ~isempty(w)
        disp([subj,' ',w])
    end
end