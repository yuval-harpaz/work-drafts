function aquaLogPtoZ(prefix)
% subsV1={'quad01'; 'quad02';  'quad03';  'quad04';  'quad08';  'quad11';  'quad29';  'quad31';  'quad39';  'quad40';  'quad41';  'quad42'  ;'quad05';  'quad06';  'quad07';  'quad09';  'quad10';  'quad14';  'quad15';  'quad16';  'quad18';  'quad37';  'quad38';  'quad12';  'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36'};
% subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602'};

%subs={'quad01'; 'quad02';  'quad03';  'quad04';  'quad08';  'quad11';  'quad29';  'quad31';  'quad39';  'quad40';  'quad41';  'quad42'  ;'quad05';  'quad06';  'quad07';  'quad09';  'quad10';  'quad14';  'quad15';  'quad16';  'quad18';  'quad38';'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3802'};
z=@(p) -sqrt(2) * erfcinv(p); % two tailed


OptTSOut.View = 'tlrc';
cd /media/Elements/quadaqua/SAM
load ../subs subs

for subi=1:length(subs)
    BrikName=[prefix,'_',num2str(subi),'+tlrc'];
    OptTSOut.Prefix = [prefix,'z_',num2str(subi)];
    V=[];
    Info=[];
    [~, V, Info, ~] = BrikLoad (BrikName);
    V=10.^(-V);
    V=-z(V);
    WriteBrik (V, Info, OptTSOut);
end


