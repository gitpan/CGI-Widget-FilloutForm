package CGI::Widget::FilloutForm;

require 5.004;
use strict;

# COPYRIGHT
#
# Copyright (c) 2004 - Adi Fairbank
#
# This software, the CGI::Widget::FilloutForm Perl module,
# is copyright Adi Fairbank
#
# LICENSE
#
# Perl Artistic License / GPL - see below, pod

use base qw(CGI::Widget::FilloutForm::Base);
use vars qw($VERSION);
$CGI::Widget::FilloutForm::VERSION = "0.14";

# --------------------- USER CUSTOMIZABLE VARIABLES ------------------------

use constant DEFAULT_FIELDS =>
  [ qw(first_name last_name organization address1 address2
       city state country postalcode phone phone2 fax e_mail) ];
use constant DEFAULT_LABELS =>
  { first_name => "First name", last_name => "Last name",
    organization => "Organization",
    address1 => "Address", address2 => "Address (line 2)",
    city => "City", state => "State", country => "Country",
    postalcode => "Postal Code", phone => "Phone", phone2 => "Secondary Phone",
    fax => "Fax", e_mail => "E-mail Address" };

# --------------------- END USER CUSTOMIZABLE VARIABLES --------------------

sub initialize {
    my ($self) = @_;
    $self->{form_name} = $self->{document_title} = "FilloutForm";
    $self->{form_submitbtn_name} = 'submit';
    $self->{form_submitbtn_title} = 'Submit';
    $self->{form_cancelbtn_title} = 'Cancel';
    $self->{fields} = DEFAULT_FIELDS;
    $self->{label} = DEFAULT_LABELS;
    $self->{field_size}->{state} = 4;
    $self->{field_maxlength}->{state} = 4;
    $self->{popup_pair}->{state} = 1;
    $self->{default_value}->{country} = "US";
}

=head1 NAME

CGI::Widget::FilloutForm - HTML fillout form widget

=head1 SYNOPSIS

  use CGI::Widget::FilloutForm;

  $wff = CGI::Widget::FilloutForm->new(q => CGI->new);

  # configure fillout form
  $wff->document_title("My fillout form");
  $wff->form_name("myForm");  # set <form> name
  $wff->form_submitbtn_name('submit');
  $wff->form_submitbtn_title('Submit');
  $wff->form_header("<i>...header...</i><hr>");
  $wff->form_footer("<hr><i>...footer...</i>");
  $wff->star_required_fields(1); # star required fields, not optional ones

  # customize list of fields
  $wff->fields([qw(first_name last_name organization address1 address2
                   city state country postalcode phone phone2 fax),
                undef, qw(e_mail)]);
  $wff->label('phone', "Day Phone");
  $wff->label('phone2', "Night Phone");
  $wff->required_field
    ({ first_name => 1, last_name => 1, address1 => 1, city => 1, state => 1,
       country => 1, postalcode => 1, phone => 1, e_mail => 1 });

  # set values for State and Country popups
  $wff->popup_values('state', \@states);
  $wff->popup_labels('state', \%state_codes);
  $wff->popup_values('country', \@country_list);
  $wff->popup_labels('country', \%countries);

  $wff->handler();


  # -- OR -- (currently the preferred usage for real-world use)
  # subclass CGI::Widget::FilloutForm and override methods
  $wff = MyFilloutForm->new(q => CGI->new);
  $wff->initialize();
  $wff->handler();

  package MyFilloutForm;
  use base qw(CGI::Widget::FilloutForm);

  sub initialize { "configure fillout form ..." }
  sub process_form { "process fillout form ..." }
  1;

  # -- OR -- hack the source code to your liking

=head1 DESCRIPTION

Encapsulates an HTML fill-out form in a Perl class, with customizable
field names, lengths, types, labels, etc.  Provides built-in functionality
for verifying that required fields have been filled out, a summary page
which shows all data entered, and customizable form headers/footers and
informational messages.

Can be used as a standalone widget, or can be subclassed with overridden
methods and/or called by method to generate forms within a pre-existing
application.

=head1 ACCESSORS

In practice, accessors will be used for configuration.

=over 4

=item form_name([ $name ])

Get or set the HTML <FORM> name attribute. (default: "FilloutForm")

=item form_submitbtn_name([ $name ])

Get or set the HTML <FORM> submit button name attribute. (default: "submit")

=item form_submitbtn_title([ $title ])

Get or set the HTML <FORM> submit button value attribute. (default: "Submit")

=item form_cancelbtn_name([ $name ])

Get or set the HTML <FORM> submit (cancel) button name attribute.
(default: <no cancel button>)

=item form_cancelbtn_title([ $title ])

Get or set the HTML <FORM> submit (cancel) button value attribute.
(default: "Cancel")

=item cancelbtn_first([ 0|1 ])

Get or set boolean to set whether to show cancel button before submit.
(default: 0)

=item document_title([ $title ])

Get or set the HTML <HEAD><TITLE> attribute. (default: "FilloutForm")

=item preform_msg([ $msg ])

Get or set a message to be displayed before the fillout form is shown.

=item summary_page([ 0|1 ])

Get or set boolean to toggle whether to automatically display a summary
page of filled out form contents.

=item summary_confirm_msg([ $msg ])

Get or set a message to be displayed immediately before the final submit
button on the summary page.  This option has no effect unless summary_page()
is enabled.

=item form_header([ $html_header ])

Get or set an HTML header to be displayed on all fillout form pages.
If this is set for a form, it causes the form document_title not to be
shown on the top of the page (it is still shown in the HTML <title>).

=item form_footer([ $html_footer ])

Get or set an HTML footer to be displayed on all fillout form pages.

=item fields([ \@fields ])

Get or set field names (CGI name parameters).  An undef in @fields will
produce a blank line to separate the fields above from those below.

=item label([ \%label ])

Get or set field labels.

=item required_field([ \%required_field ])

Get or set boolean hash of which fields required.

=item star_required_fields([ 0|1 ])

Get or set boolean to toggle whether required fields are starred (*)
or optional fields are. (default: 0 - optional fields starred)

=item field_size([ \%field_size ])

Get or set field form input box sizes.

=item field_maxlength([ \%field_maxlength ])

Get or set field form input box maxlengths.

=item password_field([ \%password_fields ])

Get or set boolean hash of fields which should be displayed as password boxes.

=item date_field([ \%date_fields ])

Get or set boolean hash of fields which should be displayed as date widgets.
(ie. Month, Day, Year)

=item date_field_conf([ \%date_field_conf ])

Get or set hash of date widget field configuration.  This controls how a
date widget is displayed.  It should be an arrayref of three hashrefs as
follows:

 [# first hashref controls Month popup-menu behavior
  {
   -name => 'cgi_param', # CGI param() name
   -default => 'def_val',# CGI -default value
   -override => '0'|'1', # CGI -override value (whether to force default value)
   no_popup => '0'|'1',  # boolean toggle whether a popup or textfield is shown
   not_shown => '0'|'1', # boolean toggle whether is shown at all
   },
  # second hashref controls Day popup-menu behavior
  {
   -name => 'cgi_param', # CGI param() name
   -default => 'def_val',# CGI default value
   -override => '0'|'1', # CGI -override value (whether to force default value)
   no_popup => '0'|'1',  # boolean toggle whether a popup or textfield is shown
   not_shown => '0'|'1', # boolean toggle whether is shown at all
   },
  # third hashref controls Year popup-menu behavior
  {
   -name => 'cgi_param', # CGI param() name
   -default => 'def_val',# CGI default value
   -override => '0'|'1', # CGI -override value (whether to force default value)
   no_popup => '0'|'1',  # boolean toggle whether a popup or textfield is shown
   not_shown => '0'|'1', # boolean toggle whether is shown at all

   # first year value in popup (ignored if no_popup set)
   presetvalue => 'beg_yr_val',
   # last year value in popup (ignored if no_popup set)
   postsetvalue => 'end_yr_val',
   # number of years before now to start at in year popup
   # (ignored if either no_popup or presetvalue is set)
   prerange => 'num_yrs',
   # number of years after now to start at in year popup
   # (ignored if either no_popup or postsetvalue is set)
   postrange => 'num_yrs',

   # Note: if none of {pre,post}setvalue nor {pre,post}range are given,
   #  default behavior is prerange => 10, postrange => 10
   },
 ]

=item default_value([ \%default_value ])

Get or set default values for form input boxes.

=item popup_values([ \%popup_values ])

Get or set popup-menu values for field.  If this and popup_labels() are
both defined for a field name, will show a popup-menu instead of a text
input box.

=item popup_labels([ \%popup_labels ])

Get or set popup-menu labels for field.  If this and popup_values() are
both defined for a field name, will show a popup-menu instead of a text
input box.

=item popup_pair([ \%popup_pair ])

Get or set boolean hash of which fields to use a "popup-pair."
A popup-pair is a popup-menu followed by a text input box where any
value chosen in the popup-menu is copied to the text input box
(via JavaScript).

=back

=cut

sub form_name { $_[0]->{form_name} = $_[1] if $_[1]; $_[0]->{form_name}; }
sub form_submitbtn_name { $_[0]->{form_submitbtn_name} = $_[1] if $_[1]; $_[0]->{form_submitbtn_name}; }
sub form_submitbtn_title { $_[0]->{form_submitbtn_title} = $_[1] if $_[1]; $_[0]->{form_submitbtn_title}; }
sub form_cancelbtn_name { $_[0]->{form_cancelbtn_name} = $_[1] if $_[1]; $_[0]->{form_cancelbtn_name}; }
sub form_cancelbtn_title { $_[0]->{form_cancelbtn_title} = $_[1] if $_[1]; $_[0]->{form_cancelbtn_title}; }
sub cancelbtn_first { $_[0]->{cancelbtn_first} = $_[1] if $_[1]; $_[0]->{cancelbtn_first}; }
sub document_title { $_[0]->{document_title} = $_[1] if $_[1]; $_[0]->{document_title}; }
sub preform_msg { $_[0]->{preform_msg} = $_[1] if $_[1]; $_[0]->{preform_msg}; }
sub summary_page { $_[0]->{summary_page} = $_[1] if $_[1]; $_[0]->{summary_page}; }
sub summary_confirm_msg { $_[0]->{summary_confirm_msg} = $_[1] if $_[1]; $_[0]->{summary_confirm_msg}; }
sub form_header { $_[0]->{form_header} = $_[1] if $_[1]; $_[0]->{form_header}; }
sub form_footer { $_[0]->{form_footer} = $_[1] if $_[1]; $_[0]->{form_footer}; }
sub star_required_fields { $_[0]->{star_required_fields} = $_[1] if $_[1]; $_[0]->{star_required_fields}; }

sub fields { $_[0]->{fields} = $_[1] if ref $_[1] eq "ARRAY"; $_[0]->{fields}; }

sub label {
    if (ref $_[1] eq "HASH") { $_[0]->{label} = $_[1]; }
    elsif ($_[1]) { $_[0]->{label}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{label}; }
}
sub required_field {
    if (ref $_[1] eq "HASH") { $_[0]->{required_field} = $_[1]; }
    elsif ($_[1]) { $_[0]->{required_field}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{required_field} };
}
sub field_size {
    if (ref $_[1] eq "HASH") { $_[0]->{field_size} = $_[1]; }
    elsif ($_[1]) { $_[0]->{field_size}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{field_size}; }
}
sub field_maxlength {
    if (ref $_[1] eq "HASH") { $_[0]->{field_maxlength} = $_[1]; }
    elsif ($_[1]) { $_[0]->{field_maxlength}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{field_maxlength}; }
}
sub password_field {
    if (ref $_[1] eq "HASH") { $_[0]->{password_field} = $_[1]; }
    elsif ($_[1]) { $_[0]->{password_field}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{password_field}; }
}
sub date_field {
    if (ref $_[1] eq "HASH") { $_[0]->{date_field} = $_[1]; }
    elsif ($_[1]) { $_[0]->{date_field}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{date_field}; }
}
sub date_field_conf {
    if (ref $_[1] eq "HASH") { $_[0]->{date_field_conf} = $_[1]; }
    elsif ($_[1]) { $_[0]->{date_field_conf}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{date_field_conf}; }
}
sub default_value {
    if (ref $_[1] eq "HASH") { $_[0]->{default_value} = $_[1]; }
    elsif ($_[1]) { $_[0]->{default_value}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{default_value}; }
}
sub popup_values {
    if (ref $_[1] eq "HASH") { $_[0]->{popup_values} = $_[1]; }
    elsif ($_[1]) { $_[0]->{popup_values}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{popup_values}; }
}
sub popup_labels {
    if (ref $_[1] eq "HASH") { $_[0]->{popup_labels} = $_[1]; }
    elsif ($_[1]) { $_[0]->{popup_labels}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{popup_labels}; }
}
sub popup_pair {
    if (ref $_[1] eq "HASH") { $_[0]->{popup_pair} = $_[1]; }
    elsif ($_[1]) { $_[0]->{popup_pair}->{$_[1]} = $_[2] if defined $_[2]; }
    else { $_[0]->{popup_pair}; }
}


=head1 METHODS

Most methods are only called internally, so you only need to know what
they do if you intend to subclass and override them.  Some you will most
definitely need to override, such as process_form(), since they do not
currently do anything.

=over 4

=item handler()

Top-level control handler.

=item show_msg_page( $text )

Show a generic message page with the message "$text".  Prints page to stdout.

=item show_preform_msg_page()

Show a page with a message on it to be read by the user before they
can see the form (if defined by preform_msg() accessor).
Prints page to stdout.

=item show_form_input_page()

Show the actual fillout-form.  Prints page to stdout.

=item show_form_summary_page()

Show a summary page of all the form contents filled out.
Prints page to stdout.

=item show_form()

Generates the form.  Called by show_form_input_page() and
show_form_summary_page().

=item form_ok()

Verify the form satisfies all requirements such as required fields:
returns 1 if so, 0 otherwise.  Called by handler() before user is allowed
to proceed from the form input page.

=item unfilled_fields()

Return the number of unfilled fields in the form after is has been submitted.

=item merge_date_fields()

Merge year, month, day popup menu cgi values into a single date in
YYYY-MM-DD format.

=item process_form()

Method to take action on the form after its successful completion and
submittal.  This is meant to be overridden by YOU.  (right now it just
proclaims some thanks to the user who entered the data)

=item in_box([ $text, $bordercolor, $trnl, $tblwid ])

Return "$text" in a nicely formatted HTML table with a colored border.
If $trnl is set, newlines ("\n") in $text will be transmuted to "<br>".
Set $tblwid to the width of the table, in pixels. (default $tblwid: 100)

=item input_field( $param )

Generate the proper HTML for an input field, based on what kind of field
it is and other configuration options.  $param is a name of one of your
fields().

=cut

sub handler {
    my ($self) = @_;
    my $q = $self->{q};

    if ($self->{form_cancelbtn_name} and
	$q->param($self->{form_cancelbtn_name})) {
	$self->show_msg_page("Cancelled");
    } elsif ($q->param($self->{form_submitbtn_name}) and $self->form_ok) {
	if ($self->{summary_page}) {
	    $self->show_form_summary_page;
	} else {
	    $self->process_form;
	}
    } elsif ($self->{preform_msg} and !$q->param('next') and
	     !$q->param($self->{form_submitbtn_name})) {
	$self->show_preform_msg_page;
    } else {
	$self->show_form_input_page;
    }
}

sub show_msg_page {
    my ($self, $text) = @_;
    my $q = $self->{q};
    print ($q->header(-Cache_Control => 'no-cache') .
	   $q->start_html(-title => $self->{document_title}) .
	   $q->h1($self->{document_title}) . $q->p($text) . $q->end_html);
}

sub show_preform_msg_page {
    my ($self) = @_;
    my $q = $self->{q};
    print ($q->header(-Cache_Control => 'no-cache') .
	   $q->start_html(-title => $self->{document_title}) .
	   ($self->{form_header} ? $self->{form_header}
	    : $q->h1($self->{document_title})) .
	   $q->p($self->{preform_msg}) .
	   $q->start_form .
	   $q->submit(-name => 'next', -value => "Continue >>") .
	   $self->{form_footer} . $q->end_form . $q->end_html);
}

sub show_form {
    my ($self) = @_;
    my $q = $self->{q};
    return (($self->{form_header} ? $self->{form_header}
	     : $q->h1($self->{document_title})) .
	    $q->table
	    ({-align => 'center', -border => 0, -cellpadding => 0}, $q->Tr
	     ([
	       (map { $self->input_field($_) } @{$self->{fields}}),
	       (scalar(grep(defined $_ && $_ && $self->{required_field}->{$_},
			    keys %{$self->{required_field}})) <
		scalar(grep(defined $_, @{$self->{fields}}))
		? $q->td({-colspan => 2}, $self->{star_required_fields}
			 ? "* = Required field" : "* = Optional information")
		: ()),
	       ($q->param($self->{form_submitbtn_name}) &&
		$self->unfilled_fields && !$self->{summary_mode}
		? $q->td({-colspan => 2}, $q->br.
			 $q->font({-color => 'red'},
				  "Please fill in all required fields."))
		: ()),
	       $q->td({-colspan => 2}, '&nbsp;'),
	       ($self->{summary_mode} && $self->{summary_confirm_msg}
		? ($q->td({-colspan => 2}, $self->{summary_confirm_msg}),
		   $q->td({-colspan => 2}, '&nbsp;'))
		: ()),
	       $q->td({-align => 'center', -colspan => 2},
		      ($self->{form_cancelbtn_name} && $self->{cancelbtn_first}
		       ? $q->submit(-name => $self->{form_cancelbtn_name},
				    -value => $self->{form_cancelbtn_title})
		       : '') .
		      $q->submit(-name => $self->{form_submitbtn_name},
				 -value => $self->{form_submitbtn_title}) .
		      ($self->{form_cancelbtn_name} &&!$self->{cancelbtn_first}
		       ? $q->submit(-name => $self->{form_cancelbtn_name},
				    -value => $self->{form_cancelbtn_title})
		       : '')
		     ),
	      ])) .
	    $self->{form_footer});
}

sub show_form_input_page {
    my ($self) = @_;
    my $q = $self->{q};
    print ($q->header(-Cache_Control => 'no-cache') .
	   $q->start_html(-title => $self->{document_title}) .
	   $q->start_form(-name => $self->{form_name}) .
	   $self->show_form . $q->end_form . $q->end_html);
}

sub show_form_summary_page {
    my ($self) = @_;
    my $q = $self->{q};
    $self->{summary_mode} = 1;
    print ($q->header(-Cache_Control => 'no-cache') .
	   $q->start_html(-title => $self->{document_title}) .
	   $q->start_form(-name => $self->{form_name}) .
	   $self->show_form . $q->end_form . $q->end_html);
}

sub form_ok {
    return !$_[0]->unfilled_fields;
}

sub unfilled_fields {
    my ($self) = @_;
    my $q = $self->{q};
    my $unfld_reqd = 0;
    foreach (@{$self->{fields}}) {
	if (defined $_ and $self->{required_field}->{$_} and !$q->param($_)) {
	    $unfld_reqd++;
	    $self->{unfilled_fields} = []
	      unless ref $self->{unfilled_fields} eq "ARRAY";
	    push(@{$self->{unfilled_fields}}, $_);
	}
    }
    return $unfld_reqd;
}

sub merge_date_fields {
    my ($self) = @_;
    return unless ref $self->{date_field} eq "HASH";
    foreach my $param (keys %{$self->{date_field}}) {
	$self->{q}->param
	  ($param, join('-', grep(defined $_,
				  $self->{q}->param($param.'_year'),
				  $self->{q}->param($param.'_mon'),
				  $self->{q}->param($param.'_day'))));
    }
}

sub process_form {
    my ($self) = @_;
    my $q = $self->{q};
    print ($q->header(-Cache_Control => 'no-cache') .
	   $q->start_html(-title => $self->{document_title}) .
	   $q->h1("Thank you for your input!") . $q->end_html);
}

sub in_box {
    my ($self, $text, $bordercolor, $trnl, $tblwid) = @_;
    my $q = $self->{q};
    $text = '&nbsp;' unless $text;
    $text =~ s/\n/<br>/g if $trnl;
    $bordercolor = '#3366ff' unless $bordercolor;
    $tblwid = 100 unless $tblwid;
    return $q->table
      ({-bgcolor => $bordercolor, -cellpadding => 0,
	-cellspacing => 1, -width => $tblwid}, $q->Tr
       ($q->td
	($q->table({-bgcolor => "#e0e0e0", -width => '100%'},
		   $q->Tr($q->td({-nowrap => 1}, $q->b($text))))
	)));
}

sub input_field {
    my ($self, $param) = @_;
    my $q = $self->{q};
    my ($desc, $reqd, $size, $max, $passwd, $datefld, $datefldcf, $default,
	$popupvals, $popuplabels, $double) = map { $self->{$_}->{$param} }
	  qw(label required_field field_size field_maxlength password_field
	     date_field date_field_conf default_value
	     popup_values popup_labels popup_pair);
    my $submitted = $q->param($self->{form_submitbtn_name});

    return
      ($q->td({-align => 'right'},
	      defined $param
	      ? ($reqd && $submitted && !$q->param($param)
		 ? $q->font({-color => 'red'}, "$desc:".
			    (($reqd xor $self->{star_required_fields})
			     ? ' ' : '* '))
		 : "$desc:".(($reqd xor $self->{star_required_fields})
			     ? ' ' : '* '))
	      : '&nbsp;') .
       $q->td(!defined $param
	      ? '&nbsp;'
	      : $self->{summary_mode}
	      ? ($q->hidden(-name => $param) .
		 ($datefld
		  ? join('', map {$q->hidden(-name => $param.$_)}
			 qw(_year _mon _day))
		  : '') .
		 $self->in_box($q->param($param)))
	      : $popupvals && $popuplabels
	      ? ($double
		 ? ($q->popup_menu(-name => $param."_popup",
				   ($default ? (-default => $default)
				    : $q->param($param)
				    ? (-default => $q->param($param)) : ()),
				   ($default ? (-values => $popupvals)
				    : (-values => ['', @$popupvals])),
				   ($default ? (-labels => $popuplabels)
				    : (-labels => {'' => '<Select>',
						   %$popuplabels})),
				   -onchange => "document.".$self->{form_name}.".$param.value=document.".$self->{form_name}.".${param}_popup.options[document.".$self->{form_name}.".${param}_popup.selectedIndex].value") .
		    $q->textfield(-name => $param,
				  ($size ? (-size => $size) : ()),
				  ($max ? (-maxlength => $max) : ()),
				  ($default ? (-default => $default) : ())))
		 : $q->popup_menu(-name => $param,
				  ($default ? (-values => $popupvals)
				   : (-values => ['', @$popupvals])),
				  ($default ? (-labels => $popuplabels)
				   : (-labels => {'' => '<Select>',
						  %$popuplabels})),
				  ($default ? (-default => $default) : ())))
	      : $passwd
	      ? $q->password_field(-name => $param,
				   ($size ? (-size => $size) : ()),
				   ($max ? (-maxlength => $max) : ()),
				   ($default ? (-value => $default) : ()))
	      : $datefld
	      ? $self->display_date_entry
	      ((ref $datefldcf eq "ARRAY" && ref $datefldcf->[0] eq "HASH"
		? $datefldcf->[0] : {-name => $param.'_mon'}),
	       (ref $datefldcf eq "ARRAY" && ref $datefldcf->[1] eq "HASH"
		? $datefldcf->[1] : {-name => $param.'_day'}),
	       (ref $datefldcf eq "ARRAY" && ref $datefldcf->[2] eq "HASH"
		? $datefldcf->[2] : {-name => $param.'_year'}))
	      : $q->textfield(-name => $param,
			      ($size ? (-size => $size) : ()),
			      ($max ? (-maxlength => $max) : ()),
			      ($default ? (-default => $default) : ()))
	     ));
}


1;
__END__

=head1 AUTHOR

Adi Fairbank <adi@adiraj.org>

=head1 COPYRIGHT

Copyright (c) 2004 - Adi Fairbank

This software, the CGI::Widget::FilloutForm Perl module,
is copyright Adi Fairbank.

=head1 COPYLEFT (LICENSE)

This module is free software; you can redistribute it and/or modify it
under the terms of either:

  a) the GNU General Public License as published by the Free Software
     Foundation; either version 1, or (at your option) any later version,

  or

  b) the "Artistic License" which comes with this module.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See either the GNU General Public
License or the Artistic License for more details.

You should have received a copy of the Artistic License with this module,
in the file ARTISTIC; if not, the following URL references a copy of it
(as of June 8, 2003):

  http://www.perl.com/language/misc/Artistic.html

You should have received a copy of the GNU General Public License along
with this program, in the file GPL; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA;
or try the following URL which references a copy of it (as of June 8, 2003):

  http://www.fsf.org/licenses/gpl.html

=head1 LICENSE

Licensing terms must be negotiated directly with the author.

=head1 LAST MODIFIED

Apr 01, 2004

=cut
