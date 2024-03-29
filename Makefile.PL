
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.020.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker ;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Pluggable POE event emitter role for cows",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "MooX-Role-POE-Emitter",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "MooX::Role::POE::Emitter",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Method::Modifiers" => 0,
    "List::Objects::Types" => 1,
    "List::Objects::WithUtils" => "2.007",
    "Moo" => 1,
    "Moo::Role" => 0,
    "MooX::Role::Pluggable" => "0.12",
    "MooX::late" => "0.014",
    "POE" => 0,
    "Scalar::Util" => 0,
    "Try::Tiny" => 0,
    "Type::Tiny" => "0.022",
    "Types::Standard" => 0,
    "strictures" => 1
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "List::Util" => 0,
    "Scalar::Util" => 0,
    "Test::Exception" => 0,
    "Test::More" => "0.88",
    "version" => "0.77"
  },
  "VERSION" => "1.001001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Class::Method::Modifiers" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "List::Objects::Types" => 1,
  "List::Objects::WithUtils" => "2.007",
  "List::Util" => 0,
  "Moo" => 1,
  "Moo::Role" => 0,
  "MooX::Role::Pluggable" => "0.12",
  "MooX::late" => "0.014",
  "POE" => 0,
  "Scalar::Util" => 0,
  "Test::Exception" => 0,
  "Test::More" => "0.88",
  "Try::Tiny" => 0,
  "Type::Tiny" => "0.022",
  "Types::Standard" => 0,
  "strictures" => 1,
  "version" => "0.77"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



