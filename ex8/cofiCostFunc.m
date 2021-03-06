function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
Pred_Rates =  X*Theta';        % size(Pred_Rates)=num_movies x num_users

M_rate_err =  Y - Pred_Rates;   % size(M_rate_err)=num_movies x num_users

Error_fact = M_rate_err.*R;    % size(Error_fact)=num_movies x num_users
                                % Used to mask only those elements with ratings

% Calculate regularization terms
Regcost_theta = lambda/2*sum(sum(Theta.^2));
Regcost_X = lambda/2*sum(sum(X.^2));
Reggrad_X = lambda*X;
Reggrad_Theta = lambda*Theta;

% Calculate the cost
J = 1/2*sum(sum((Error_fact).^2)) + Regcost_theta + Regcost_X; 

% Calculate the gradients

X_grad = -Error_fact*Theta + Reggrad_X; % size(X_grad) = num_movies x num_features

Theta_grad = -Error_fact'*X + Reggrad_Theta; % size(Theta_grad) = num_users x num_features


% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
