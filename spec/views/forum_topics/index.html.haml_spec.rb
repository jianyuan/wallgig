require 'spec_helper'

describe "forum_topics/index" do
  before(:each) do
    assign(:forum_topics, [
      stub_model(ForumTopic,
        :forum => nil,
        :user => nil,
        :title => "Title",
        :content => "MyText",
        :cooked_content => "MyText",
        :pinned => false,
        :locked => false,
        :hidden => false
      ),
      stub_model(ForumTopic,
        :forum => nil,
        :user => nil,
        :title => "Title",
        :content => "MyText",
        :cooked_content => "MyText",
        :pinned => false,
        :locked => false,
        :hidden => false
      )
    ])
  end

  it "renders a list of forum_topics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
