
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Pluggable POE event emitter role for cows",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {
    "Test::Exception" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MooX-Role-POE-Emitter",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "MooX::Role::POE::Emitter",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Moo" => "1.000007",
    "MooX::Role::Pluggable" => "0.11",
    "MooX::Types::MooseLike" => "0.15",
    "POE" => 0,
    "Scalar::Util" => 0,
    "Try::Tiny" => 0,
    "namespace::clean" => "0.23",
    "strictures" => 1
  },
  "VERSION" => "0.120001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



