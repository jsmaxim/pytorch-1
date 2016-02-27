#!/bin/bash

# - torch is expected to be already activated, ie run:
#    source ~/torch/install/bin/torch_activate.sh
#    ... or similar
# - torch is expected to be at $HOME/torch

# export PYTHONPATH=.:src

source ~/torch/install/bin/torch-activate

if [[ ! -f data/mnist/t10k-labels-idx1-ubyte.gz ]]; then {
  echo downloading mnist data...
  mkdir -p data/mnist
  (cd data/mnist
    wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz -O train-images-idx3-ubyte.gz
    wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz -O train-labels-idx1-ubyte.gz
    wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz -O t10k-images-idx3-ubyte.gz
    wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz -O t10k-labels-idx1-ubyte.gz
  )  
   echo ...downloaded mnist data
} fi

if [[ $(uname) == Linux ]]; then {
  if [[ x$RUNGDB == x ]]; then {
      stdbuf --output=L py.test -sv test/test* $* | grep --line-buffered -v 'seconds =============' | tee test_outputs/tests_output.txt
  } else {
      rungdb.sh python $(which py.test) test/test* $*
  } fi
} else {
   py.test -sv test/test*
} fi

