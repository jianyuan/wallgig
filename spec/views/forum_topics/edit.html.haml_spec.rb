require 'spec_helper'

describe "forum_topics/edit" do
  before(:each) do
    @forum_topic = assign(:forum_topic, stub_model(ForumTopic,
      :forum => nil,
      :user => nil,
      :title => "MyString",
      :content => "MyText",
      :cooked_content => "MyText",
      :pinned => false,
      :locked => false,
      :hidden => false
    ))
  end

  it "renders the edit forum_topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", forum_topic_path(@forum_topic), "post" do
      assert_select "input#forum_topic_forum[name=?]", "forum_topic[forum]"
      assert_select "input#forum_topic_user[name=?]", "forum_topic[user]"
      assert_select "input#forum_topic_title[name=?]", "forum_topic[title]"
      assert_select "textarea#forum_topic_content[name=?]", "forum_topic[content]"
      assert_select "textarea#forum_topic_cooked_content[name=?]", "forum_topic[cooked_content]"
      assert_select "input#forum_topic_pinned[name=?]", "forum_topic[pinned]"
      assert_select "input#forum_topic_locked[name=?]", "forum_topic[locked]"
      assert_select "input#forum_topic_hidden[name=?]", "forum_topic[hidden]"
    end
  end
end
