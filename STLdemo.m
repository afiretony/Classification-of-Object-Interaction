function []=STLdemo()
%This function randomly choose 8 (adjustable) stl files in the training
%set and shows them in one figure
%MVP function: stlread
%Auther: Chenhao Yang, Mechanical Engineering student @Technion

%There are three types of labels:[Attached, Near, Far]=[1, 2, 3]
%Need manually switch it when generating demonstration images.
label=1;

switch label
    case 1
        cd Attached/train
    case 2
        cd Near/train
    case 3
        cd Far/train
end

%Set number of scenes  per image.
%Please choose a even number, there are two rows.
n=8;

fMY
tot=numel(f);
list=randperm(tot, n);
fh=figure('unit','normalized','position',[0.1,0.2,0.7,0.6]); 
fh.Color='white';
color=[0.9 0.9 0.9]-0.4;
for i=1:n
        if i<=n/2
         axesh=axes('parent',fh,'unit','normalized','position',[(i-1)/n*2+0.05,0,1/n*0.8*2,0.5]);
        else
         axesh=axes('parent',fh,'unit','normalized','position',[((i-n/2)-1)/n*2+0.05,0.5,1/n*0.8*2,0.5]);
        end
        %And God said, let there be light(s)
        h1 =light;
        h1.Color=color;
        h1.Position=[0 -2 2]*2;
        h1.Style = 'local';
        h2 =light;
        h2.Color=color;
        h2.Position=[-2 0 2]*2;
        h2.Style = 'local';
         h3 =light;
        h3.Color=color;
        h3.Position=[2 2 1.5];
        h3.Style = 'local';
        
        a=1;
        axesh.XLim=[-a,a];
        axesh.YLim=[-a,a];
        axesh.ZLim=[-a,a];
        grid on;
        
        switch label
            case 1
                str1='Attached_train_';
            case 2
                str1='Near_train_';
            case 3
               str1='Far_train_';
        end
        str2=num2str(list(i),'%04.f');
        str=append(str1,str2,'.stl');
        TR=stlread(str);
        ph=patch('Faces',TR.ConnectivityList,'Vertices',TR.Points,'facecolor',color,'edgecolor',[0.1 0.1 0.1]);
        ph.LineStyle='none';
        ph.LineWidth=0.1;
        view(3)
        daspect([1 1 1])
end

cd ..
cd ..
clc;
end