%powList
chan='A158';
freq=[4,10];
% rest
pat='/media/Elements/MEG/talResults'
cd(pat)
load squad01_pow94_1

%[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,chi]=ismember(chan,pow.label);

subsV1={'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36'};
subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602'};

dirs={'/media/Elements/MEG/talResults'};
for diri=1:length(dirs)
    cd(dirs{diri})
    for subi=1:length(subsV1)
        try
            load(['s',subsV1{subi},'_pow94_1'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,1)=col(:,1);
list10(1:35,1)=col(:,2);
for diri=1:length(dirs)
    cd(dirs{diri})
    for subi=1:length(subsV1)
        try
            load(['s',subsV1{subi},'_pow94_2'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,2)=col(:,1);
list10(1:35,2)=col(:,2);

for diri=1:length(dirs)
    cd(dirs{diri})
    for subi=1:length(subsV2)
        try
            load(['s',subsV2{subi},'_pow94_1'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,3)=col(:,1);
list10(1:35,3)=col(:,2);
for diri=1:length(dirs)
    cd(dirs{diri})
    for subi=1:length(subsV2)
        try
            load(['s',subsV2{subi},'_pow94_2'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,4)=col(:,1);
list10(1:35,4)=col(:,2);

% time production
list4=[];list10=[];
cd /media/Elements/MEG/tal
for diri=1:length(dirs)
    for subi=1:length(subsV1)
        try
            load(['s',subsV1{subi},'_pow112'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV1{subi},' had an error. was there a s',subsV1{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,1)=col(:,1);
list10(1:35,1)=col(:,2);
for diri=1:length(dirs)
    for subi=1:length(subsV2)
        try
            load(['s',subsV2{subi},'_pow112'])
            col(subi,1:length(freq))=pow.powspctrm(chi,freq);
        catch
            display([subsV2{subi},' had an error. was there a s',subsV2{subi},'_pow94_1 file?']);
        end
    end
end
list4(1:35,2)=col(:,1);
list10(1:35,2)=col(:,2);
%% oneBack

subsV1={'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36'};
subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602'};
talPower1bk(subsV1);
talPower1bk(subsV2); % error with sub 3602
list4=[];list10=[];
cd /media/Elements/MEG/talResults
freq=[4 10];
for subi=1:length(subsV1)
    try
        load(['s',subsV1{subi},'_pow_W'])
        if subi==1
            [~,chi]=ismember('A158',pow.label);
        end
        col(subi,1:length(freq))=pow.powspctrm(chi,freq);
    catch
        display([subsV1{subi},' had an error']);
    end
end

list4(1:35,1)=col(:,1);
list10(1:35,1)=col(:,2);
for subi=1:length(subsV2)
    try
        load(['s',subsV2{subi},'_pow_W'])
        col(subi,1:length(freq))=pow.powspctrm(chi,freq);
    catch
        display([subsV2{subi},' had an error']);
    end
end
list4(1:35,2)=col(:,1);
list10(1:35,2)=col(:,2);
% nonwords
list4=[];list10=[];
for subi=1:length(subsV1)
    try
        load(['s',subsV1{subi},'_pow_NW'])
        if subi==1
            [~,chi]=ismember('A158',pow.label);
        end
        col(subi,1:length(freq))=pow.powspctrm(chi,freq);
    catch
        display([subsV1{subi},' had an error']);
    end
end
%v2
list4(1:35,1)=col(:,1);
list10(1:35,1)=col(:,2);
for subi=1:length(subsV2)
    try
        load(['s',subsV2{subi},'_pow_NW'])
        col(subi,1:length(freq))=pow.powspctrm(chi,freq);
    catch
        display([subsV2{subi},' had an error']);
    end
end
list4(1:35,2)=col(:,1);
list10(1:35,2)=col(:,2);

