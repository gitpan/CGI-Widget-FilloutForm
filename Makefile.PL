use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => "CGI::Widget::FilloutForm",
  VERSION_FROM => "lib/CGI/Widget/FilloutForm.pm",
  'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" }
);
