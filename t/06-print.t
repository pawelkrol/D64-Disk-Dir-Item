########################################
use strict;
use warnings;
use IO::Scalar;
use Test::Exception;
use Test::More tests => 5;
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
    my $sh = new IO::Scalar;
    my $item = get_item();
    $item->print(fh => $sh);
    my $print_out = ${$sh->sref};
    chomp $print_out;
    is($print_out, '1     "test"             prg ', 'print out valid directory item in ASCII mode');
}
########################################
{
    my $sh = new IO::Scalar;
    my $item = get_item();
    $item->type($T_REL);
    $item->closed(0);
    $item->locked(1);
    my $name = chr(0x4e) . chr(0x45) . chr(0x57) . chr(0x46) . chr(0x49) . chr(0x4c) . chr(0x45) . chr(0x20) . chr(0x4e) . chr(0x45) . chr(0x57) . chr(0x46) . chr(0x49) . chr(0x4c) . chr(0x45);
    $item->name($name);
    $item->size(160);
    $item->print(fh => $sh);
    my $print_out = ${$sh->sref};
    chomp $print_out;
    is($print_out, '160   "newfile newfile" *rel<', 'print out modified directory item in ASCII mode');
}
########################################
{
    my $sh = new IO::Scalar;
    my $item = get_item();
    $item->print(fh => $sh, as_petscii => 1);
    my $print_out = ${$sh->sref};
    my @expected_bytes = qw(82 11 00 54 45 53 54 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0 00 00 00 00 00 00 00 00 00 01 00);
    my @expected_data = map { chr } map { hex } @expected_bytes;
    my $expected_print_out = join '', @expected_data;
    is($print_out, $expected_print_out, 'print out valid directory item in PETSCII mode');
}
########################################
{
    my $sh = new IO::Scalar;
    my $item = get_item();
    $item->type($T_REL);
    $item->track(0x13);
    $item->sector(0x03);
    $item->closed(0);
    $item->locked(1);
    my $name = chr(0x4e) . chr(0x45) . chr(0x57) . chr(0x46) . chr(0x49) . chr(0x4c) . chr(0x45) . chr(0x20) . chr(0x4e) . chr(0x45) . chr(0x57) . chr(0x46) . chr(0x49) . chr(0x4c) . chr(0x45);
    $item->name($name);
    $item->size(320);
    $item->print(fh => $sh, as_petscii => 1);
    my $print_out = ${$sh->sref};
    chomp $print_out;
    my @expected_bytes = qw(44 13 03 4e 45 57 46 49 4c 45 20 4e 45 57 46 49 4c 45 a0 00 00 00 00 00 00 00 00 00 40 01);
    my @expected_data = map { chr } map { hex } @expected_bytes;
    my $expected_print_out = join '', @expected_data;
    is($print_out, $expected_print_out, 'print out modified directory item in PETSCII mode');
}
########################################
