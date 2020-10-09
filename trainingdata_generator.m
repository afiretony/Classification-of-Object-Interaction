%------------------------------------Main-function------------------------------------%
function trainingdata_generator()
%This is the main function for generating training data
%cd to your folder of this .m file
%Outputs are STL files stored in Sub-folders 

%Setup
close all;clc;clear;

%There are three types of labels:[Attached, Near, Far]=[1, 2, 3]
%Need manually switch it when generating trainning data.
label=3;
switch label
    case 1
  if ~exist('Attached', 'dir')
       mkdir('Attached')
  end
    case 2
    if ~exist('Near', 'dir')
       mkdir('Near')
    end
    case 3
  if ~exist('Far', 'dir')
       mkdir('Far')
  end
end

 %Here we define variances of the data
 %Size relationship of your choice
 sizelib=[1/3,1/2,1,2,3];
 %Number of size relationships
nsize=size(sizelib,2);
%Number of objects
nobject=8;
%Number of combinations
nC=nchoosek(nobject,2);
%Number of orientation and spatial distributions generated randomly
ndis=10;

counter=1;

for i=1:nC
    fprintf('\nProcessing batch %d of %d  ',i,nC);
    for ii=1:nsize
         fprintf('>>>');
        for iii=1:ndis
            %first object
             scale=1; 
             thx=rand(1)*360;   thy=rand(1)*360;    thz=rand(1)*360;
             thetaX=deg2rad(thx);thetaY=deg2rad(thy); thetaZ=deg2rad(thz); 
             translation=[0 0 0];
             T1=transformation(scale, thetaX, thetaY, thetaZ, translation);
             %second object
             scale=sizelib(ii);
             thx=rand(1)*360;   thy=rand(1)*360;    thz=rand(1)*360;
              thetaX=deg2rad(thx);thetaY=deg2rad(thy); thetaZ=deg2rad(thz); 
              %Translation of the second object to compensate effect of
              %scaling and create distance between center of objects
              switch label
                  case 1
              %-------------------------------Attached---------------------------%
              translation=[1 1 1].*(0.7*scale+0.7);
                  case 2
              %--------------------------------Near-------------------------------%
              translation=[1 1 1].*(1.1*scale+2.5);
                  case 3
              %---------------------------------Far--------------------------------%
              translation=[1 1 1].*(1.5*scale+8);
              end
              
             T2=transformation(scale, thetaX, thetaY, thetaZ, translation);
                
                switch i
                    case 1
                        [F1,V1]=cube(T1);
                        [F2,V2]=sphere(T2);
                    case 2
                        [F1,V1]=cube(T1);
                        [F2,V2]=cylinder(T2);
                    case 3
                        [F1,V1]=cube(T1);
                        [F2,V2]=cone(T2);
                    case 4
                        [F1,V1]=cube(T1);
                        [F2,V2]=hemispheroid(T2);
                    case 5
                        [F1,V1]=cube(T1);
                        [F2,V2]=tablet(T2);
                    case 6
                        [F1,V1]=cube(T1);
                        [F2,V2]=pyramid(T2);
                    case 7
                        [F1,V1]=cube(T1);
                        [F2,V2]=triangular_prism(T2);
                    case 8
                        [F1,V1]=sphere(T1);
                        [F2,V2]=cylinder(T2);
                    case 9 
                        [F1,V1]=sphere(T1);
                        [F2,V2]=hemispheroid(T2);
                    case 10
                        [F1,V1]=sphere(T1);
                         [F2,V2]=tablet(T2);
                    case 11
                        [F1,V1]=sphere(T1);
                       [F2,V2]=pyramid(T2);
                    case 12
                        [F1,V1]=sphere(T1);
                        [F2,V2]=triangular_prism(T2);
                    case 13
                        [F1,V1]=sphere(T1);
                        [F2,V2]=cone(T2);
                    case 14
                        [F1,V1]=cylinder(T1);
                        [F2,V2]=cone(T2);
                    case 15
                        [F1,V1]=cylinder(T1);
                        [F2,V2]=hemispheroid(T2);
                    case 16
                        [F1,V1]=cylinder(T1);
                        [F2,V2]=tablet(T2);
                    case 17
                        [F1,V1]=cylinder(T1);
                        [F2,V2]=pyramid(T2);
                    case 18
                        [F1,V1]=cylinder(T1);
                        [F2,V2]=triangular_prism(T2);
                    case 19
                        [F1,V1]=cone(T1);
                        [F2,V2]=hemispheroid(T2);
                    case 20
                        [F1,V1]=cone(T1);
                        [F2,V2]=tablet(T2);
                    case 21
                        [F1,V1]=cone(T1);
                        [F2,V2]=pyramid(T2);
                    case 22
                        [F1,V1]=cone(T1);
                        [F2,V2]=triangular_prism(T2);
                    case 23
                         [F1,V1]=hemispheroid(T1);
                         [F2,V2]=tablet(T2);
                    case 24
                         [F1,V1]=hemispheroid(T1);
                         [F2,V2]=pyramid(T2);
                    case 25
                         [F1,V1]=hemispheroid(T1);
                         [F2,V2]=triangular_prism(T2);
                    case 26
                         [F1,V1]=tablet(T1);
                         [F2,V2]=pyramid(T2);
                    case 27
                        [F1,V1]=tablet(T1);
                         [F2,V2]=triangular_prism(T2);
                    case 28
                         [F1,V1]=pyramid(T1);
                         [F2,V2]=triangular_prism(T2);
                end
                
                F2=F2+size(V1,1);
                F=[F1;F2];V=[V1;V2];
                %Data pre-process
                %Regulazition
                %make the center of gravity @ origin
                CG=[max(V(:,1))+min(V(:,1)), max(V(:,2))+min(V(:,2)),max(V(:,3))+min(V(:,3))]./2;
                V=V-CG;
                %make the objects fit in a box of [-1 1]
                maxratio=max([max(V(:,1))-min(V(:,1)), max(V(:,2))-min(V(:,2)),max(V(:,3))-min(V(:,3))])/2;
                V=V./maxratio;
                FV=triangulation(F,V);  
                switch label
                    case 1
                          %-------------------------------Attached---------------------------%
                          str1='Attached_'; str2=num2str(counter,'%04.f'); 
                          str=append(str1,str2,'.stl');
                          cd Attached
                    case 2
                          %--------------------------------Near-------------------------------%
                          str1='Near_'; str2=num2str(counter,'%04.f');
                          str=append(str1,str2,'.stl');
                          cd Near
                    case 3
                          %---------------------------------Far--------------------------------%
                          str1='Far_'; str2=num2str(counter,'%04.f');
                          str=append(str1,str2,'.stl');
                          cd Far
                end
                counter=counter+1;
                stlwrite(FV,str);
                cd ..
        end
    end
end
fprintf('\n------------------------------Done!-------------------------------\n');
end

%------------------------------------Sub-functions------------------------------------%
function [T]=transformation(scale, thetaX, thetaY, thetaZ, translation)
RZ=[cos(thetaZ),-sin(thetaZ),0,0;sin(thetaZ),cos(thetaZ),0,0;0 0 1 0;0 0 0 1];
RY=[cos(thetaY),0,sin(thetaY),0;0 1 0 0;-sin(thetaY),0,cos(thetaY),0;0 0 0 1];
RX=[1 0 0 0;0 cos(thetaX),-sin(thetaX),0;0, sin(thetaX),cos(thetaX),0;0 0 0 1];
S=[scale,0,0,0;0 scale,0 0 ;0 0 scale 0;0 0 0 1];
TL=[1 0 0 translation(1);0 1 0 translation(2);0 0 1 translation(3);0 0 0 1];
T=RX*RY*RZ*TL*S;
end

function [F,V]=cube(T)
%Cube
V=2*[.5,-.5,.5;.5,.5,.5;-.5,.5,.5;-.5,-.5,.5;.5,-.5,-.5;.5,.5,-.5;-.5,.5,-.5;-.5,-.5,-.5];
F=[1 2 4;2 3 4;5 6 2; 2 1 5; 6 7 3 ;2 6 3; 1 4 8;8 5 1;5 8 7; 6 5 7; 4 3 7; 8 4 7];
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=sphere(T)
%sphere
[X,Y,Z] = meshgrid(-1:0.4:1,-1:0.4:1,-1:0.4:1);
V = sqrt(X.^2+Y.^2+Z.^2);
[F,V] = isosurface(X,Y,Z,V);
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=cylinder(T)
TR=stlread('cyl.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=cone(T)
TR=stlread('cone.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=hemispheroid(T)
TR=stlread('Hemispheroid.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=tablet(T)
TR=stlread('tablet.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=pyramid(T)
TR=stlread('pyramid.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end
function [F,V]=triangular_prism(T)
TR=stlread('triangular prism.stl');
scale=2/(max(TR.Points(:,1))-min(TR.Points(:,1)));
V=TR.Points.*scale;
V(:,3)=V(:,3)-1;
F=TR.ConnectivityList;
for i=1:size(V,1)
    temp=T*transpose([V(i,:),1]);
    temp=transpose(temp);
    temp(4)=[];
    V(i,:)=temp;
end
end