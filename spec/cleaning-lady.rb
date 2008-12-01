require File.join(File.dirname(__FILE__), '..', 'lib', 'cleaning-lady.rb')

describe CleaningLady do
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
end
