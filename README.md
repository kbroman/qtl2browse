### R/qtl2browse

[![Build Status](https://travis-ci.org/rqtl/qtl2browse.svg?branch=master)](https://travis-ci.org/rqtl/qtl2browse)

[Karl Broman](https://kbroman.org) and [Christian Fischer](https://github.com/chfi)

[R/qtl2browse](https://github.com/kbroman/qtl2browse) is an R package
to facilitate the use of the [Genetics Genome
Browser](https://github.com/chfi/purescript-genetics-browser) with
[R/qtl2](https://kbroman.org/qtl2).

---

## Installation

Iinstall the package dependencies from [CRAN](https://cran.r-project.org).

```r
install.packages(c("qtl2", "devtools"))
```

Install [R/qtl2browse](https://github.com/rqtl/qtl2browse) from GitHub
using [devtools](https://devtools.r-lib.org).

```r
install_github("rqtl/qtl2browse")
```


---

## Usage

At present, there is a single function, `browse()`, which takes
genome scan output from `qtl2::scan1()`, writes it to a JSON file, and
opens it in a web browser.

Here's an example using data from [Recla et al.
(2014)](https://www.ncbi.nlm.nih.gov/pubmed/24700285) and [Logan et
al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23433259). The
calculations are a bit slow.

```r
library(qtl2)
recla <- read_cross2(paste0("https://raw.githubusercontent.com/rqtl/",
                            "qtl2data/master/DO_Recla/recla.zip"))

gmap <- insert_pseudomarkers(recla$gmap, step=0.2, stepwidth="max")
pmap <- interp_map(gmap, recla$gmap, recla$pmap)
pr <- calc_genoprob(recla, gmap, error_prob=0.002,
                    map_function="c-f", cores=0)
apr <- genoprob_to_alleleprob(pr)

k <- calc_kinship(apr, "loco", cores=0)

out <- scan1(apr, recla$pheno[,"HP_latency"], k, cores=0)

library(qtl2browse)
browse(out, pmap)
```

---

## License

[R/qtl2browse](https://github.com/kbroman/qtl2browse) is released
under the [MIT license](LICENSE.md), as is the [Genetics Genome
Browser](https://github.com/chfi/purescript-genetics-browser).
