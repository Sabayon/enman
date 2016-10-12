#!/usr/bin/perl

my @PO = <po/*.po>;

foreach my $po (@PO){
  $po=~/po\/(.*)\.po/;
  my $lang=$1;
  if( length($lang) <=3 ){
    my $utf8 = "po/${lang}_".uc($lang).".UTF-8.po";
    my $noutf8 = "po/${lang}_".uc($lang).".po";
    system("cp -rfv $po $utf8");
    system("cp -rfv $po $noutf8");
  }
}
