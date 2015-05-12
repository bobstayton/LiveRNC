#!/usr/bin/perl 
#
#  livernc.pl - generate an html version of a RNC
#
# $Id: livernc.pl,v 1.21 2006/11/10 09:29:31 bobs Exp $
#
# Copyright (c) 2000-2005 Robert Stayton
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the ``Software''), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# Except as contained in this notice, the names of individuals
# credited with contribution to this software shall not be used in
# advertising or otherwise to promote the sale, use or other
# dealings in this Software without prior written authorization
# from the individuals in question.
# 
# Any program derived from this Software that is publically
# distributed will be identified with a different name and the
# version strings in any derived Software will be changed so that
# no possibility of confusion between the derived package and this
# Software will exist.
# 
# Warranty
# --------
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL ROBERT STAYTON OR ANY OTHER
# CONTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# Contacting the Author
# ---------------------
# This program is maintained by Robert Stayton <bobs@sagehill.net>.
# It is available through http://www.sagehill.net/livernc
# 
#
# POD documentation:

=head1 NAME

livernc.pl - generate an html version of a RNC

=head1 SYNOPSIS

C<livernc.pl> [I<options>] F<rncfile>

Where options are:

B<--catalog> I<catalogs>
   if an SGML (not XML) catalog used by the RNC

B<--outdir> I<outputdirectory>
   default is ./livernc

B<--label> I<xxx>
   add xxx prefix on output filenames

B<--sgml>
   case insensitive element names

B<--title> "I<displayed title>"
   default is main RNC filename

B<--nousage>
   do not generate usage tables

B<--verbose>
   lists details to STDOUT


=head1 DESCRIPTION

This program scans through an XML or SGML Document Type
Definition (RNC) to locate element and parameter entity
definitions. Then it constructs an HTML version of the RNC
with hot links from element references to element
declarations, and from entity references to entity
declarations.  These links let you navigate through
the RNC with ease.  Just point your favorite frames-capable
browser at I<index.html> in the output directory
to see the results.

This program was written for use by maintainers of highly
parameterized RNCs such as Docbook or TEI. It allows you 
to quickly see how a parameter entity or element is defined,
following it through many levels of indirection to
its source. It also helps you find the active definition
when more than one is supplied, as when a customization
layer is used.

The program takes a single command line argument
(after any options) that is the pathname to the
main RNC file. [Windows users: use forward slashes
in all filenames.]  Any additional arguments are ignored.
RNC files referenced by the main RNC as SYSTEM entities
are processed when they are encountered, unless they
are in a marked section whose status is IGNORE.
SGML catalogs are supported to locate system files,
but http URLs are not supported.  XML catalogs are
not supported either.

The program handles marked sections properly. That is,
marked sections whose status is IGNORE are output
as plain text and do not have any live links.
Those whose status is INCLUDE are made live by adding
links. Parameter entities are also handled properly.
That is, if there is more than one declaration 
for the same name, only the first one is active.

Livernc parses a RNC for display purposes, but it does
not validate it. In performing its function, it will flag
many common validation errors. But lack of such errors
does not necessarily mean the RNC is valid.

This program generates an HTML file for each RNC file
used.  The content is displayed within a <PRE> element
to preserve the white space and line breaks of the
original RNC file. The only difference from the original
file is the HTML markup to make it live. In fact,
removing the HTML markup leaves you with an identical
copy of the original. 

It outputs them into a single output directory, even if
the originals are scattered all over the place.
It also constructs lists of elements, entities, and
filenames, and constructs an HTML framework file
to display it all.  

The program generates name usage tables as well.  These are accessed
by clicking on the "+" marker next to an element or
entity name in the left-frame tables of contents.  A usage listing shows 
where the name itself was seen in the RNC.  It is not
a complete list of element usage, however.  To get that,
you have to follow the various parameter entities 
that contain the element name.

The program is not for authoring or editing a RNC. However,
if you have a good HTML editor that preserves lines endings
and whitespace, you can edit the HTML version with it.
When you are done, you can scrub out the HTML markup
using the program B<scrubrnc.pl> included with the
distribution.  That program converts a LiveRNC file
back to a "dead" RNC file without HTML markup.
It is used on each file that makes up the RNC:
        
   scrubrnc.pl file.rnc.html > file.rnc

If your HTML editor doesn't mess with the text,
you should have a working RNC file. Test it by
doing a round trip: use livernc.pl to generate the
HTML version, make some editing changes with your
HTML editor, save it, and then apply scrubrnc.pl to
each generated HTML file. The only differences with the
original RNC files should be the changes you made.


=head1 OPTIONS

The B<--catalog> option lets you specify an SGML catalog
path (such as that used in SGML_CATALOG_PATH) to be used
to resolve PUBLIC identifiers in your RNC.
XML catalogs are not supported at this time.
The option can include more than one path, separated by colons.
Note that the OASIS/Catalog.pm module located below the
location of the livernc.pl program is needed
to process a catalog file.  Your environment
variable SGML_CATALOG_PATH is I<not> automatically
used, because you may be processing in a mixed XML
and SGML environment.  If it is set, you can use:
  --catalog "$SGML_CATALOG_PATH"

The B<--label> option lets you add a prefix to
each of the generated filenames. That allows you to
output several different liveRNCs to the same directory
without filename conflict as long as the labels are
different.

The B<--outdir> option lets you specify an output
directory for the generated HTML files.  If not specified,
the program uses I<./livernc>. That is, it creates
a subdirectory I<livernc> below the current 
working directory.

The B<--sgml> option alters how names are parsed.
Without this option, the program defaults to XML name parsing, which
is always case sensitive.
With this option, B<livernc> treats element names as not
being case sensitive. That is a feature of the reference concrete syntax
for SGML RNCs.
Entity names remain case sensitive, but entity names may include
only characters from the class [-A-Za-z0-9.] and not
underscore or colon as are permitted in XML.
Note that the program does not automatically detect
that a RNC is SGML.
Also, if your SGML declaration deviates from the reference concrete syntax.
you can adjust the variables $SGMLEntname and $SGMLElemName
defined at the top of the program.

The B<--title> option lets you specify a printed title to appear
in the HTML display, such as "DocBook XML 4.1".

The B<--nousage> option turns off the generation of tables showing
where each element and entity name are used in declarations.
The usage tables are useful for tracking down potential effects of
any changes you want to make to a RNC, so it is on by default.

The B<--verbose> option provides many details during the
processing that can be useful for diagnosis of problems.
It also provides tables of element and parameter entity
definitions.  It writes to standard output.

=head1 ACKNOWLEDGEMENTS

Thanks for Norm Walsh for permission to use code fragments
from his B<flatten> program for catalog and RNC parsing.


=cut

#######################################################
# Modules to use
# 
use strict;
use IO::File;
use File::Basename;
use Getopt::Long;
use vars qw($homedir);
# Note: OASIS::Catalog loaded if --catalog option used

# Note: if you get a 'missing @INC' error, add the
# following line (with comment removed),
# and changing /perl/lib to the path where the IO::File module
# is installed:
# 
# BEGIN { push @INC, '/perl/lib' };


#######################################################
# Global variables
# 
my $VERSION = "1.0";
my $outdir = "./livernc";            # default HTML output directory
my @Files = ();                      # Files used by the RNC.
my @ELEMENT = ();                    # List of declared element names.
my %ELEMENT = ();                    # Data records for each element.
my @ElemUsage = ();                  # List of used element names.
my %ElemUsage = ();                  # Data records for element usage.
my @NP = ();                         # List of declared parameter entity names.
my %NP = ();                         # Data records for each NP
my @NPUsage = ();                    # List of used parameter entity names.
my %NPUsage = ();                    # Data records for NP usage.
my @ATTLIST = ();                    # List of declared ATTLIST names.
my %ATTLIST = ();                    # Data records for each ATTLIST.
my $pass;                            # First or second pass through the RNC
my @dirstack = ('.');                # Keeps track of relative paths.
my $catalog;                         # Catalog object.
my $label = '';                      # HTML filename prefix
my $title = '';                      # HTML title string
my $verbose;                         # Verbosity flag.
my $MainRNC;                         # Main RNC filename.
my $ElementDefCount = 0;             # Counts valid elements
my $AttlistDefCount = 0;             # Counts valid ATTLISTs
my $XMLEntName =  '[A-Za-z][-A-Za-z0-9._:]*';
                                     # Defines entity name char pattern
my $XMLElemName = '[A-Za-z][-A-Za-z0-9._:]*';
                                     # Defines element name char pattern
my $ML = 'XML';                      # XML or SGML markup language
my $EntName = $XMLEntName;           # Sets default to XML
my $ElemName = $XMLElemName;         # Sets default to XML

my %ListTitle = (                    # Printed HTML titles
    'FileList', 'RNC Files',
    'ElemList', 'Elements',
    'PatternList', 'Named Patterns',
    'ElemUsage', 'Element Usage Table',
    'PatternUsage', 'Named Pattern Usage Table'
    ) ;
my $usagetables = 1 ;                # Option flag, on by default.
my $UsageSymbol = "+";               # Link text to usage table
my $DOCTYPE = "<!DOCTYPE HTML PUBLIC"
              . " \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
my $NCname = "[A-Za-z_][-A-Za-z0-9._]*";
my $attre = "(attribute\\s+)($NCname)(\\s+\{)";
my $elemre = "(element\\s+)($NCname)(\\s+\{)";
my $npre = "($NCname)(\\s+=)";
my $incre = "(include\\s+\")([^\"]+)(\")";
my $extre = "(external\\s+\")([^\"]+)(\")";
my $comre = "(#.*?\\n)";
my $nsre = "namespace\\s+$NCname\\s+=";
my $quotere = "\".*?\"";
my $schemere = "(\\[)";
my $divre = "(div\\s*\{)";

#######################################################
# Usage statement
# 
my $USAGE = "\nlivernc.pl      version $VERSION
Usage:
   livernc.pl [options] rncfile

Options:
   --catalog catalogfile      [if RNC uses a catalog file]
   --label xxx                [output filename prefix]
   --outdir outputdirectory   [default is ./livernc]
   --title \"displayed title\"  [title in HTML files]
   --nousage                  [do not generate tables of name usage]
   --verbose                  [lots of info to STDOUT]
";


#######################################################
# Process the command line
# 
my %opt = ();
&GetOptions(\%opt,
    'catalog=s@',
    'label:s',
    'outdir:s',
    'title:s',
    'nousage',
    'verbose') || die "$USAGE";

# Catalog option processed below.
$label = $opt{'label'} if $opt{'label'};
$outdir = $opt{'outdir'} if $opt{'outdir'};
$title = $opt{'title'} if $opt{'title'};
$usagetables = 0 if $opt{'nousage'};
$verbose = $opt{'verbose'} if $opt{'verbose'};

$MainRNC = shift @ARGV || die "ERROR: Missing RNC argument.\n$USAGE";

# Set the default title
$title = basename($MainRNC) unless $title;

#######################################################
# Make sure the output dir is writable
# 
if ( -d $outdir ) {
    # It exists, but is it writable?
    -w $outdir
        or die "Cannot write to output directory $outdir.\n";
}
else {
    # Create it
    system ("mkdir -p $outdir") == 0
        or die "Cannot create output directory $outdir.\n";
}

#######################################################
# Process the catalog file(s) 
# 
if ( $opt{'catalog'} ) {
    print "Got here\n";
    # Add current directory to @INC
    ($homedir = $0 ) =~ s/\\/\//g;
    $homedir =~ s/^(.*)\/[^\/]+$/$1/;
    unshift (@INC, $homedir);
    require 'OASIS/Catalog.pm' 
        or die "Must have OASIS/Catalog.pm to process catalogs\n";
    $catalog = new OASIS::Catalog('DEBUG'=>1);
    my @catalogs = @{$opt{'catalog'}};
    foreach my $catfile (@catalogs) {
        print "catalog = $catfile \n";
        $catalog->parse($catfile) or die "Cannot load catalog file $catfile\n";
    }
}

#######################################################
# Main program
#######################################################
#
# Set outputs to autoflush
select(STDERR); $| =  1;
select(STDOUT); $| =  1;

# Set this for the first pass through the RNC to get names.
$pass = 1;

# And parse the RNC to load the name arrays.
print STDOUT "Parsing RNC files ...\n";
&parsefile($MainRNC);

# Print out verbose lists if option used.
&PrintLists if $verbose;

# Clear the Files array
@Files = ();

# Parse again and generate RNC html files
$pass = 2;
print STDOUT "Generating HTML files ...\n";
&parsefile($MainRNC);

# Generate framework and list HTML files
print STDOUT "Generating list files and HTML frameset...\n";
&MakeFramework;

# Generate usage tables 
if ($usagetables) {
    print STDOUT "Generating usage tables...\n" ;
    &GenerateUsageTables() ;
}

print STDOUT "Done.\n";

#######################################################
# PrintLists -- Print verbose lists of elements and named patterns
# 
sub PrintLists {
    my ($i, $columns, @header, $ruleline) ;

    # Print out the named patterns list
    $columns = "%-28s %-7s %-15s %s\n";
    @header = ('Name', 'Type', 'File', 'Value');
    $ruleline = "-" x 75 . "\n";

    print STDOUT "\n", $ruleline;
    print STDOUT "NAMED PATTERNS (in order of declaration)\n";
    print STDOUT $ruleline;
    printf STDOUT ($columns, @header);
    print STDOUT $ruleline;
    for ($i = 0; $i <= $#NP; ++$i) {
        my $rec = $NP{$NP[$i]};
        my $value = substr($rec->{value}, 0, 20);
        $value =~ s/\s+/ /gs;
        $value =~ s/^ //;
        $value .= " ..." if ( length($rec->{value}) > 20);
        printf STDOUT ($columns, 
            $rec->{name},
            $rec->{type},
            basename($rec->{file}),
            $value,
            );
    }
    # Print out the element list
    $columns = "%-30s %-15s %s\n";
    @header = ('Name', 'File', 'Anchor name');
    $ruleline = "-" x 60 . "\n";

    print STDOUT "\n", $ruleline;
    print STDOUT "ELEMENTS (in order of declaration)\n";
    print STDOUT $ruleline;
    printf STDOUT ($columns, @header);
    print STDOUT $ruleline;
    for ($i = 0; $i <= $#ELEMENT; ++$i) {
        my $rec = $ELEMENT{$ELEMENT[$i]};
        printf STDOUT ($columns,
            $rec->{name}, 
            basename($rec->{file}),
            $rec->{anchor});
    }
    print STDOUT $ruleline;
}


#######################################################
# parsefile -- Parse a RNC file 
#   Argument should be a SYSTEM name.  If the catalog option
#   is used, it should already have been looked up when
#   the SYSTEM entity was declared.  If no catalog option
#   then the SYSTEM name has not been checked for
#   readability or relative pathname.
#   
sub parsefile {
    my $Filename = shift;
    my $Basename = basename($Filename);
    my $size ;
    my $Output;
    local ($_);

    # Resolve pathnames relative to previous file
    # if not absolute
    if ( ! -f $Filename ) {
        $Filename = $dirstack[$#dirstack] . "/" . $Filename;
    }

    if ($Filename =~ /^(.*)[\/\\]([^\/\\]+)$/) {
        push (@dirstack, $1);
    } else {
        push (@dirstack, ".");
    }
    
    # Is the file already open?
    if ( grep /^$Filename$/, @Files ) {
        return;
    }
    # Add to the file array
    push @Files, $Filename;

    # Open and read the whole file into $_ variable for parsing
    my $Filehandle = IO::File->new($Filename)
        or die "Can't open file $Filename $!\n";
    read ($Filehandle, $_, -s $Filename);
    $Filehandle->close;

    print STDOUT "Parsing file $Filename pass $pass ...\n" if $verbose;

    if ( $pass == 1 ) {

      # Locate all live content declarations.
      while (/^(.*?)($attre|$elemre|$npre|$incre|$extre|$comre|$nsre|$quotere|$schemere)/s) {
          my $nondecl = $1;
          my $decl = $2;
          my $rest = $';

          my $fulldecl;
  

          if ( $decl =~ /$attre/ ) {
            # &readatt($decl, $Filename);
          }
          elsif ( $decl =~ /$elemre/ ) {
            # Get the full element declaration to make live, reset $rest
            ($fulldecl, $rest) = &fullelemdecl($decl, $rest);
            &readelem($fulldecl, $Filename);
          }
          elsif ( $decl =~ /$npre/ ) {
            # Get the full named pattern declaration to make live, reset $rest
            # ($fulldecl, $rest) = &fullnpdecl($decl, $rest);
            # &readnp($fulldecl, $Filename);
            &readnp($decl, $Filename);
          }
          elsif ( $decl =~ /$incre/ ) {
            &readinc($decl, $Filename);
          }
          elsif ( $decl =~ /$extre/ ) {
            &readext($decl, $Filename);
          }
          elsif ( $decl =~ /$schemere/ ) {
            ($fulldecl, $rest) = &fullschemedecl($decl, $rest);
            # skip schematron blocks 
          }
          elsif ( $decl =~ /$comre/ ) {
            # skip comments here
          }
          elsif ( $decl =~ /$nsre/ ) {
            # skip namespace declarations here
          }
          elsif ( $decl =~ /$quotere/ ) {
            # skip quoted words 
          }

          $_ = $rest;
      }
    }

    if ( $pass == 2 ) {

      my $outfile = $outdir . "/" . $label . $Basename . ".html";
      $Output = IO::File->new("> $outfile") 
         or die "Cannot write to output file $outfile.\n";

      # Set to autoflush 
      select($Output); $| = 1;

      # Write the header to the file
      my $onload = "parent.file.document.open();"
                    . "parent.file.document.write("
                    . "'<BODY TOPMARGIN=0><B>"
                    . $Basename
                    . "</B></BODY>');" 
                    . "parent.file.document.close()";

      print $Output $DOCTYPE;
      print $Output "<HTML>\n<HEAD>\n<TITLE>$Basename</TITLE>\n",
           "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n",
                   "<STYLE TYPE=\"text/css\">\n",
                   "  STRONG { font-weight: bold; color: red;}\n",
                   "  .COMMENT { font-style:italic; color: #A8A8A8;}\n",
                   "</STYLE>\n",
                   "</HEAD>\n",
                   "<BODY onLoad=\"$onload\"><?LIVERNC ENDHEAD?>\n<PRE>";

      my $longstring = $_;

      # Locate all live content declarations.
      while ( $longstring =~ /^(.*?)($attre|$elemre|$npre|$incre|$extre|$comre|$nsre|$quotere|$schemere)/s) {
          my $nondecl = $1;
          my $decl = $2;
          my $rest = $';
          my $fulldecl;
  
          &writenondecl($nondecl, $Filename, $Output);

          if ( $decl =~ /$attre/s ) {
            # Get the full attribute declaration to make live, reset $rest
            ($fulldecl, $rest) = &fullelemdecl($decl, $rest);
            &writeatt($fulldecl, $Filename, $Output);
          }
          elsif ( $decl =~ /$nsre/s ) {
            &writens($decl, $Filename, $Output);
          }
          elsif ( $decl =~ /$quotere/s ) {
            &writequote($decl, $Filename, $Output);
          }
          elsif ( $decl =~ /$schemere/s ) {
            ($fulldecl, $rest) = &fullschemedecl($decl, $rest);
            &writescheme($fulldecl, $Filename, $Output);
          }
          elsif ( $decl =~ /$elemre/s ) {
            # Get the full element declaration to make live, reset $rest
            ($fulldecl, $rest) = &fullelemdecl($decl, $rest);
            &writeelem($fulldecl, $Filename, $Output);
          }
          elsif ( $decl =~ /$npre/s ) {
            # Get the full named pattern declaration to make live, reset $rest
            ($fulldecl, $rest) = &fullnpdecl($decl, $rest);
            &writenp($fulldecl, $Filename, $Output);
          }
          elsif ( $decl =~ /$incre/s ) {
            &writeinc($decl, $Filename, $Output);
          }
          elsif ( $decl =~ /$extre/s ) {
            &writeext($decl, $Filename, $Output);
          }
          elsif ( $decl =~ /$comre/s ) {
            &writecom($decl, $Filename, $Output);
          }

          $longstring = $rest;
      }

      # Handle any trailing stuff at end of file
      &writenondecl($longstring, $Filename, $Output);

      # Mark the bottom so can remove HTML
      print $Output "<?LIVERNC EOF?>\n";
      # Pad bottom so #scrolls always show at top of frame
      print $Output "\n" x 40 ;
      print $Output "</PRE></BODY></HTML>";

      # Close the file
      $Output->close() 
    }
    pop (@dirstack);
}

#######################################################
# fullelemdecl -- Fetch the full declaration string for an element
# 
sub fullelemdecl {
    my $decl = shift;
    my $rest = shift;

    # Start with the first part
    my $fulldecl = $decl;
    my $nestlevel = 1;

    while( $rest =~ /(.*?([{}]))/s ) {
      my $match = $1;
      my $bracket = $2;
      my $post = $';

      if ( $bracket eq '}' && $nestlevel == 1 ) {
        # We are done
        $fulldecl .= $match;
        $rest = $post;
        last;
      }
      elsif ( $bracket eq '}' && $nestlevel > 1 ) {
        # decrement the nest counter
        --$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
        # continue
      }
      elsif ( $bracket eq '}' && $nestlevel == 0 ) {
        die "ERROR in element bracket nesting level: $decl\n";
      }
      elsif ( $bracket eq '{' ) {
        ++$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
      }
    }

    return($fulldecl, $rest);
}

#######################################################
# fullschemedecl -- Fetch the full declaration string for an schematron
# 
sub fullschemedecl {
    my $decl = shift;
    my $rest = shift;


    # Start with the first part
    my $fulldecl = $decl;
    my $nestlevel = 1;

    while( $rest =~ /(.*?([\[\]]))/s ) {
      my $match = $1;
      my $bracket = $2;
      my $post = $';

      if ( $bracket eq ']' && $nestlevel == 1 ) {
        # We are done
        $fulldecl .= $match;
        $rest = $post;
        last;
      }
      elsif ( $bracket eq ']' && $nestlevel > 1 ) {
        # decrement the nest counter
        --$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
        # continue
      }
      elsif ( $bracket eq ']' && $nestlevel == 0 ) {
        die "ERROR in element bracket nesting level: $decl\n";
      }
      elsif ( $bracket eq '[' ) {
        ++$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
      }
    }
    return($fulldecl, $rest);
}


#######################################################
# parendecl -- Fetch the full declaration string in a paren set
# 
sub parendecl {
    my $decl = shift;
    my $rest = shift;

    # Start with the first part
    my $fulldecl = $decl;
    my $nestlevel = 1;

    while( $rest =~ /(.*?([()]))/s ) {
      my $match = $1;
      my $bracket = $2;
      my $post = $';

      if ( $bracket eq ')' && $nestlevel == 1 ) {
        # We are done
        $fulldecl .= $match;
        $rest = $post;
        last;
      }
      elsif ( $bracket eq ')' && $nestlevel > 1 ) {
        # decrement the nest counter
        --$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
        # continue
      }
      elsif ( $bracket eq ')' && $nestlevel == 0 ) {
        die "ERROR in element bracket nesting level: $decl\n";
      }
      elsif ( $bracket eq '(' ) {
        ++$nestlevel;
        $fulldecl .= $match;
        $rest = $post;
      }
    }

    return($fulldecl, $rest);
}


#######################################################
# fullnpdecl -- Fetch the full declaration string for a named pattern 
# 
sub fullnpdecl {
    my $decl = shift;
    my $rest = shift;
    my $post;
    my $newrest;
    my $fulldecl;


    # step through rest recursively until finish

    # include elements
    if ( $rest =~ /^(\s*$elemre)/ ) {
      my $elemdecl = $1;
      my $elemrest = $';

      ($fulldecl, $newrest) = &fullelemdecl($elemdecl, $elemrest);

      $decl .= $fulldecl;

      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $newrest);
    }

    # Include attributes
    elsif ( $rest =~ /^(\s*$attre)/ ) {
      my $attdecl = $1;
      my $attrest = $';

      # Can use fullelemdecl because syntax is same
      ($fulldecl, $newrest) = &fullelemdecl($attdecl, $attrest);

      $decl .= $fulldecl;

      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $newrest);
    }

    # Include comments
    elsif ( $rest =~ /^(\s*$comre)/ ) {
      my $comdecl = $1;
      my $comrest = $';

      $decl .= $comdecl;
      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $comrest);
    }

    # Include parens
    elsif ( $rest =~ /^(\s*\()/ ) {
      my $parendecl = $1;
      my $parenrest = $';

      # assemble entire content of the paren 
      ($fulldecl, $newrest) = &parendecl($parendecl, $parenrest);
      $decl .= $fulldecl;

      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $newrest);
    }

    # Keep going with connectors
    elsif ( $rest =~ /^(\s*[&|,+*?])/ ) {

      $decl .= $1;

      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $');
    }

    # stop at a div start 
    elsif ( $rest =~ /^(\s*$divre)/ ) {
      # we are done.
    }

    # stop at a closing } by itself, which means end of div {}
    elsif ( $rest =~ /^(\s*[}])/ ) {
      # we are done.
    }

    # stop at the next named pattern
    elsif ( $rest =~ /^(\s*$npre)/ ) {
      # we are done.
    }

    # other names are included 
    elsif ( $rest =~ /^(\s*$NCname)/ ) {
      $decl .= $1;

      # recurse
      ($decl, $rest) = &fullnpdecl($decl, $');
    }

    return($decl, $rest);
}

#######################################################
# readelem -- Register a valid element definitino
# 
sub readelem {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;
    my $name;
    my $value;
    my $rest;
    my $lead;

    my $Basename = basename($Filename);

    $decl =~ /$elemre/;
    $name = $2;
    $value = $3 . $';

    # It is an error if name declared twice in one file
    if ( (grep /^$name$/, @ELEMENT) ne '' &&
            $Filename eq $ELEMENT{$name}->{file} ) {
       my $msg = "ERROR: element "
                 . $name
                 . " defined more than once, in same file '"
                 . $Filename 
                 . "'.\n" ;
       print STDERR $msg;
    }
    # replace if already there
    elsif ( grep /^$name$/, @ELEMENT ) {
      $ELEMENT{$name}->{file} = $Filename;
      $ELEMENT{$name}->{address} = $label 
                . $Basename . '.html#'
                . $ELEMENT{$name}->{anchor};
    }
    # Add to element list if not already there
    else {
        ++$ElementDefCount;
        my $rec = {};
        $rec->{name} = $name;
        $rec->{value} = $value;
        $rec->{file} = $Filename;
        $rec->{anchor} = 'ElementDef' . $ElementDefCount ;
        $rec->{address} = $label . $Basename
                          . '.html#' . $rec->{anchor} ;
        # save the record
        $ELEMENT{$name} = $rec;
        push (@ELEMENT, $name);
    }
}

#######################################################
# readnp -- Register a valid named pattern definition
# 
sub readnp {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;
    my $name;
    my $value;
    my $rest;
    my $lead;

    my $Basename = basename($Filename);

    $decl =~ /$npre/;
    $name = $1;
    $value = $2 . $';

    # It is an error if name declared twice in one file
    if ( (grep /^$name$/, @NP ne '') &&
            $Filename eq $NP{$name}->{file} ) {
       my $msg = "ERROR: named pattern "
                 . $name
                 . " defined more than once, in same file '"
                 . $Filename 
                 . "'.\n" ;
       print STDERR $msg;
    }
    # replace if already there
    elsif ( grep /^$name$/, @NP ) {
      $NP{$name}->{file} = $Filename;
      $NP{$name}->{address} = $label 
                . $Basename . '.html#'
                . $NP{$name}->{anchor};
    }
    # Add to NP list if not already there
    else {
        my $rec = {};
        $rec->{name} = $name;
        $rec->{value} = $value;
        $rec->{file} = $Filename;
        $rec->{anchor} = 'NPDef' . $name ;
        $rec->{address} = $label . $Basename
                          . '.html#' . $rec->{anchor} ;
        # save the record
        $NP{$name} = $rec;
        push (@NP, $name);
    }
}

#######################################################
# readinc -- Process an include statement
# 
sub readinc {
    my $decl = shift;
    my $Filename = shift;
    my $name;

    $decl =~ /$incre/;
    $name = $2;

    &parsefile($name);
}

#######################################################
# readext -- Process an include statement
# 
sub readext {
    my $decl = shift;
    my $Filename = shift;
    my $name;

    $decl =~ /$extre/;
    $name = $1;

    &parsefile($name);
}

#######################################################
# writeelem -- write out an element definition
# 
sub writeelem {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    my $Basename = basename($Filename);

    $decl =~ /$elemre/;
    my $pre = $1;
    my $name = $2;
    my $post = $3;
    my $rest = $';

    my $newdecl = $pre;

    # It is active element if name and filename match 
    if ( (grep /^$name$/, @ELEMENT) ne '' &&
            $Filename eq $ELEMENT{$name}->{file} ) {
        my $replace = "<A NAME=\""
                      . $ELEMENT{$name}->{anchor}
                      . "\"></A>"
                      . "<STRONG>"
                      . $name
                      . "</STRONG>" ;
        $newdecl .= $replace ;
        $newdecl .= $post;
        print $Output $newdecl;
        print $Output &MakeLive($rest, 'ELEMENT', $name);
    }
    else {
        print $Output $decl;
    }
}

#######################################################
# writenp -- write out a named pattern
# 
sub writenp {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    my $Basename = basename($Filename);

    $decl =~ /$npre/;
    my $name = $1;
    my $post = $2;
    my $rest = $';

    my $newdecl;

    # It is active element if name and filename match 
    if ( (grep /^$name$/, @NP) ne '' &&
            $Filename eq $NP{$name}->{file} ) {
        my $replace = "<A NAME=\""
                      . $NP{$name}->{anchor}
                      . "\"></A>"
                      . "<STRONG>"
                      . $name
                      . "</STRONG>" ;
        $newdecl .= $replace ;
        $newdecl .= $post ;
        print $Output $newdecl;
        print $Output &MakeLive($rest, 'NP', $name);
    }
    else {
        print $Output $decl;
    }

}

#######################################################
# writeatt -- Print attribute
# 
sub writeatt {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    $decl =~ /($attre)/;

    my $start = $1;
    my $name = $3;
    my $rest = $';

    print $Output &html($start);
    print $Output &MakeLive($rest, 'ATTLIST', $name);
}

#######################################################
# writeinc -- Print include
# 
sub writeinc {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output &html($decl) if $Output;
}

#######################################################
# writeext -- Print external
# 
sub writeext {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output &html($decl) if $Output;
}


#######################################################
# writecom -- Print Comment
# 
sub writecom {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output "<SPAN CLASS=\"COMMENT\">";
    print $Output &html($decl);
    print $Output "</SPAN>";
}

#######################################################
# writens -- Print namespace declaration
# 
sub writens {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output &html($decl) if $Output;
}

#######################################################
# writequote -- Print quoted text 
# 
sub writequote {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output &html($decl) if $Output;
}

#######################################################
# writescheme -- Print schematron block
# 
sub writescheme {
    my $decl = shift;
    my $Filename = shift;
    my $Output = shift;

    print $Output &html($decl) if $Output;
}


#######################################################
# writenondecl -- Parse and print text outside of declarations
# 
sub writenondecl {
    my $string = shift;
    my $Filename = shift;
    my $Output = shift;
    my $declname;
    my $decltype;

    print $Output &MakeLive($string);
}



#######################################################
# ResolveExternalID -- Resolve an external identifier
#    If catalog specified, tries to resolve to readable pathname,
#    or returns  SYSTEM ID if available (not checked for 
#    readability), or returns an empty string.
#    If no catalog, just returns  SYSTEM ID if available (not checked for 
#    readability), or returns an empty string.
# 
sub ResolveExternalID {
    my $pubid = shift;
    my $sysid = shift;
    my $value = "";

    # Catalog has precedence, if used.
    if ( defined($catalog) ) {
        $value = $catalog->system_map($sysid) if $sysid;
        return($value) if ( -f $value);
        $value = $catalog->public_map($pubid) if $pubid;
        return($value) if ( -f $value);
        $value = $sysid if $sysid;
        return($value) if ( -f $value);
    }
    $value = $sysid if $sysid;
    return($value) 

}

#######################################################
# html -- Escape any special characters for HTML output
#
sub html {
    my $string = shift;

    $string =~ s/&/&amp;/sg;
    $string =~ s/</&lt;/sg;
    $string =~ s/>/&gt;/sg;

    return ($string);
}

#######################################################
# MakeLive -- Add HREFs to declaration
# 
sub MakeLive {
    my $string = shift;
    my $decltype = shift;
    my $declname = shift;
    my $mode = shift;

    # Defaults to blank
    $decltype = "" unless $decltype;
    $declname = "" unless $declname;
    $mode = "" unless $mode;

    # Escape any HTML markup
    $string = &html($string);

    my $newstring;

    # format any declared names 
    while ($string =~ /(.*?)($elemre|$NCname|$comre)/s) {
        my $pre = $1;
        my $name = $2;
        my $rest = $';

        $newstring .= $pre;

        # If it is a comment, then pass it through dead
        if ( $name =~ /^$comre/ ) {
            $newstring .= $name;
        }
        # If an element declaration, then make the element name an anchor
        elsif ( $name =~ /^$elemre/ ) {
            my $elempre = $1;
            my $elemname = $2;
            my $elemrest = $3;
        
            $newstring .= $elempre;
        
            # It is active element if name and filename match 
            if ( (grep /^$elemname$/, @ELEMENT) ne '' ) {
                my $replace = "<A NAME=\""
                              . $ELEMENT{$elemname}->{anchor}
                              . "\"></A>"
                              . "<STRONG>"
                              . $elemname
                              . "</STRONG>" ;
                $newstring .= $replace ;
                $newstring .= $elemrest;
            }
            else {
                $newstring .= $elemname . $elemrest ;
            }
        }
        # Is this name in the array of named patterns?
        elsif ( grep /^$name$/, @NP ) {
            my $replace = "<A HREF=\"" 
               . $NP{$name}->{address}
               . "\">"
               . $name ;
            $replace .= "</A>";
            $newstring .= $replace;

            # Generate record for usage tables
            if ( $usagetables && $declname && $decltype ) {
                &UsageTables($name, 'NP', $declname, $decltype);
            }
        }
        elsif ( grep /^$name$/, @ELEMENT ) {
            my $replace = "<A HREF=\"" 
               . $ELEMENT{$name}->{address}
               . "\">"
               . $name ;
            $replace .= "</A>";
            $newstring .= $replace;

            # Generate record for usage tables
            if ( $usagetables && $declname && $decltype ) {
                &UsageTables($name, 'ELEMENT', $declname, $decltype);
            }
        }
        # else just hide it
        else {
            $newstring .= $name;
        }

        $string = $rest;

        if ($rest !~ /$NCname/s) {
          last;
        }
    }

    # Capture any trailing text
    $newstring .= $string;

    # Now print the filtered string
    return($newstring);
}

#######################################################
# MakeFramework -- generate HTML frameset and TOC files
# 
sub MakeFramework {
    my $key;

    # Generate the main TOC rows as variable for insertion into
    # each of the three alpha list tables.

    my $maintoc = "<TR><TD><B>$title</B></TD></TR>\n";
    foreach $key ('FileList', 'ElemList', 'PatternList') {
        $maintoc .= "<TR><TD><A HREF=\""
                      . $label
                      . $key
                      . ".html"
                      . "\" TARGET=\"left\">"
                      . $ListTitle{$key}
                      . "</A></TD></TR>\n";
    }
    $maintoc .= "<TR><TD><HR></TD></TR>\n";

    # Generate the three alphabetical list files.
    # Elements
    open OUTFILE, "> $outdir/" . $label . "ElemList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " Element list</TITLE>\n",
                       "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'ElemList'}</B></TD></TR>\n";
    foreach $key ( sort { lc($a) cmp lc($b) } @ELEMENT) {
        my $rec = $ELEMENT{$key};
        print OUTFILE "<TR><TD>";
        if ($usagetables) {
            print OUTFILE "<A HREF=\"",
                          $label,
                          "ElemUsage.html#ELU",
                          $key,
                          "\" TARGET=\"right\">",
                          $UsageSymbol,
                          "</A>&nbsp;";
        }
        print OUTFILE "<A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\">$key</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # Named patterns
    open OUTFILE, "> $outdir/" . $label . "PatternList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " Named Pattern list</TITLE>\n",
                       "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'PatternList'}</B></TD></TR>\n";
    foreach $key ( sort { lc($a) cmp lc($b) } @NP) {
        my $rec = $NP{$key};
        print OUTFILE "<TR><TD>";
        if ($usagetables) {
            print OUTFILE "<A HREF=\"",
                          $label,
                          "PatternUsage.html#NPU",
                          $key,
                          "\" TARGET=\"right\">",
                          $UsageSymbol,
                          "</A>&nbsp;";
        }
        print OUTFILE "<A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\">$key</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # Files in order of appearance
    open OUTFILE, "> $outdir/" . $label . "FileList.html";
    print OUTFILE $DOCTYPE;
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  $title,
                  " File list</TITLE>\n",
                       "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n",
                  "</HEAD>\n<BODY>\n";
    print OUTFILE "<TABLE CELLSPACING=0 CELLPADDING=0 ALIGN=left",
                  " BORDER=0 COLS=1>\n";
    print OUTFILE "$maintoc";
    print OUTFILE "<TR><TD><B>$ListTitle{'FileList'}</B></TD></TR>\n";
    foreach $key (0 .. $#Files) {
        print OUTFILE "<TR><TD><A HREF=\"",
                      "$label",
                      basename($Files[$key]),
                      ".html",
                      "\" TARGET=\"right\">",
                      basename($Files[$key]),
                      "</A></TD></TR>\n";
    }
    print OUTFILE "</TABLE>\n</BODY>\n</HTML>\n";
    close OUTFILE;

    # And generate the framework file
    open OUTFILE, "> $outdir/" . $label . "index.html";
    print OUTFILE "<HTML>\n<HEAD>\n<TITLE>",
                  "LiveRNC: ",
                  $title,
                  "</TITLE>\n",
                  "<META name=\"generator\" content=\"livernc.pl\">\n",
                  "<META name=\"source\" content=\"http://www.sagehill.net\">\n",
                  "</HEAD>\n";
    print OUTFILE "<FRAMESET COLS=\"20%,80%\">\n",
                  "    <FRAME SRC=\"",
                  $label,
                  "ElemList.html\" NAME=\"left\">\n",
                  "    <FRAMESET FRAMEBORDER=NO ROWS=\"7%,*\">\n",
                  "        <FRAME SRC=\"\" SCROLLING=AUTO NAME=\"file\">\n",
                  "        <FRAME SRC=\"",
                  $label . basename($MainRNC),
                  ".html\" NAME=\"right\">\n",
                  "    </FRAMESET>\n",
                  "    <NOFRAMES>\n",
                  "    This version requires a frames-based browser.\n",
                  "    </NOFRAMES>\n",
                  "</FRAMESET>\n",
                  "</HTML>\n";
    close OUTFILE;

    # Generate the stylesheet file
    open OUTFILE, "> $outdir/" . "livernc.css";
    print OUTFILE "PRE { font-family: monospace; }\n";
    close OUTFILE;
}

#######################################################
# UsageTables -- Add a line item to a usage table
#   Usage: UsageTables($name, $utype, $declname, $decltype);
#       $name being used 
#       $utype - item type being used (NP or ELEMENT)
#       $declname - which declaration is using it
#       $decltype - type of declaration using the name
#                    ELEMENT | NP | ATTLIST | MS (marked section)
sub UsageTables {
    my $uname = shift;
    my $utype = shift;
    my $declname = shift;
    my $decltype = shift;

    # If usage is a parameter entity
    if ( $utype eq 'NP' ) {
        # Is there already some usage encountered?
        unless ( grep /^$uname$/, @NPUsage ) {
            # Start a new NP usage record
            my $rec = {};
            $rec->{name} = $uname;
            $rec->{elemusage} = ();
            $rec->{npusage} = ();
            $rec->{'attusage'} = ();
            $rec->{'msusage'} = ();
    
            # Attach this set of arrays to this NP name
            $NPUsage{$uname} = $rec;
            # Keep track of which names have been used
            push ( @NPUsage, $uname);
        }
        # And add the data to the record
        if ($decltype eq 'ELEMENT') {
            push @{$NPUsage{$uname}->{elemusage}}, $declname;
        }
        elsif ($decltype eq 'NP') {
            push @{$NPUsage{$uname}->{npusage}}, $declname;
        }
        elsif ($decltype eq 'ATTLIST') {
                push @{$NPUsage{$uname}->{'attusage'}}, $declname;
        }
    }
    elsif ( $utype eq 'ELEMENT' ) {
        # Is there already some usage encountered?
        unless ( grep /^$uname$/, @ElemUsage ) {
            # Start a new element usage record
            my $rec = {};
            $rec->{name} = $uname;
            $rec->{elemusage} = ();
            $rec->{npusage} = ();
            $rec->{'attusage'} = ();
            $rec->{'msusage'} = ();
    
            # Attach this set of arrays to this element name
            $ElemUsage{$uname} = $rec;
            # Keep track of which names have been used
            push ( @ElemUsage, $uname);
        }
        # And add the data to the record
        if ($decltype eq 'ELEMENT') {
            # names are an array reference
            foreach my $i (@$declname) {
                push @{$ElemUsage{$uname}->{elemusage}}, $i;
            }
        }
        elsif ($decltype eq 'NP') {
            push @{$ElemUsage{$uname}->{npusage}}, $declname;
        }
    }
}

#######################################################
# GenerateUsageTables -- Generate the usage tables
#   
sub GenerateUsageTables {
    my $declname;
    my $usagename;

    # Generate the three alphabetical usage files.
    # Elements
    open OUTFILE, "> $outdir/" . $label . "ElemUsage.html";
    # Code to print title above right frame
    my $onload = "parent.file.document.open();"
                  . "parent.file.document.write("
                  . "'<BODY TOPMARGIN=0><B>"
                  . $ListTitle{ElemUsage}
                  . "</B></BODY>');" 
                  . "parent.file.document.close()";

    print OUTFILE $DOCTYPE
                  . "<HTML>\n<HEAD>\n<TITLE>"
                  . "$title $ListTitle{ElemUsage}</TITLE>\n"
                       . "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n"
                  . "</HEAD>\n"
                  . "<BODY onLoad=\"$onload\">\n"
                  . "<H2>$ListTitle{ElemUsage}</H2>\n";

    # Output a <PRE> usage list for each declared element
    foreach $declname ( sort { lc($a) cmp lc($b) } @ELEMENT) {
        # Get its record of data
        my $rec = $ELEMENT{$declname};
        # Start this element
        print OUTFILE "<HR><SPAN class=\"usage\"><B><A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\"",
                      " NAME=\"ELU",
                      $declname,
                      "\"><CODE>$declname</CODE></A>",
                      " element seen in:</B></SPAN><PRE>\n";
        # Now sorted list of its usage in other element declarations
        if ( defined $ElemUsage{$declname}->{'elemusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'elemusage'}} ) {
                print OUTFILE "   ELEMENT <A HREF=\"",
                      $ELEMENT{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in parameter entity declarations
        if ( defined $ElemUsage{$declname}->{'npusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'npusage'}} ) {
                print OUTFILE "   PATTERN <A HREF=\"",
                      $NP{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in ATTLIST declarations
        if ( defined $ElemUsage{$declname}->{'attusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$ElemUsage{$declname}->{'attusage'}} ) {
                print OUTFILE "   ATTLIST <A HREF=\"",
                      $ATTLIST{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        print OUTFILE "</PRE>\n";
    }
    # Pad bottom so #scrolls always show at top of frame
    print OUTFILE "<PRE>\n"
                  . "\n" x 40 
                  . "</PRE>\n"
                  . "</BODY>\n</HTML>\n";
    close OUTFILE;

    # Parameter entities
    open OUTFILE, "> $outdir/" . $label . "PatternUsage.html";

    # Code to print title above right frame
    $onload = "parent.file.document.open();"
                  . "parent.file.document.write("
                  . "'<BODY TOPMARGIN=0><B>"
                  . $ListTitle{PatternUsage}
                  . "</B></BODY>');" 
                  . "parent.file.document.close()";

    print OUTFILE $DOCTYPE
                  . "<HTML>\n<HEAD>\n<TITLE>"
                  . "$title "
                  . $ListTitle{PatternUsage}
                  . "</TITLE>\n"
                       . "<LINK REL=\"stylesheet\" TYPE=\"text/css\" HREF=\"livernc.css\">\n"
                  . "</HEAD>\n"
                  . "<BODY onLoad=\"$onload\">\n"
                  . "<H2>"
                  . $ListTitle{PatternUsage}
                  . "</H2>\n";

    # Output a <PRE> usage list for each declared NP
    foreach $declname ( sort { lc($a) cmp lc($b) } @NP) {
        # Get its record of data
        my $rec = $NP{$declname};
        # Start this element
        print OUTFILE "<HR><SPAN class=\"usage\"><B><A HREF=\"",
                      $rec->{address},
                      "\" TARGET=\"right\"",
                      " NAME=\"NPU",
                      $declname,
                      "\"><CODE>$declname</CODE></A>",
                      " seen in:</B></SPAN><PRE>\n";
        # Now sorted list of its usage in other element declarations
        if ( defined $NPUsage{$declname}->{'elemusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$NPUsage{$declname}->{'elemusage'}} ) {
                print OUTFILE "   ELEMENT <A HREF=\"",
                      $ELEMENT{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        # Now sorted list of its usage in named pattern declarations
        if ( defined $NPUsage{$declname}->{'npusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc ($b)}
                                 @{$NPUsage{$declname}->{'npusage'}} ) {
                print OUTFILE "   PATTERN <A HREF=\"",
                      $NP{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }

        # Now sorted list of its usage in ATTLIST declarations
        if ( defined $NPUsage{$declname}->{'attusage'} ) {
            foreach $usagename ( sort {lc($a) cmp lc($b)}
                                 @{$NPUsage{$declname}->{'attusage'}} ) {
                print OUTFILE "   ATTLIST <A HREF=\"",
                      $ATTLIST{$usagename}->{'address'},
                      "\">",
                      $usagename,
                      "</A>\n";
            }
        }
        print OUTFILE "</PRE>\n";
    }
    # Pad bottom so #scrolls always show at top of frame
    print OUTFILE "<PRE>\n"
                  . "\n" x 40 
                  . "</PRE>\n"
                  . "</BODY>\n</HTML>\n";
    close OUTFILE;
}

