#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(strftime);
use HTML::FormatMarkdown;

my $verbose = 1;

# This script is just meant to be a partial conversion from the HTML output
# generated from the docbook files to be copied to the documentation project
# hosted at open-dcs.github.io. It isn't complete and requires a couple of post
# run tweeks to finish the formatting.
#
# I'm not going to do any error checking so don't do anything dumb and expect
# it to work.

my ($in) = @ARGV;
my $cmd = $in;
$cmd =~ s/.*\/(.+)\.html/$1/;
#$cmd =~ s/-/ /;

debug ("Create markdown for command: " . $cmd . "\n\n");

my $text = HTML::FormatMarkdown->format_file(
  $in,
  leftmargin => 0,
  rightmargin => 100
);

my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;

(my $head = qq{---
  layout: post
  title: Sample Title
  author: Author Name <author\@example.com>
  date: $date -0700
  description: Sample description.
  categories: opendcs manpages
  ---

}) =~ s/^ {2}//mg;

my $man = prep($text);

my @sec_name = section("Name", $man);
@sec_name = post_name(\@sec_name);
@sec_name = tidy(\@sec_name);

my @sec_synop = section("Synopsis", $man);
@sec_synop = post_synopsis(\@sec_synop);
@sec_synop = tidy(\@sec_synop);

my @sec_desc = section("Description", $man);
@sec_desc = post_description(\@sec_desc);
@sec_desc = tidy(\@sec_desc);

my @sec_opts = section("Options", $man);
@sec_opts = post_options(\@sec_opts);
@sec_opts = tidy(\@sec_opts);

my @sec_ex = section("Examples", $man);
@sec_ex = post_examples(\@sec_ex, $cmd);
@sec_ex = tidy(\@sec_ex);

my @sec_also = section("See Also", $man);
@sec_also = post_seealso(\@sec_also);
@sec_also = tidy(\@sec_also);

my @sec_notes = section("Notes", $man);
@sec_notes = post_notes(\@sec_notes);
@sec_notes = tidy(\@sec_notes);

print $head;

foreach my $line (@sec_name)  { print $line; }
foreach my $line (@sec_synop) { print $line; }
foreach my $line (@sec_desc)  { print $line; }
foreach my $line (@sec_opts)  { print $line; }
foreach my $line (@sec_ex)    { print $line; }
foreach my $line (@sec_also)  { print $line; }
foreach my $line (@sec_notes) { print $line; }

sub debug {
  my $str = shift;
  print $str if $verbose;
}

sub prep {
  my $text = shift;
  my @lines = split /\n/, $text;

  $text = "";
  my $open = undef;

  foreach my $line (@lines) {
    unless ($line =~ /^\s*$/) {
      # cleanup substitutions
      $line =~ s/[^[:ascii:]]//g;
      $line =~ s/^\s+//;
      $line =~ s/\s+$//;
      $line =~ s/^>\s*//;
      $line =~ s/(#+.*)\s#+/\n$1\n/;

      if ($line =~ /^\[/) {
        $open = 1;
        $text = $text . $line;
      } else {
        # don't print newlines while waiting for a [] to complete
        if ($open) {
          $text = $text . $line;
          if ($line =~ /\]/) {
            unless ($line =~ /\[/) {
              $text = $text . "\n";
              $open = undef;
            }
          }
        } else {
          $text = $text . $line . "\n";
        }
      }
    }
  }

  return $text;
}

# XXX I'm not sure this helps anything.
sub tidy {
  my ($ref) = @_;
  my @sec = @{$ref};
  shift(@sec) if $sec[0] =~ /^\R$/g;
  push(@sec, "\n") unless $sec[-1] =~ /^\R$/g;
  @sec;
}

sub section {
  my $title = shift;
  my $text = shift;
  my @lines = split /\n/, $text;
  my $found = undef;
  my @sec;

  foreach my $line (@lines) {
    if ($line =~ /^#+\s$title/) {
      push @sec, $line . "\n";
      $found = 1;
    } elsif ($found) {
      if ($line =~ /^#+.*/) {
        $found = undef;
      } else {
        push @sec, $line . "\n";
      }
    }
  }

  @sec;
}

sub post_name {
  my @lines = @{$_[0]};
  my @name;

  foreach my $line (@lines) {
    $line =~ s/^(.+)\s\s(.*)/`$1` - $2/;
    push @name, $line;
  }

  # Because I have Jekyll setup to split the output of the post.
  $name[-2] = $name[-2] . "<!--break-->\n";

  @name;
}

sub post_synopsis {
  my @lines = @{$_[0]};
  my @synopsis;
  my $found = undef;

  foreach my $line (@lines) {
    if ($line =~ /^`$/) {
      $line =~ s/\R//g;
      if ($found) {
        $line = $line . " ";
        $found = undef;
      } else {
        $found = 1;
      }
    } else {
      if ($found) {
        $line =~ s/\R//g;
      }
    }
    push @synopsis, $line;
  }

  @synopsis;
}

sub post_description {
  my @lines = @{$_[0]};
  my @description;
  my $found = undef;

  foreach my $line (@lines) {
    if ($line =~ /^\*$/) {
      $line =~ s/\R//g;
      if ($found) {
        $line = $line . " ";
        $found = undef;
      } else {
        $found = 1;
      }
    } else {
      if ($found) {
        $line =~ s/\R//g;
      }
    }
    push @description, $line;
  }

  @description;
}

sub post_options {
  my @lines = @{$_[0]};
  my @options;

  foreach my $line (@lines) {
    push @options, $line;
  }

  @options;
}

sub post_examples {
  my @lines = @{$_[0]};
  my $cmd = $_[1];
  my @examples;

  # XXX This isn't perfect, if the example description contains the command
  #     name it won't differentiate that from the actual command example.
  foreach my $line (@lines) {
    $line =~ s/^(\*\*Example.*\*\*)$/$1\n/;
    $line =~ s/($cmd.*)\R/\n`$1`\n\n/;
    push @examples, $line;
  }

  @examples;
}

sub post_seealso {
  my @lines = @{$_[0]};
  my @seealso;

  foreach my $line (@lines) {
    if ($line =~ /^\[.*\)$/) {
      $line =~ s/\R//g;
      $line = $line . " ";
    }
    push @seealso, $line;
  }

  push @seealso, "\n";

  @seealso;
}

sub post_notes {
  my @lines = @{$_[0]};
  my @notes;
  my $space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

  foreach my $line (@lines) {
    if ($line =~ /^\[.*\)$/) {
      push @notes, "\n" . $space . $line . "\n";
    } else {
      push @notes, $line;
    }
  }

  @notes;
}
