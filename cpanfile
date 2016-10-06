requires 'perl';
requires 'App::Cmd';
requires 'JSON';
requires 'LWP::Simple';
requires 'LWP::Protocol::https';
requires 'Term::ANSIColor';
requires 'Encode';
requires 'Locale::Messages';
requires 'Locale::TextDomain';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
