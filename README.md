# Yotsuba

Yotsuba facilitates getting download links from the DomDomSoft Anime Downloader server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yotsuba'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yotsuba

## Usage

Quick Start

$ export DOMDOM_KEY='your-domdom-key-goes-here'

```ruby
anime = Yotsuba::Anime["Clannad: After Story"]
anime.files # => Array of episode files
episode = anime.files.first # Get the first file from the anime
episode.download_links # => Array of download links (zip parts)
```

Verbose Example
```ruby
Yotsuba.get_animes # explicitly download the anime list. Yotsuba::Anime.all and Yotsuba::Anime[] call this automatically.
Yotsuba::Anime.clear_anime_list! # explicitly clear the anime list. It will be automatically cleared when you use get_animes so there's not often a reason to use this.
Yotsuba::Anime.all # All the Animes. Will remain cached until you redownload the list.

Yotsuba::Anime[123] # Returns the Anime object with id 123.
Yotsuba::Anime["Title"] # Returns the Anime object with title "Title".
Yotsuba::Anime[/Sword/] # Returns an array of all Animes whose titles match the supplied regexp.

anime = Yostuba::Anime["Some Anime"]
anime.files # Returns all the File objects from the anime.
anime.id # => 123
anime.title # => "Some Anime"
anime.num_files # 24
# Note that anime.files requests file info from the server, but anime.num_files does not, so it's faster than anime.files.length

:id, :name, :size, :first_downloaded, :times_downloaded, :anime_id
episode = anime.files.first
episode.id # => 1234
episode.name # => "[Coolsubs] Some Anime Episode 01 [12B4D2].mp4"
episode.size # file size in bytes
episode.first_downloaded # Date object of the first time you downloaded this file
episode.times_downloaded # How many times you have downloaded this file before
episode.anime_id # => 123
episode.anime # Anime object that owns this episode
episode.download_links # Returns array of download links (zip parts)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/yotsuba/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
