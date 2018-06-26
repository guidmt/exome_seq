export LC_ALL=C

number_patients=$(pigz -dc /home/guidantonio/Scrivania/Exomes/ATVB_new/ATVB_WES.SNP.INDEL.pass.geno.chr7.vcf.bgz|sed -n '208p'|tr "\t" "\n"|tail -n+10|wc -l)

my_iteration=$(seq 10 $number_patients)
        
	#external loop for the patient
	for pts in $my_iteration
	
	do
	#get the id of the current patient

	touch  ../QC/freq_miss/$pts."freq_miss.txt"
		
		for i in $(seq 1 22) X

		do

		echo $i
	#get the patient
		current_patient=$(pigz -dc ../ATVB_new/ATVB_WES.SNP.INDEL.pass.geno.chr$i.vcf.gz|sed -n 208p |cut -f $pts)

	#internal loop for the chromosomes
	number_variant_for_sample=$(pigz -dc ../ATVB_new/ATVB_WES.SNP.INDEL.pass.geno.chr$i.vcf.gz|grep -v "#"|cut -f $pts|cut -d ":" -f 1|parallel --pipe --block 100M -L 50000 -P 6 grep -F -v "./."|wc -l) # -F fixed string -v invert selection

	number_miss_for_sample=$(pigz -dc ../ATVB_new/ATVB_WES.SNP.INDEL.pass.geno.chr$i.vcf.gz|cut -f $pts|cut -d ":" -f 1|parallel --pipe --block 100M -L 50000 -P 6 grep -F "./."|wc -l)

	        echo	$current_patient	$i	$number_variant_for_sample	$number_miss_for_sample >> ../QC/freq_miss/$pts."freq_miss.txt"
		
		done #close internal loop for chromosome

	done #close external loop for the patient
