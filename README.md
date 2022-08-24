# ARTIFICIAL_NEUROVASCULAR_NETWORK_ANVN
This is the codebase for ANVN
The codes are organized as per the following training regimes followed in the work (https://www.nature.com/articles/s41598-021-92661-7)
1. Untrained - where the vasculature is not trained. The MLP is connected to a vascular tree which has equal energy at each nodes
2. Sequential - where the vasculature is trained sequential to the MLP based on the trained bias values
3. Simultaneous - where the vasculature and the MLP are trained simultaneously. Here we have different variations to the code.
    3.1 Without reservoir - where the ANVN takes up all the energy given to it.
    3.2 With reservoir- where the ANVN has a reservoir connection which enables it to return any excess energy
      3.2.1 Regularization - where the gradient descent is modified to include L1 and L2 regularizations, mentioned in the supplementary material of the paper
      3.2.2 Transfer Learning - where the ANVN trained on MNIST data set is retrained on an EMNIST dataset
