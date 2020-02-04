## Test environments

* local ubuntu 16.04, R 3.6.1
* ubuntu 14.04 (on travis-ci), R3.6.2 
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes


## Reverse dependencies

### metacoder

I also maintain `metacoder`. The current CRAN version will have test errors with this version of `taxa`, but I will be submitting an update to `metacoder` that is compatible with this version of `taxa` and builds without errors shortly after submitting this version of `taxa`.

### taxlist

`taxa` is in the suggests and no code from `taxa` is actually used.