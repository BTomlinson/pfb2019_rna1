library(readr)
transcript_count_matrix <- data.frame(read_csv("Downloads/transcript_count_matrix.csv"))


rownames(transcript_count_matrix) = transcript_count_matrix$transcript_id
transcript_count_matrix$transcript_id = NULL

count_matrix = as.matrix(transcript_count_matrix)

pheno_data = read.csv("Downloads/phenotypedata.txt", row.names = 1)



dds <- DESeqDataSetFromMatrix(countData = count_matrix, colData = pheno_data, design = ~ light)

dds <- DESeq(dds)
res <- results(dds)
resOrdered <- res[order(res$log2FoldChange),] ##order by log fold change
restableordered <- data.frame(resOrdered)
restableordered <- na.omit(restableordered)
headrestableordered <- head(restableordered)
tailrestableordered <- tail(restableordered)
totaltable <- rbind(headrestableordered,tailrestableordered)
totaltablefolds <- totaltable[c(2)]

jpeg('foldchangegraph.jpg')
barplot(as.matrix(totaltablefolds),
        main = "Most Extreme Changes by Fold Change",
        ylab = "Fold Change",
        col = "light green",
        ylim =  c(-40,40),
        beside = TRUE)
dev.off()

View(totaltablefolds)
