require 'rails_helper'

describe WikiBot, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "creates a new wikibot" do
    expect(WikiBot.all.count).to eq 0

    terdzod = WikiBot.create(site_url: 'http://terdzod.tsadra.org/api.php')

    expect(WikiBot.all.count).to eq 1
    expect(WikiBot.all      ).to eq [terdzod]
  end

  it "is valid with a site url" do
    wikibot = WikiBot.new(site_url: 'example-url')

    expect(wikibot).to be_valid
  end

  it "creates new wiki pages" do
    # wikibot = WikiBot.new(site_url: 'example-url')
    # wikibot.create_pages(files)
  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(WikiBot.new).to respond_to(:create_pages) }
    end

    context "executes methods correctly" do
      context "#create_pages" do
        it "does what it's supposed to..." do
          # expect(factory_instance.method_to_test).to eq(value_you_expect)
        end
      end
    end
  end
end
