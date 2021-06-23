
## R CMD check results

### Local computer: Pop!_OS 20.04 LTS, R version 4.0.3

0 errors | 0 warnings | 0 notes

### Travis CI: Ubuntu 18.04.5 LTS (devel and release)

0 errors | 0 warnings | 0 notes

### win-builder (devel and release)

0 errors | 0 warnings | 1 notes



## Reverse dependencies

### metacoder

I also maintain `metacoder`. The current CRAN version will have test errors with this version of `taxa`, but I will be submitting an update to `metacoder` that is compatible with this version of `taxa` and builds without errors shortly after submitting this version of `taxa`.

### taxlist

`taxa` is in the suggests and no code from `taxa` is actually used.