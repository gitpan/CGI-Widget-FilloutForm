package CGI::Widget::FilloutForm::Base;

require 5.004;
use strict;

# --------------------- USER CUSTOMIZABLE VARIABLES ------------------------
# --------------------- END USER CUSTOMIZABLE VARIABLES --------------------

sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = bless { @_ }, $class;
    $self->initialize if $self->can('initialize');
    return $self;
}


sub display_date_entry {
    my ($self, $mon_conf, $day_conf, $year_conf) = @_;
    my $q = $self->{q};

    my %months =
      ('00' => "00 (undefined)",
       '01' => "01 (January)", '02' => "02 (February)", '03' => "03 (March)",
       '04' => "04 (April)",   '05' => "05 (May)",      '06' => "06 (June)",
       '07' => "07 (July)",    '08' => "08 (August)",   '09' => "09 (September)",
       '10' => "10 (October)", '11' => "11 (November)", '12' => "12 (December)");
    my ($cur_yr, $cur_mon, $cur_day) = $self->get_date();

    return
      (($mon_conf->{'not_shown'} ? ''
	: ($mon_conf->{'no_popup'}
	   ? $q->textfield(%$mon_conf)
	   : $q->popup_menu(-name => $mon_conf->{-name},
			    -values => [($mon_conf->{'use_undef'}
					 ? (defined $mon_conf->{'undef_val'}
					    ? $mon_conf->{'undef_val'} : '00')
					 : ()),
					'01'..'12'],
			    -labels => \%months,
			    -default => ($mon_conf->{-default}
					 ? $mon_conf->{-default}
					 : ($mon_conf->{'use_undef'}
					    ? '00' : $cur_mon)),
			    -override => $mon_conf->{-override},
			    ($mon_conf->{-disabled} ? (-disabled) : ()),
			   ))) .
       ($day_conf->{'not_shown'} ? ''
	: ($day_conf->{'no_popup'}
	   ? $q->textfield(%$day_conf)
	   : $q->popup_menu(-name => $day_conf->{-name},
			    -values => [($day_conf->{'use_undef'}
					 ? (defined $day_conf->{'undef_val'}
					    ? $day_conf->{'undef_val'} : '00')
					 : ()),
					'01'..'31'],
			    -default => ($day_conf->{-default}
					 ? $day_conf->{-default}
					 : ($day_conf->{'use_undef'}
					    ? (defined $day_conf->{'undef_val'}
					       ? $day_conf->{'undef_val'}:'00')
					    : $cur_day)),
			    -override => $day_conf->{-override},
			    ($day_conf->{-disabled} ? (-disabled) : ()),
			   ))) .
       ($year_conf->{'not_shown'} ? ''
	: ($year_conf->{'no_popup'}
	   ? $q->textfield(%$year_conf, -size => 4, -maxlength => 4)
	   : $q->popup_menu(-name => $year_conf->{-name},
			    -values => (ref $year_conf->{-values} eq "ARRAY"
					? $year_conf->{-values}
					: [($year_conf->{'use_undef'}
					    ? (defined $year_conf->{'undef_val'}
					       ? $year_conf->{'undef_val'}:'0000')
					    : ()),
					   ($year_conf->{'presetvalue'}
					    ? $year_conf->{'presetvalue'}
					    : $cur_yr - (defined $year_conf->{'prerange'}
							 ? $year_conf->{'prerange'}
							 : 10)) ..
					   ($year_conf->{'postsetvalue'}
					    ? $year_conf->{'postsetvalue'}
					    : $cur_yr + (defined $year_conf->{'postrange'}
							 ? $year_conf->{'postrange'}
							 : 10))
					  ]),
			    -default => ($year_conf->{-default}
					 ? $year_conf->{-default} : $cur_yr),
			    -override => $year_conf->{-override},
			    ($year_conf->{-disabled} ? (-disabled) : ()),
			   )))
      );
}


1;
__END__

=head1 AUTHOR

Adi Fairbank <adi@adiraj.org>

=head1 COPYRIGHT

Copyright (c) 2004 - Adi Fairbank

This software, the CGI::Widget::FilloutForm::Base Perl module,
is copyright Adi Fairbank.

=head1 LICENSE

This module is free software; you can redistribute it and/or modify it
under the terms of either:

  a) the GNU General Public License as published by the Free Software
     Foundation; either version 1, or (at your option) any later version,

  or

  b) the "Artistic License" which comes with this module.

=head1 LAST MODIFIED

April 01, 2004

=cut
