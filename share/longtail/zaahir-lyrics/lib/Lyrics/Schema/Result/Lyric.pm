package Lyrics::Schema::Result::Lyric;

use DBIx::Class::Candy -autotable => v1;

column id => {
    data_type => 'integer',
    is_auto_increment => 1,
};

column song_name => {
    data_type => 'text',
    is_nullable => 0,
};

column artist_name => {
    data_type => 'text',
    is_nullable => 0,
};

column words => {
    data_type => 'text',
    is_nullable => 0,
};

primary_key 'id';

# column artist_id => {
#     data_type => 'text',
#     is_nullable => 0,
# };

# column song_id => {
#     data_type => 'text',
#     is_nullable => 0,
# };

# belongs_to songs => 'Lyrics::Schema::Result::Song', 'id';
# belongs_to artist => 'Lyrics::Schema::Result::Artist', 'id';

1;
