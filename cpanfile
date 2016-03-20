requires 'perl';
requires 'App::Cmd';
requires 'LWP::Simple';
requires 'LWP::Protocol::https';
requires 'Term::ANSIColor';
requires 'Encode';
requires 'Locale::TextDomain';


on 'test' => sub {
    requires 'Test::More', '0.98';
};
