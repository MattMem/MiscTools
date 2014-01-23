use Data::Dumper;

my $file = $ARGV[0];
my $protein_length = $ARGV[1];
my %protein;
#make hash of all amino acids
my @amino_acids=('G','P','A','V','L','I','M','C','F','Y','W','H','K','R','Q','N','E','D','S','T');
#print "[";
foreach my $amino_acid(@amino_acids){
	for(my $i=0; $i<=$protein_length; $i++){
		$protein{$amino_acid}{$i}{'count'}=0;
#		print "$i,";
	}
	#print "\'$amino_acid\',";
}
#print "]\n";
#die;

open FILE, $file or die;

while(<FILE>){
	chomp($_);
	my ($position,$cds_mutation,$aa_mutation,$id,$count,$type_raw) = split(/\,/,$_);
	my ($start,$type) = split(/ - /,$type_raw);
	if($type eq "Missense" && $position ne "0"){ 
		my $aa = $aa_mutation;
		$aa =~ s/p\.//;
		$aa =~ s/^.//;
		$aa =~ s/[0-9]//g;
		#print $aa ."\n";
		$protein{$aa}{$position}{'count'} = $count;
	}

}

#print Dumper(%protein);

for my $aa (keys %protein){

    print "{\n\"key\" : \"$aa\" ,\n";
    print "\"bar\": true,\n";
    print "\"values\": [";
	for my $position (sort {$a <=> $b} keys %{$protein{$aa}}){
		my $count= $protein{$aa}{$position}{'count'};
		print "[$position,$count],";
	}
	print "]\n},";
}
