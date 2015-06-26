#/usr/bin/perl

#Written by @flyinpoptartcat 2015

##
## This software and all of it's components part or whole is placed under
## public domain. http://unlicense.org/
## 



#### SETTINGS - feel free to change these
  my $disableUnderscoreReplacement = 0; #set to 1 if you don't want the underscores. 0 if you do
  my $termDelinator = "--";
  my $dateSecttionDeliniator = "-";
  my $itteratorGrowthInterval = 1;
  my $defaultFileExt = ".mp4";
  my $defaultTempName = "format";
  my $showName = "This Week In Ladders";
####







my $space = " ";

print "Episode Name: ";
my $EpisodeName = <STDIN>;
chomp $EpisodeName;


$defaultTempName = $defaultTempName . InsureExtIsCorrect($defaultFileExt);

if(!-e $defaultTempName){
	print STDERR "ERROR!!!! $defaultTempName could not be found!\n";
	sleep 2;
	exit;
}


my $newhotness = formatName($showName, $EpisodeName, $defaultFileExt);

rename($defaultTempName, $newhotness);

writerItterator(readItterator());

print "done $newhotness\n";
sleep 1;





sub formatName
{
	my $bestowedNameOriginal = shift; #just in case we won't fuck with this
	my $bestowedEpNameOriginal = shift; #this neither
	
	if(!$disableUnderscoreReplacement){
		$bestowedName = safeWhiteSpace($bestowedNameOriginal);
		$bestowedEpName = safeWhiteSpace($bestowedEpNameOriginal);
	} else {
		$bestowedName = $bestowedNameOriginal;
		$bestowedEpName = $bestowedEpNameOriginal;
	}
	
	my $fileExt = shift;
	$fileExt = InsureExtIsCorrect($fileExt);
	
	my $newIterVal = readItterator() + $itteratorGrowthInterval;
	
	my @terms = (
	  $bestowedName,
	  $bestowedEpName,
	  $newIterVal,
	  date(),
	);
	
	my $finishedNewName = BuildFormattedString( \@terms, $termDelinator ) . $fileExt;
	
	
	return $finishedNewName;
}

sub InsureExtIsCorrect
{
	my $ext = shift;
	
	if(not $ext =~ m"^\."){
		$ext = "." . $ext;
	}
	
	return $ext;
}

sub readItterator
{
	my $ITER;
	open($ITER, "+<", "./iter.txt"); #open for read
	
	  my $data = readline *$ITER;
	  chomp $data; #just in case
	
	close($ITER);
	
	return $data;
}


sub writerItterator
{
	my $current = shift;
	my $newIter = $current + $itteratorGrowthInterval;
	
	my $wITER;
	open($wITER, ">", "./iter.txt");
	
	  print $wITER $newIter;
	
	close($wITER);
	
	return;
}


sub safeWhiteSpace
{
	my $text2convert = shift;
	
	$text2convert =~ s/(\t|\x20)/_/gx;
	
	return $text2convert;
}


sub date
{
	
	my @dateSections = 
	  split( 
	  	m"$space",
	  	(scalar localtime())
	  );
	
	
	my @wantedDateSections = ( $dateSections[1], $dateSections[2], $dateSections[4] );
	
	return BuildFormattedString( \@wantedDateSections, $dateSecttionDeliniator );
}


sub BuildFormattedString
{
	my $fArray = shift;
	@fArray = @$fArray;
	my $delin = shift;
	
	my $formatted = ""; #null
	
	foreach my $sect (@fArray){
		$formatted = $formatted . $sect . $delin;
	}
	
	#buzz trailing $delin
	my $delinLen = length($delin);
	my $formattedLen = length($formatted);
	my $FinalStringLen = ($formattedLen - $delinLen);
	
	$formatted = substr $formatted, 0, $FinalStringLen;
	
	return $formatted;
}
