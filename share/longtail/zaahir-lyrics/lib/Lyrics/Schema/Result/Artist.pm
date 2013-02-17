package Lyrics::Schema::Result::Artist;

use DBIx::Class::Candy -autotable => v1;

column id => {
    data_type => 'integer',
    is_auto_increment => 1,
};

primary_key 'id';

column name => {
    data_type => 'text',
    is_nullable => 0,
};

has_many songs => 'Lyrics::Schema::Result::Song', 'id';

1;