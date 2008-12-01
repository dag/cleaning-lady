require File.join(File.dirname(__FILE__), '..', 'lib', 'cleaning-lady.rb')

describe CleaningLady do
  describe "::SUBSTITUTES" do
    before do
      @substitutes = CleaningLady::SUBSTITUTES
      @substitute = @substitutes.first
    end

    it "should hold the default substitutes" do
      @substitutes.should be_a_kind_of(Hash)
      @substitute[0].should be_a_kind_of(Symbol)
      @substitute[1].should be_a_kind_of(Array)
      @substitute[1][0].should be_a_kind_of(Symbol)
      @substitute[1][1].should be_a_kind_of(Hash)
    end

    it "should be frozen" do
      @substitutes.should be_frozen
    end
  end

  describe "::WHITELIST" do
    before do
      @whitelist = CleaningLady::WHITELIST
      @whitetag = @whitelist.first
    end

    it "should hold the default whitelist" do
      @whitelist.should be_a_kind_of(Hash)
      @whitetag[0].should be_a_kind_of(Symbol)
      @whitetag[1].should be_a_kind_of(Array)
    end

    it "should be frozen" do
      @whitelist.should be_frozen
    end
  end

  describe "::BLACKLIST" do
    before do
      @blacklist = CleaningLady::BLACKLIST
      @blacktag = @blacklist.first
    end

    it "should hold the default blacklist" do
      @blacklist.should be_a_kind_of(Hash)
      @blacktag[0].should be_a_kind_of(Symbol)
      ([Array, NilClass].include? @blacktag[1].class).should be_true
    end

    it "should be frozen" do
      @blacklist.should be_frozen
    end
  end

  describe ".substitutes" do
    before do
      @defaults = CleaningLady::SUBSTITUTES
      @substitutes = CleaningLady.substitutes
    end

    it "should initially equal the default substitutes" do
      @substitutes.should == @defaults
    end

    it "should not be the same object as the default substitutes" do
      @substitutes.object_id.should_not == @defaults.object_id
    end
  end

  describe ".whitelist" do
    before do
      @defaults = CleaningLady::WHITELIST
      @whitelist = CleaningLady.whitelist
    end

    it "should initially equal the default whitelist" do
      @whitelist.should == @defaults
    end

    it "should not be the same object as the default whitelist" do
      @whitelist.object_id.should_not == @defaults.object_id
    end
  end

  describe ".blacklist" do
    before do
      @defaults = CleaningLady::BLACKLIST
      @blacklist = CleaningLady.blacklist
    end

    it "should initially equal the default blacklist" do
      @blacklist.should == @defaults
    end

    it "should not be the same object as the default blacklist" do
      @blacklist.object_id.should_not == @defaults.object_id
    end
  end

  describe "#substitutes" do
    before do
      @defaults = CleaningLady.substitutes
      @substitutes = CleaningLady.new("").substitutes
    end

    it "should initially equal the global substitutes" do
      @substitutes.should == @defaults
    end

    it "should not be the same object as the global substitutes" do
      @substitutes.object_id.should_not == @defaults.object_id
    end
  end

  describe "#whitelist" do
    before do
      @defaults = CleaningLady.whitelist
      @whitelist = CleaningLady.new("").whitelist
    end

    it "should initially equal the global whitelist" do
      @whitelist.should == @defaults
    end

    it "should not be the same object as the global whitelist" do
      @whitelist.object_id.should_not == @defaults.object_id
    end
  end

  describe "#blacklist" do
    before do
      @defaults = CleaningLady.blacklist
      @blacklist = CleaningLady.new("").blacklist
    end

    it "should initially equal the global blacklist" do
      @blacklist.should == @defaults
    end

    it "should not be the same object as the global blacklist" do
      @blacklist.object_id.should_not == @defaults.object_id
    end
  end

  describe "#wellformed" do
    before do
      @lady = CleaningLady.new("<strong>hi<p>foo")
    end

    it "should add missing closing tags" do
      @lady.wellformed.should == "<strong>hi<p>foo</p></strong>"
    end
  end

  describe "#substituted" do
    before do
      @lady = CleaningLady.new("<b>boldly going the wrong way</b>")
    end

    it "should substitute certain tags" do
      @lady.substituted.should == "<strong>boldly going the wrong way</strong>"
    end
  end

  describe "#white" do
    before do
      @lady = CleaningLady.new("<bad>foobar</bad><p>good</p>")
    end

    it "should remove tags that are not white listed" do
      @lady.white.should == "<p>good</p>"
    end
  end

  describe "#black" do
    before do
      @lady = CleaningLady.new("<script>alert('hax');</script><foo>foo!</foo>")
    end

    it "should remove blacklisted tags" do
      @lady.black.should == "<foo>foo!</foo>"
    end
  end
end
