#' Browse QTL results
#'
#' Use the genetics genome browser to browse QTL mapping results
#'
#' @param scan1output Genome scan output, as from [qtl2::scan1()]
#' @param map Corresponding physical map, as a list of chromosomes
#'     that are each a vector of marker positions.
#' @param lodcolumn LOD score column to plot (a numeric index, or a
#' character string for a column name). Only one value allowed.
#' @param dir Optional directory to contain the results. If not
#'     provided, a temporary directory is created.
#'
#' @return File location (hidden).
#'
#' @export
#' @importFrom utils unzip
#' @importFrom qtl2 align_scan1_map
#' @importFrom jsonlite toJSON
#'
#' @examples
#' \donttest{
#' library(qtl2)
#' recla <- read_cross2(paste0("https://raw.githubusercontent.com/rqtl/",
#'                             "qtl2data/master/DO_Recla/recla.zip"))
#'
#' gmap <- insert_pseudomarkers(recla$gmap, step=0.2, stepwidth="max")
#' pmap <- interp_map(gmap, recla$gmap, recla$pmap)
#' pr <- calc_genoprob(recla, gmap, error_prob=0.002,
#'                     map_function="c-f", cores=0)
#' apr <- genoprob_to_alleleprob(pr)
#'
#' k <- calc_kinship(apr, "loco", cores=0)
#'
#' out <- scan1(apr, recla$pheno[,"HP_latency"], k, cores=0)
#'
#' library(qtl2browse)
#' browse(out, pmap)
#' }
browse <-
    function(scan1output, map, lodcolumn=1, dir=NULL)
{
    if(is.null(map)) stop("map is NULL")
    if(!is.list(map)) map <- list(" "=map) # if a vector, treat it as a list with no names

    # align scan1 output and map
    tmp <- qtl2::align_scan1_map(scan1output, map)
    scan1output <- tmp$scan1
    map <- tmp$map

    # make directory
    if(is.null(dir)) {
        # create a randomized directory name
        while(dir.exists(dir <- file.path(tempdir(),
             paste0("qtl2_", paste0(sample(letters, 6, repl=TRUE), collapse=""))))) {}
    }
    if(!dir.exists(dir)) {
        dir.create(dir)
    }

    unzip(system.file("extdata", "ggb.zip", package="qtl2browse"),
          exdir=dir, overwrite=TRUE)

    # grab lod scores
    if(length(lodcolumn)==0) stop("lodcolumn has length 0")
    if(length(lodcolumn) > 1) { # If length > 1, take first value
        warning("lodcolumn should have length 1; only first element used.")
        lodcolumn <- lodcolumn[1]
    }
    if(is.character(lodcolumn)) { # turn column name into integer
        tmp <- match(lodcolumn, colnames(scan1output))
        if(is.na(tmp)) stop('lodcolumn "', lodcolumn, '" not found')
        lodcolumn <- tmp
    }
    if(lodcolumn < 1 || lodcolumn > ncol(scan1output))
        stop("lodcolumn [", lodcolumn, "] out of range (should be in 1, ..., ",
             ncol(scan1output), ")")
    lod <- unclass(scan1output)[,lodcolumn]

    # combine qtl2 data into data frame
    result <- data.frame(chr=rep(names(map), vapply(map, length, 1)),
                         ps=unlist(map)*1e6,
                         rs=unlist(lapply(map, names)),
                         p_wald = 10^(-lod),
                         LOD = lod,
                         stringsAsFactors=FALSE)
    rownames(result) <- NULL

    # write qtl2 data
    outfile <- file.path(dir, "data", "gwas.json")
    cat(jsonlite::toJSON(result), file=outfile)

    browseURL(paste0("file://", file.path(dir, "index.html")))

    invisible(dir)
}
