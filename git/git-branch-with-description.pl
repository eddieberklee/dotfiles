#!/usr/bin/perl

sub clean {
  map { s/^[\s\*]*\s// } @_;
  map { s/\s*$// } @_;
  return @_;
}

sub descr {
  $_ = `git config branch.@_.description`;
  s/\s*$//;
  return $_;
};
sub indent {
  $_ = shift;
  s/^/      /mg;
  return $_;
};

my @branches = clean `git branch --color=never --list`;
my %merged = map { $_ => 1 } clean `git branch --color=never --merged`;

$i = 0;
for my $branch (@branches) {
  my $asis = `git branch --list --color=always $branch`;
  $asis =~ s/\s*$//;
  if ($i++ != 0) {
    print "\n";
  }
  print "  $asis";
  # print " \033[33m(merged)\033[0m" if ($merged{$branch} and $branch ne "master");
  print indent descr $branch;
}
