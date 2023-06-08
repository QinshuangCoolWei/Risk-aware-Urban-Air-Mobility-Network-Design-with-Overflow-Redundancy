function solution = TP_compute_ori(E,Delta_1,Delta_2,C_V,C_E,M)
% parameters
N_V = size(E,1);
N_E = size(E,2);
N_J = size(Delta_1,2);

one_V = ones(N_V,1);
one_E = ones(N_E,1);
one_J = ones(N_J,1);

% variables

X = sdpvar(N_E,N_J,'full');
D1 = sdpvar(N_V,N_J,'full');
D2 = sdpvar(N_V,N_J,'full');

% 
% z = intvar(N,N,'full');


% constraints that do not need a loop
constraints = [ E*X==D1+D2,...
    X(:,:)>=0,...
    X*one_J <= C_E,...
    abs(E)*X*one_J <= C_V,...
    D1'*one_V == -D2'*one_V,...
    D1 <= Delta_1*M,...
    -D2 <= -Delta_2*M,...
    D1 >=0,...
    D2 <=0
];




obj=sum(-one_J'*D1'*one_V);
options = sdpsettings('verbose',0,'solver','LINPROG');

sol = optimize(constraints,obj,options);

% Analyze error flags
if sol.problem == 0
 % Extract and display value
 solution.X = value(X);
 solution.TP = value(one_J'*D1'*one_V);
 solution.n = sum(value(D1),1);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem);
end
end
