function chansH=LRhomolog(chans)
chansH=cell(size(chans));
load LRpairs
[Lo,Li]=ismember(chans,LRpairs(:,1));
chansH(Lo)=LRpairs(Li(Lo),2);
[Ro,Ri]=ismember(chans,LRpairs(:,2));
chansH(Ro)=LRpairs(Ri(Ro),2);