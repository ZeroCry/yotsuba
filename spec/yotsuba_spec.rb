require 'spec_helper'

# todo: use mocks everywhere

RSpec.describe Yotsuba do

  it 'has a version number' do
    expect(Yotsuba::VERSION).to_not be_nil
  end

  it 'has a Serial number defined' do
    expect(Yotsuba::Serial).to_not be_nil, ->{ "Yotsuba::Serial is undefined. Make sure that the environment variable $DOMDOM_KEY is set." }
  end

end

RSpec.describe Yotsuba::Messenger do

  it "gets an array from get_animes" do
    expect(Yotsuba::Messenger.get_animes).to be_an(Array)
  end

  it "gets anime-like hashes from get_animes" do
    animes = Yotsuba::Messenger.get_animes
    10.times do |i|
      expect(animes[i]).to include({
        id: be_an(Integer),
        title: be_a(String),
        num_files: be_an(Integer)
      })
    end
  end

  context "given an anime-like object" do

    before do
      @anime ||= instance_double("Yotsuba::Anime", title: "Sword Art Online")
    end

    it "gets an array from get_files" do
      expect(Yotsuba::Messenger.get_files(@anime)).to be_an(Array)
    end

    it "gets episode-like hashes from get_files" do
      files = Yotsuba::Messenger.get_files(@anime)
      files.each do |file|
        expect(file).to include({
          id: be_an(Integer),
          name: be_a(String),
          size: be_an(Integer),
          first_downloaded: be_a(DateTime),
          times_downloaded: be_an(Integer),
          anime: be_an(Object)
        })
      end
    end

    context "given an animefile-like object" do

      before do
        @file ||= instance_double("Yotsuba::AnimeFile", anime: @anime, name: "Sword_Art_Online_Special_01_Offline.mkv")
      end

      it "gets an array from get_download_links" do
        expect(Yotsuba::Messenger::get_download_links(@file)).to be_an(Array)
      end

      it "gets an array of strings from get_download_links" do
        links = Yotsuba::Messenger::get_download_links(@file)
        links.each do |link|
          expect(link).to be_a(String)
        end
      end

    end

  end

end


RSpec.describe Yotsuba::Anime do


  it { should respond_to(:id) }
  it { should respond_to(:title) }
  it { should respond_to(:num_files) }

end

RSpec.describe Yotsuba::AnimeFile do

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:size) }
  it { should respond_to(:first_downloaded) }
  it { should respond_to(:times_downloaded) }
  it { should respond_to(:anime) }

end

RSpec.describe Yotsuba::Download do

  # todo: download specs

end
