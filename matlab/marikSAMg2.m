function marikSAMg2(time,fold,fn,pat)
if ~exist('pat','var')
    pat='/home/yuval/Data/epilepsy/b162b';
end
cd(pat);
% time=[130 133];
if ~exist('fold','var')
    fold='';
end
if isempty(fold)
    fold='1';
end
if ~exist('fn','var')
    fn='';
end
if isempty(fn)
    fn='c,rfhp1.0Hz';
end
cd (pat)
cd (fold)
Trig2mark('all',time(1));
cd ..



% eval(['!SAMcov64 -d ',fn,' -r ',fold,' -m Spikes1 -v'])
% eval(['!SAMwts64 -d ',fn,' -r ',fold,' -m Spikes1 -c alla -v'])
% 
% eval(['!SAMcov64 -d ',fn,' -r ',fold,' -m Spikes2 -v'])
% eval(['!SAMwts64 -d ',fn,' -r ',fold,' -m Spikes1 -c alla -v'])
% eval(['!SAMepi -d ',fn,' -r ',fold,' -m Spikes2 -v'])

