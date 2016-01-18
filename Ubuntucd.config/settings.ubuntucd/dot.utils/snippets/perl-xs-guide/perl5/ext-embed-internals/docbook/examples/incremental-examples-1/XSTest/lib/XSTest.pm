package XSTest;

use warnings;
use strict;

=head1 NAME

XSTest - Module that serves as a playground for writing XS code.

=head1 VERSION

Version 0.0007

=cut

our $VERSION = '0.0007';

require XSLoader;
XSLoader::load('XSTest', $VERSION);

=head1 SYNOPSIS

Perhaps a little code snippet.

    use XSTest;

    my $foo = XSTest->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new

Creates a new XSTest object.  Takes the following optional parameters:

=over 4

=item value

If you pass a single numeric value, it will be stored in the 'value' slot
of the object hash.

=item key/value pair

A generic input method which takes an unlimited number of key/value pairs
and stores them in the object hash.  Performs no validation.

=back

=cut

#sub new {
# Defined in the XS code
#}

=head2 increment

An object method which increments the 'value' slot of the the object hash,
if it exists.  Called like this:

  my $obj = XSTest->new(5);
  $obj->increment(); # now equal to 6

=cut

=head2 hello

A function that prints "C<Hello, World!\n>" to the (C) stdout filehandle.

=head2 get_24

A function that returns the 24 integer implemented as XS.

=head2 get_xs_string

Returns an XS String constant - C<"Hello">.

=head2 get_xs_binary_string

Returns an XS string with some C<'\0'>. Namely: C<"a\0b\0c">.

=head2 assign_string_to_ref(\$myvar)

Does the XS equivalent of:

    sub assign_string_to_ref
    {
        my ($var_ref) = @_;
        ${$var_ref} = "XSTest was here.";

        return;
    }

=head2 sum(\@myarray)

Makes a numberic sum of the array elements. If the array is empty - returns 0.
If the element is not numeric - it is ignored. Returns a floating point number.

This function is meant to demonstrate array access using XS.

=head2 assign_to_array(\@myarray, $idx, $value)

Equivalent to: C<< $myarray[$idx] = $value; >>

This function is meant to demonstrate assigning to array values using XS.

=head2 $total = concat_two_array_refs(\@array1, \@array2);

Equivalent to: C<< $total = [@array1, @array2]; >>

This function is meant to demonstrate creating new array references and 
populating them.

=head2 $value = lookup_mystring_in_hash(\%hash)

Equivalent to C<< $value = $hash{'mystring'} >>

This function is meant to demonstrate hash lookup. Returns undef if the
hash does not contain the key C<'mystring'> .

=head2 $value = lookup_value_in_hash(\%hash, $key)

Equivalent to C<< $value = $hash{$key} >>

This function is meant to demonstrate hash lookup with a user-given or
run-time specified key. Returns undef if the hash does not contain the key.

=head1 AUTHOR

Shlomi Fish, C<< <shlomif@iglu.org.il> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-xstest@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XSTest>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Shlomi Fish, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of the MIT/X11 License.

=cut

1; # End of XSTest
