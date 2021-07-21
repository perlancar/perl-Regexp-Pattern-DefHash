package Regexp::Pattern::DefHash;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

my @prop_examples = (
    {str=>'p', matches=>1},
    {str=>'_', matches=>1},
    {str=>'prop', matches=>1},
    {str=>'Prop2', matches=>1},
    {str=>'prop_', matches=>1},

    {str=>'0prop', matches=>0, summary=>'Cannot start with digit'},
    {str=>'prop-erty', matches=>0, summary=>'Invalid character: dash'},
    {str=>'property ', matches=>0, summary=>'Invalid character: whitespace'},
);

my @attr_examples = (
    {str=>'.attr', matches=>1},
    {str=>'._attr', matches=>1},
    {str=>'.attr1.subattr2', matches=>1},
    {str=>'prop.attr1', matches=>1},
    {str=>'_prop._attr1', matches=>1},
    {str=>'Prop.attr1.subattr2.Subattr3', matches=>1},
    {str=>'_prop.attr1', matches=>1},

    {str=>'.0attr', matches=>0, summary=>'Cannot start with digit (1)'},
    {str=>'prop.0attr', matches=>0, summary=>'Cannot start with digit (2)'},
    {str=>'prop.attr.0subattr', matches=>0, summary=>'Cannot start with digit (3)'},
    {str=>'.attr-ibute', matches=>0, summary=>'Invalid character: dash (1)'},
    {str=>'prop-erty.attribute', matches=>0, summary=>'Invalid character: dash (2)'},
    {str=>'prop.attr-ibute', matches=>0, summary=>'Invalid character: dash (3)'},
    {str=>'property .attr', matches=>0, summary=>'Invalid character: whitespace (1)'},
    {str=>'property.attr ', matches=>0, summary=>'Invalid character: whitespace (2)'},
    {str=>'.attr ', matches=>0, summary=>'Invalid character: whitespace (3)'},

    {str=>'.', matches=>0, summary=>'Invalid syntax: dot only'},
    {str=>'..attr', matches=>0, summary=>'Invalid syntax: double dot'},
    {str=>'attr.', matches=>0, summary=>'Invalid syntax: dot without attr'},
    {str=>'attr..', matches=>0, summary=>'Invalid syntax: dot without attr (2)'},
);

my $patspec_prop_or_attr = {
    summary => 'Attribute key or property key',
    pat => qr/\A(?:([A-Za-z_][A-Za-z0-9_]*)|([A-Za-z_][A-Za-z0-9_]*)?\.([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*))\z/,
    tags => ['anchored', 'capturing'],
    description => <<'_',

All keys in defhash must match this pattern.

_
    examples => [
        @prop_examples,
        @attr_examples,

        {str=>'', matches=>0, summary=>'Empty'},
    ],
};

our %RE = (
    prop => {
        summary => 'Property key',
        pat => qr/\A[A-Za-z_][A-Za-z0-9_]*\z/,
        tags => ['anchored'],
        examples => [
            @prop_examples,

            {str=>'', matches=>0, summary=>'Empty'},

            {str=>'prop.attr', matches=>0, summary=>'Attribute, not property'},
            {str=>'.attr', matches=>0, summary=>'Attribute, not property'},
        ],
    },
    attr => {
        summary => 'Attribute key',
        pat => qr/\A([A-Za-z_][A-Za-z0-9_]*)?\.([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*)\z/,
        tags => ['anchored', 'capturing'],
        examples => [
            @attr_examples,

            {str=>'', matches=>0, summary=>'Empty'},

            {str=>'p', matches=>0, summary=>'Property, not attribute'},
            {str=>'_', matches=>0, summary=>'Property, not attribute'},
        ],
    },

    attr_part => {
        summary => 'Attribute part in attribute key',
        pat => qr/\A[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*\z/,
        tags => ['anchored'],
        examples => [
            {str=>'', matches=>0, summary=>'Empty'},

            {str=>'p', matches=>1},
            {str=>'p.q', matches=>1},
            {str=>'.p', matches=>0, summary=>'Dot prefix must not be included'},
        ],
    },

    prop_or_attr => $patspec_prop_or_attr,

    key => $patspec_prop_or_attr, # alias for prop_or_attr
);

1;
# ABSTRACT: Regexp patterns related to DefHash

=head1 prepend:SEE ALSO

L<DefHash> specification.
