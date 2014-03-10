%% check shift and tilt
cd /home/yuval/Data/Denis/REST
load subs

for subi=1:length(subs)
    cd (num2str(subs(subi)))
    %load coilpos
    hdr=ft_read_header('clean-raw.fif');
    grad = mne2grad(hdr);
    coilpos=grad.coilpos(1:248,:);
    L=coilpos(233,:); % A233
    R=coilpos(244,:); % A244
    p=R(2)-L(2); % how much left is posterior to right
    l=-L(1)-(R(1)-L(1))/2; % how much left is more to the left
    i=L(3)-R(3); % how much left is below right (head leans to right)
    A233pli(subi,1:3)=[p,l,i];
    cd ..
end

[a,b]=ttest(A233pli(:,1));
[a,b]=ttest(A233pli(:,2));
mean(A233pli);
save A233pli A233pli

% Denis A233pli mean  0.9022   -0.5078   -0.0764
% alice A233pli mean  4.1327    3.3621   -0.7052
% p - A233 is more posterior than A244, meaning that both turn the head to
%      the right but in Denis data it is less than a mm
% l - in Denis data the head is 0.5mm closer to the left side. alice, 3mm
%      to the right
