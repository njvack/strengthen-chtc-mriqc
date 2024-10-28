#!/bin/bash

# rm out/* log/* err/*

for d in out log err; do
  mv $d/*txt $d/bak
done
