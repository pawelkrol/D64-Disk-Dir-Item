########################################
use strict;
use warnings;
use Test::Exception;
use Test::More tests => 36;
########################################
our $class;
BEGIN {
    $class = 'D64::Disk::Dir::Item';
    use_ok($class, qw(:all));
}
########################################
sub get_item {
    my @bytes = qw(82 11 00 54 45 53 54 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 00 00 00 00 00 00 00 00 00 01 00);
    my @data = map { chr } map { hex } @bytes;
    my $item = $class->new(@data);
    return $item;
}
########################################
{
    my $item = $class->new();
    my $type = $item->type();
    is($type, $T_DEL, 'get current type from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $type = $item->type();
    is($type, $T_PRG, 'get current type from a valid directory item');
}
########################################
{
    my $string = $class->type_to_string($T_DEL);
    is($string, 'del', 'convert $T_DEL file type into "del" string');
}
########################################
{
    my $string = $class->type_to_string($T_SEQ);
    is($string, 'seq', 'convert $T_SEQ file type into "seq" string');
}
########################################
{
    my $string = $class->type_to_string($T_PRG);
    is($string, 'prg', 'convert $T_PRG file type into "prg" string');
}
########################################
{
    my $string = $class->type_to_string($T_USR);
    is($string, 'usr', 'convert $T_USR file type into "usr" string');
}
########################################
{
    my $string = $class->type_to_string($T_REL);
    is($string, 'rel', 'convert $T_REL file type into "rel" string');
}
########################################
{
    my $string = $class->type_to_string($T_CBM);
    is($string, 'cbm', 'convert $T_CBM file type into "cbm" string');
}
########################################
{
    my $string = $class->type_to_string($T_DIR);
    is($string, 'dir', 'convert $T_DIR file type into "dir" string');
}
########################################
{
    my $string = $class->type_to_string(0xf0);
    is($string, '???', 'convert invalid file type into "???" string');
}
########################################
{
    my $item = $class->new();
    my $is_closed = $item->closed();
    ok(!$is_closed, 'get closed flag from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $is_closed = $item->closed();
    ok($is_closed, 'get closed flag from a valid directory item');
}
########################################
{
    my $item = $class->new();
    my $is_locked = $item->locked();
    ok(!$is_locked, 'get locked flag from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $is_locked = $item->locked();
    ok(!$is_locked, 'get locked flag from a valid directory item');
}
########################################
{
    my $item = $class->new();
    my $track = $item->track();
    is($track, 0x00, 'get track location of first sector of file from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $track = $item->track();
    is($track, 0x11, 'get track location of first sector of file from a valid directory item');
}
########################################
{
    my $item = $class->new();
    my $sector = $item->sector();
    is($sector, 0x00, 'get sector location of first sector of file from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $sector = $item->sector();
    is($sector, 0x00, 'get sector location of first sector of file from a valid directory item');
}
########################################
{
    my $item = $class->new();
    $item->type($T_REL);
    my $side_track = $item->side_track();
    is($side_track, 0x00, 'get track location of first side-sector block from an empty relative file item');
}
########################################
{
    my $item = get_item();
    $item->type($T_REL);
    my $side_track = $item->side_track();
    is($side_track, 0x00, 'get track location of first side-sector block from a valid relative file item');
}
########################################
{
    my $item = get_item();
    my $side_track = $item->side_track();
    is($side_track, undef, 'get track location of first side-sector block from a valid program file item');
}
########################################
{
    my $item = $class->new();
    $item->type($T_REL);
    my $side_sector = $item->side_sector();
    is($side_sector, 0x00, 'get sector location of first side-sector block from an empty relative file item');
}
########################################
{
    my $item = get_item();
    $item->type($T_REL);
    my $side_sector = $item->side_sector();
    is($side_sector, 0x00, 'get sector location of first side-sector block from a valid relative file item');
}
########################################
{
    my $item = get_item();
    my $side_sector = $item->side_sector();
    is($side_sector, undef, 'get sector location of first side-sector block from a valid program file item');
}
########################################
{
    my $item = $class->new();
    $item->type($T_REL);
    my $record_length = $item->record_length();
    is($record_length, 0x00, 'get record length from an empty relative file item');
}
########################################
{
    my $item = get_item();
    $item->type($T_REL);
    my $record_length = $item->record_length();
    is($record_length, 0x00, 'get record length from a valid relative file item');
}
########################################
{
    my $item = get_item();
    my $record_length = $item->record_length();
    is($record_length, undef, 'get record length from a valid program file item');
}
########################################
{
    my $item = $class->new();
    my $size = $item->size();
    is($size, 0x00, 'get file size in sectors from an empty directory item');
}
########################################
{
    my $item = get_item();
    my $size = $item->size();
    is($size, 0x01, 'get file size in sectors from a valid directory item');
}
########################################
{
    my $item = $class->new();
    my $is_empty = $item->empty();
    ok($is_empty, 'get empty flag from an empty directory item yields true');
}
########################################
{
    my $item = get_item();
    my $is_empty = $item->empty();
    ok(!$is_empty, 'get empty flag from a valid directory item yields false');
}
########################################
{
    my $item = $class->new();
    my $is_writable = $item->writable();
    ok($is_writable, 'get writable flag from an empty directory item yields true');
}
########################################
{
    my $item = get_item();
    my $is_writable = $item->writable();
    ok(!$is_writable, 'get writable flag from a valid directory item yields false');
}
########################################
{
    my $item = get_item();
    $item->closed(1);
    $item->type($T_DEL);
    my $is_writable = $item->writable();
    ok(!$is_writable, 'get writable flag from a closed DEL directory item yields false');
}
########################################
{
    my $item = get_item();
    $item->closed(0);
    $item->type($T_DEL);
    my $is_writable = $item->writable();
    ok($is_writable, 'get writable flag from a splat DEL directory item yields true');
}
########################################
