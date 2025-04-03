# modify mro/atac/stages/processing/cell_calling/remove_low_targeting_barcodes/__init__.py 
# DISTANCE = 1000

bin="/bin/cellranger-arc-2.0.2"
ref="/reference/Rice/MSU7"
samples="leaf_1 leaf_2 Root_1 Root_2 Bud_2 Flag_1 Flag_2 Seed_31 Seed_32 SAM_1 SAM_2 Bud_21 Bud_22" 
for i in $samples;  do
    echo "fastqs,sample,library_type
    /rawdata/${i},${i}_RNA,Gene Expression
    /rawdata/${i},${i}_atac,Chromatin Accessibility" > ${i}.csv
   $bin/cellranger-arc count --id=${i} \
      --reference=$ref \
      --libraries=${i}.csv \
      --localcores=50
   cellbender  remove-background --input ${i}/outs/raw_feature_bc_matrix.h5 --output ${i}/outs/cellbender_output_file.h5
   ptrepack --complevel 5 ${i}/outs/cellbender_output_file_filtered.h5:/matrix ${i}/outs/tiny_output_filtered_seurat.h5:/matrix  
done
