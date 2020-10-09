function []=datadivider()
%This Function divides data for trainning (70%) and evaluating (30%)
    
label=3;
switch label
    case 1
        cd Attached
    case 2
        cd Near
    case 3
        cd Far
end

f = dir('*.stl');
n = numel(f);
r=randperm(n, n);
rtest = r(1:round(length(r)*0.3));
rtrain=r(round(length(r)*0.3)+1:length(r));

if any(size(dir(['test' '/*.stl' ]),1)) %check if already sorted
    clc;disp('Already sorted.');
    cd ..
    return;
elseif ~exist('test', 'dir')
       mkdir('test')
end

batch=round(size(rtest,2)/20);
for i=1:size(rtest,2)
    if rem(i,20)==1
        fprintf('\nProcessing test batch %d of %d ',round(i/20)+1,batch);
    end
    fprintf('>');
    
    switch label
    case 1
         rename=append('Attached_test_',num2str(i,'%04.f'),'.stl');
    case 2
         rename=append('Near_test_',num2str(i,'%04.f'),'.stl');
    case 3
         rename=append('Far_test_',num2str(i,'%04.f'),'.stl');
    end
    movefile(f(rtest(i)).name,rename);
    movefile(rename, 'test');
end

if ~exist('train', 'dir')
       mkdir('train')
end
batch=round(size(rtrain,2)/20);
for i=1:size(rtrain,2)
    
    if rem(i,20)==1
        fprintf('\nProcessing trainning batch %d of %d ',round(i/20)+1,batch);
    end
    fprintf('>');
    
    switch label
    case 1
         rename=append('Attached_train_',num2str(i,'%04.f'),'.stl');
    case 2
         rename=append('Near_train_',num2str(i,'%04.f'),'.stl');
    case 3
         rename=append('Far_train_',num2str(i,'%04.f'),'.stl');
    end
    movefile(f(rtrain(i)).name,rename);
    movefile(rename, 'train');
end
fprintf('\n------------------------------Done!-------------------------------\n');
cd ..
end


