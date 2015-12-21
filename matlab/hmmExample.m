% taken from here: http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm_usage.html
%% 
% The script dhmm_em_demo.m gives an example of how to learn an HMM with 
% discrete outputs. Let there be Q=2 states and O=3 output symbols. We create
% random stochastic matrices as follows.
O = 3;
Q = 2;
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
obsmat0 = mk_stochastic(rand(Q,O));  
% Now we sample nex=20 sequences of length T=10 each from this model, to use
% as training data.
T=10;
nex=20;
data = dhmm_sample(prior0, transmat0, obsmat0, nex, T);  
%Here data is 20x10. Now we make a random guess as to what the parameters are,
prior1 = normalise(rand(Q,1));
transmat1 = mk_stochastic(rand(Q,Q));
obsmat1 = mk_stochastic(rand(Q,O));
%and improve our guess using 5 iterations of EM...
[LL, prior2, transmat2, obsmat2] = dhmm_em(data, prior1, transmat1, obsmat1,...
    'max_iter', 5);
% LL(t) is the log-likelihood after iteration t, so we can plot the
% learning curve.

%% Sequence classification

% To evaluate the log-likelihood of a trained model given test data, proceed as follows:
loglik = dhmm_logprob(data, prior2, transmat2, obsmat2)
% Note: the discrete alphabet is assumed to be {1, 2, ..., O}, where O = size(obsmat, 2). Hence data cannot contain any 0s.
% To classify a sequence into one of k classes, train up k HMMs, one per class, and then compute the log-likelihood that each model gives to the test sequence; if the i'th model is the most likely, then declare the class of the sequence to be class i.

% Computing the most probable sequence (Viterbi)

%First you need to evaluate B(i,t) = P(y_t | Q_t=i) for all t,i:
B = multinomial_prob(data, obsmat);
% Then you can use
[path] = viterbi_path(prior, transmat, B)