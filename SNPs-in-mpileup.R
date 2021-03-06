
SNPs_in_mpileup <- function(SNPs,mpu){
  matches <- inner_join(mpu, SNPs, by = c("Value" = "reference_position")) %>% 
    filter(A.a + G.g + C.c + T.t > 0) %>% 
    select(Value, reference_base, alternate_base, A.a, G.g, C.c, T.t)
  if (nrow(matches) > 0){
    mh <- lapply(1:nrow(matches), function(x) which(matches[x,4:7] > 0))
    SNP_bases <- chartr("1234","AGCT",mh)
    matches <- cbind(matches,SNP_bases)
    match_rows <- matches[which(sapply(1:nrow(matches), function(x) as.character(matches[x,3]) %in% strsplit(as.character(matches[x,8]), "")[[1]])),]
    if (nrow(match_rows) > 0){
      return(c(as.integer(nrow(mpu)),median(mpu$Coverage),as.integer(nrow(match_rows)),sum(match_rows[4:7])/nrow(match_rows)))
    }
    else {
      return(c(as.integer(nrow(mpu)),median(mpu$Coverage),0,0))
    }  
  }
  else {
    return(c(as.integer(nrow(mpu)),median(mpu$Coverage),0,0))
  }
}
