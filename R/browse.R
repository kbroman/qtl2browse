#' Browse QTL results
#'
#' Use the genetics genome browser to browse QTL mapping results
#'
#' @param scan1output Genome scan output, as from [qtl2::scan1()]
#' @param map Corresponding physical map, as a list of chromosomes
#'     that are each a vector of marker positions.
#' @param dir Optional directory to contain the results. If not
#'     provided, a temporary directory is created.
#'
#' @return File location (hidden).
#'
#' @export
#' @importFrom utils unzip
#'
#' @examples
#' # run qtl2
#' # browse results
browse <-
    function(scan1output, map, dir=NULL)
{
    # make directory
    if(is.null(dir)) {
        while(dir.exists(dir <-
              file.path(tempdir(),
                        paste0("qtl2_",
                               paste0(sample(letters, 6, repl=TRUE),
                                      collapse=""))))) {}
    }
    if(!dir.exists(dir)) {
        dir.create(dir)
    }

    unzip(system.file("extdata", "ggb.zip", package="qtl2browse"),
          exdir=dir, overwrite=TRUE)

    # write qtl2 data
    outfile <- file.path(dir, "data", "gwas.json")

    browseURL(paste0("file://", file.path(dir, "index.html")))
}
