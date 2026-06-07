### R/qtl2browse

[![R-CMD-check](https://github.com/rqtl/qtl2browse/workflows/R-CMD-check/badge.svg)](https://github.com/rqtl/qtl2browse/actions)
[![r-universe badge](https://rqtl.r-universe.dev/qtl2bioc/badges/version)](https://rqtl.r-universe.dev/qtl2bioc)

[Karl Broman](https://kbroman.org) and [Christian Fischer](https://github.com/chfi)

[R/qtl2browse](https://github.com/rqtl/qtl2browse) is an R package
to facilitate the use of the [Genetics Genome
Browser](https://github.com/chfi/purescript-genetics-browser) with
[R/qtl2](https://kbroman.org/qtl2).

---

## Installation

Install R/qtl2browse from
[r-universe](https://rqtl.r-universe.dev/qtl2browse):

```r
install.packages("qtl2browse", repos=c("https://rqtl.r-universe.dev",
                                       "https://cloud.r-project.org"))
```

Alternatively, install the [remotes package](https://remotes.r-lib.org)
and use `remotes::install_github()` to install R/qtl2browse from its
[Github repository](https://github.com/rqtl/qtl2browse).

```r
install.packages("remotes")
library(remotes)
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

[R/qtl2browse](https://github.com/rqtl/qtl2browse) is released
under the [MIT license](LICENSE.md), as is the [Genetics Genome
Browser](https://github.com/chfi/purescript-genetics-browser).
