require 'spec_helper'

# todo: use mocks everywhere

RSpec.describe Yotsuba do

  it 'has a version number' do
    expect(Yotsuba::VERSION).to_not be_nil
  end

  it 'has a Serial number defined' do
    expect(Yotsuba::Serial).to_not be_nil, ->{ "Yotsuba::Serial is undefined. Make sure that the environment variable $DOMDOM_KEY is set." }
  end

  it 'can connect to the WSDL' do
    expect{Yotsuba.setup_savon}.to_not raise_error
  end

  it 'can get animes' do
    expect(Yotsuba.get_animes).to eq(true)
  end

end

RSpec.describe "Yotsuba::Anime Class" do

  subject { Yotsuba::Anime }

  it { should respond_to(:clear_anime_list!) }
  it { should respond_to(:all) }
  it { should respond_to(:[]) }

  it "can clear the anime list" do
    Yotsuba.get_animes
    expect{
      Yotsuba::Anime.clear_anime_list!
    }.to change{
      Yotsuba::Anime.class_variable_get(:@@all_animes)
    }.to([])
  end

  it "returns a non-empty array from all" do
    expect(Yotsuba::Anime.all).to_not be_empty
  end

  it "returns an Array when its [] method is given a Regexp" do
    expect(Yotsuba::Anime[/.+/].is_a?(Array)).to eq(true)
  end

  it "returns a Yotsuba::Anime when its [] method is given a Fixnum" do
    expect(Yotsuba::Anime[1].is_a?(Yotsuba::Anime)).to eq(true)
  end

  it "returns a Yotsuba::Anime when its [] method is given a String" do
    expect(Yotsuba::Anime["Sword Art Online"].is_a?(Yotsuba::Anime)).to eq(true)
  end

end

RSpec.describe "Yotsuba::Anime Instance" do

  subject(:anime){ Yotsuba::Anime.all.first }
  let(:empty_anime){ Yotsuba::Anime.new() }

  it { should respond_to(:id) }
  it { should respond_to(:title) }
  it { should respond_to(:num_files) }
  it { should respond_to(:files) }
  it { should respond_to(:valid?) }


  it 'can get files' do
    expect(anime.files).to_not be_empty
  end

  it 'can get files when it only has one file' do
    anime = Yotsuba::Anime["5 Centimeters per Second"]
    expect(anime.files).to_not be_empty
  end

  it 'is invalid when empty' do
    expect(empty_anime).to_not be_valid
  end

  it 'is valid when not empty' do
    expect(anime).to be_valid
  end

  it 'is not added to the anime list when invalid' do
    expect {
      empty_anime
    }.to_not change{
      Yotsuba::Anime.all.length
    }
  end

  # todo: test find, find_by

end

RSpec.describe Yotsuba::AnimeFile do

  let(:file){ Yotsuba::Anime.all.first.files.first }

  attr_reader :id, :name, :size, :first_downloaded, :times_downloaded, :anime_id
  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:size) }
  it { should respond_to(:first_downloaded) }
  it { should respond_to(:times_downloaded) }
  it { should respond_to(:anime_id) }
  it { should respond_to(:anime) }
  it { should respond_to(:download_links) }

  it "gives an anime with the same id as its anime_id" do
    expect(file.anime.id).to eq(file.anime_id)
  end

  it "returns an array from download_links" do
    expect(file.download_links.is_a?(Array)).to eq(true)
  end

  it "returns an array containing only strings from download_links" do
    file.download_links.each do |link|
      expect(link.is_a?(String)).to eq(true)
    end
  end
end

RSpec.describe Yotsuba::Download do

  it "returns an array from all" do
    expect(Yotsuba::Download.all.is_a?(Array)).to eq(true)
  end

  context "after creating two downloads" do

    before do
      @anime ||= Yotsuba::Anime.all.first
      @first_download ||= @anime.files.first.download('tmp')
      @second_download ||= @anime.files.first.download('tmp')
    end

    it "returns an array including the first of those downloads from all" do
      expect(Yotsuba::Download.all).to include(@first_download)
    end

    it "returns an array including the first of those downloads from all" do
      expect(Yotsuba::Download.all).to include(@second_download)
    end

  end

  # todo: test find, find_by, and []

end

RSpec.describe "Yotsuba::Download Instance" do

  # todo: better download specs

  let(:file){ Yotsuba::Anime["Sword Art Online"].files.last } # 33MB File
  subject(:download){ file.download('tmp') }

  it { should be_valid }

  it "starts out with a bytes_written of 0" do
    expect(download.bytes_written).to eq(0)
  end

  it "starts out with a percent_downloaded of 0" do
    expect(download.percent_downloaded).to eq(0)
  end

  it "starts out with a status of 'Queued'" do
    expect(download.status).to eq('Queued')
  end

  it "has a matching file as its parent file" do
    expect(download.file).to eq(file)
  end

  context "without any initial values" do

    subject(:download){ Yotsuba::Download.new() }

    it { should_not be_valid }

    it "should not have been added to the all downloads list" do
      expect(Yotsuba::Download.all).to_not include(download)
    end

  end

end
