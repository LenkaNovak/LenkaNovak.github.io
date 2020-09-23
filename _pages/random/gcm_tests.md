---
title: "GCM Initial Tests"
excerpt: "for developers and students working on Caltech's HPC cluster"
collection: random
---

## Necessary ingredients:
- micro0
- moisture (RH100 or bulk sfc fluxes)
- exp filter
- TMAR (right now not mass conserving)

## First moist stable run:
- [results](https://docs.google.com/document/d/1GTXBc4BvymI_45CxFD0pRyZ5-jm0mYtTl5hg2bMkZis/edit)

### Parameter sensitivity to:
- 50freeze - not much difference (just qice becomes qliq)
- hyperdiffusion - very small sensitivity
- RH100 v bulkflux
    - RH100 strength ([.pdf](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/comparison_RH100forcing.pdf))
- hs v tapio forcing
- sponge height, ref state value, ref state shape ([.pdf](https://docs.google.com/document/d/1QwTiG4nwyyZ1zVX3-VSDrmlhdI1mxNh5uTBF9GV5Syg/edit))
- exp filter in vertical only
- strength of vertical diff
- TMAR filter ([.pdf](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/comparison-TMAR.pdf))
- maxiter for SA -maxiter([.pdf](https://github.com/LenkaNovak/LenkaNovak.github.io/blob/master/files/comparison-maxiter.pdf)): 3 to 10, no difference (FT repeatable)
