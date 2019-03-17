close all;
clear;

%size of region
particles= 10;
q=1.602e-19;
xsize= 200e-9;
xstart= 0;
ysize= 100e-9;
ystart= 0;
%positions

initialpos= zeros(particles,6);
prevpos= zeros(particles,2);

temp= 300;
m0= 9.11e-31;
meff= 0.26*m0;
kb= 1.38e-23;

velocity= sqrt((kb*temp)/meff);
colour = hsv(particles);

tmn= 0.2e-12;
pscat= 1-exp(-1e-14/tmn);

voltage= 0.1;
efield= voltage/xsize;
fprintf('The electric field is %i\n',efield);
force= efield*q;
fprintf('The force is %i\n',force);
acceleration= force/meff;
fprintf('The acceleration is %i\n',acceleration);

for i=1:1:particles
    for j=1:1:6
        if(j==1)
            randx= rand(1,1);
            initialpos(i,j)= randx*xsize; 
        elseif(j==2)
            randy= rand(1,1);
            initialpos(i,j)= randy*ysize; 
        elseif(j==3)
            randd= rand(1,1);
            initialpos(i,j)= randd*2*pi;
        elseif(j==4)
            initialpos(i,j)= velocity;
        elseif(j==5)
            randvx= randn(1,1);
            vx= (velocity/sqrt(2))*randvx;
            initialpos(i,j)= vx;
        else
            randvy= randn(1,1);
            vy= velocity*randvy;
            initialpos(i,j)= vy; 
        end 
    end        
end
% fprintf('The thermal velocity is %d \n',vth);
timestep = 1e-14;
finaltime = 1e-12;
totaltime = finaltime/timestep;
T = zeros(1,totaltime);
Tmatrix = zeros(1,totaltime);
counter= 1; 
time=0;

%Boundary conditions: 
for i =0:timestep:finaltime
   figure (1);
   title 'Part 1: 2D Trajectories of Electrons';
   hold on;
   pause(0.01);
    for j=1:1:particles
        if ((initialpos(j,1)+initialpos(j,2)*timestep)>=xsize)
            initialpos(j,1) = xstart;
            prevpos(j,1) = xstart;
        elseif((initialpos(j,1)+initialpos(j,2)*timestep)<=xstart)
            initialpos(j,1)=xsize;
            prevpos(j,1) = xsize; 
        end
        if((initialpos(j,2)+initialpos(j,1)*timestep)>=ysize) 
              initialpos(j,6)= -initialpos(j,6);
        elseif((initialpos(j,2)+initialpos(j,1)*timestep)<=ystart)
              initialpos(j,6)= -initialpos(j,6);
        end
  
       for k=1:1:particles
           scatter= rand(1,1);
           if scatter <=0.01
               randvy= randn(1,1);
               vy= (velocity/sqrt(2))*randvy;
               initialpos(k,6)= vy;
               randvx= randn(1,1);
               vx= (velocity/sqrt(2))*randvx;
               initialpos(k,5)= vx;
           end
       end
    
      if i~=0
    %initial positions
    plot([prevpos(j,1),initialpos(j,1)],[prevpos(j,2),initialpos(j,2)],'color',colour(j,:));
    axis([0 200e-9 0 100e-9]); 
      end
    end

    prevpos(:,1) = initialpos(:,1);
    prevpos(:,2) = initialpos(:,2);

    initialpos(:,5)= (initialpos(:,5)+acceleration*timestep);
    initialpos(:,1)= initialpos(:,1)+(initialpos(:,5)).*timestep;
    initialpos(:,2)= initialpos(:,2)+initialpos(:,6).*timestep;
    
    for l=1:particles
        temp= ((initialpos(l,5).^2+initialpos(l,6).^2)*meff)/(2*kb);
        temp=temp+temp;
    end
    
    avg= temp/particles;
    T(1,counter)= avg;
    time= time+timestep;
    Tmatrix(1,counter)= time;
    counter= counter+1;

end
   figure(2);
   plot(Tmatrix,T);
   title 'Temperature Plot';
   ylabel 'Temperature (K)';
   xlabel 'Time (s)'; 
  