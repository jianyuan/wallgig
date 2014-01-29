require 'spec_helper'

describe "forum_topics/show" do
  before(:each) do
    @forum_topic = assign(:forum_topic, stub_model(ForumTopic,
      :forum => nil,
      :user => nil,
      :title => "Title",
      :content => "MyText",
      :cooked_content => "MyText",
      :pinned => false,
      :locked => false,
      :hidden => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
  end
end
