function configuration = nQueensProblem(N,npop,ngenmax)
   %NQUEENSPROBLEM The N-Queens problem is solved by a genetic algorithm.
   % It also plots the graph of the best solution and the average solution.
   %
   %   Prototypes:
   %      config = nQueensProblem(N,npop,ngenmax);
   %      config = nQueensProblem;
   %           [uses defaut values 8, 30, 100]
   %
   %   Input arguments:
   %      N: board size
   %      npop: population size for the algorithm
   %      ngenmax: maximum number of generations for the algorithm
   %
   %   Output arguments:
   %      configuration: solution that makes the fitness function zero or
   %        empty array otherwise.
   %         
   %
   %   See also NQUEENSPROBLEM.

close all;

if nargin<1
   N = 8; %board size
   npop = 30; %population size (between 30 and 50)
   ngenmax = 100;
end

P = zeros(npop,N);
f = zeros(1,npop);

for i=1:npop
   P(i,:) = randperm(N); % initialize population with random candidate solutions
   f(i) = fitness_nq(P(i,:)); % evaluate candidates
end

%%%%%%%%%%%%
%plot
fbestplot = min(f);
fmeanplot = mean(f);
%%%%%%%%%%%

%ngenmax = 10;
ngen = 2; %generation number
nselect = 5; % number of parents selected
parents = zeros(2,N);

while((min(f)>0) & (ngen<=ngenmax)) 
    pos = randi(npop,1,nselect); %select 5 random individuals
    
    % from the 5 selected, choose the 2 best ones
    f_selected = f(pos);
    [~, order] = sort(f_selected);
    
    %select the first parent
    parents(1,:) = P(pos(order(1)),:);
    
    %find a second parent that is different than the one already selected
    j=2;
    while pos(order(j))==pos(order(j-1)) && j<=length(order)
       j=j+1;
    end
    
    if j>length(order) % all of the selected parents are equal
       parents(2,:) = P(pos(order(2)),:);
    else % select the first different parent with best fitness function value
       parents(2,:) = P(pos(order(j)),:);
    end
    
    children = CutAndCrossfill_Crossover(parents);
    
    mutationProb = rand(1); % mutation probability
    ngenes_mutation = 2; %number of genes that will suffer mutation
    
    if(mutationProb <= 0.8)
       k = randperm(N,ngenes_mutation); %choose genes positions
       for i=1:2 % mutation for each child
         aux = children(i,k(1));
         children(i,k(1)) = children(i,k(2));
         children(i,k(2)) = aux;
       end
    end
    
    fchildren = zeros(1,2);
    for i=1:2
      fchildren(i) = fitness_nq(children(i,:));
    end
    [fsorted, index] = sort([f fchildren]);
    
    f = fsorted(1:npop);
    Paux = [P; children];
    P = Paux(index(1:npop),:);
    
    ngen = ngen+1;
    
    fbestplot = [fbestplot min(f)];
    fmeanplot = [fmeanplot mean(f)];
    
    
end 

figure(1)
n = 1:1:length(fbestplot);

marker = 8.0;
plot(n,fbestplot,'*r','MarkerSize',marker);
hold on
plot(n,fmeanplot,'*b','MarkerSize',marker);
legend('Melhor indivíduo', 'Indivíduo médio')
title('Convergência para o melhor indivíduo e o indivíduo médio')
xlabel('Geração')
ylabel('Número de xeques entre pares de rainhas')
ylim([0, max(fmeanplot)+1]);

if min(f)==0
   [~,i] = min(f);
   configuration = P(i,:);
else
   configuration = [];
end
   
end
    