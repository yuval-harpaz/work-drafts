
% 1. prepare a spreadsheet column with words in 's ('רכבת').
% 2. copy and ctrl v it to {}stim in stim.mat.
% 3. load stim.mat

%clear all
%load stim

nameFrost=stim(:,1);
for letteri=1:27
    nameFrost=strrep(nameFrost,ISO8859_8{letteri,2},ISO8859_8{letteri,1});
end
% s1='<td>�</td>';
% s2='<td>��</td>';
% s3='<td>���</td>';
% s4='<td>����</td>';
% s5='<td>�����</td>';
% s6='<td>������</td>';
% s7='<td>�������</td>';
% s8='<td>��������</td>';
% s9='<td>���������</td>';
% s10='<td>����������</td>';
% s11='<td>�����������</td>';
% s12='<td>������������</td>';


s1='<td>?</td>';
s2='<td>??</td>';
s3='<td>???</td>';
s4='<td>????</td>';
s5='<td>?????</td>';
s6='<td>??????</td>';
s7='<td>???????</td>';
s8='<td>????????</td>';
s9='<td>?????????</td>';
s10='<td>??????????</td>';
s11='<td>???????????</td>';
s12='<td>????????????</td>';
%lookfor={'<td>��</td>','<td>���</td>','<td>����</td>','<td>�����</td>','<td>������</td>','<td>�������</td>',...
%    '<td>��������</td>','<td>���������</td>','<td>����������</td>','<td>�����������</td>','<td>������������</td>','<td>�������������</td>','<td>��������������</td>','<td>���������������</td>','<td>����������������</td>','<td>�����������������</td>'};

for i=1:size(nameFrost,1)
    pagename=['http://word-freq.mscc.huji.ac.il/wordfreq.asp?search=',nameFrost{i,1}(1,1:end)];
    [s res]=urlread(pagename);
    str=['LF=s',num2str(length([stim{i,1}])),';'];
    eval(str);
    str1=['k=strfind(s, ''',LF,''');'];
    eval(str1);
    if ~isempty(k)
        k=k+30+length([stim{i,1}]);
        k1=k+strfind(s(1,k:k+15), '<');
        k1=k1(1,1)-2;
        stim(i,2)={s(1,k:k1)};
        i
    else
        warning ('the exact string was not found');
        i
    end
    
end
save stimf.mat stim
clear
load stimf