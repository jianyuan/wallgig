require 'spec_helper'

describe "forums/index" do
  before(:each) do
    assign(:forums, [
      stub_model(Forum,
        :group => nil,
        :name => "Name",
        :slug => "Slug",
        :description => "MyText",
        :position => 1
      ),
      stub_model(Forum,
        :group => nil,
        :name => "Name",
        :slug => "Slug",
        :description => "MyText",
        :position => 1
      )
    ])
  end

  it "renders a list of forums" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
