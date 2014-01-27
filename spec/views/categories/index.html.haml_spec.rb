require 'spec_helper'

describe "categories/index" do
  before(:each) do
    assign(:categories, [
      stub_model(Category,
        :name => "Name",
        :slug => "Slug",
        :wikipedia_title => "Wikipedia Title",
        :description => "MyText",
        :ancestry => "Ancestry"
      ),
      stub_model(Category,
        :name => "Name",
        :slug => "Slug",
        :wikipedia_title => "Wikipedia Title",
        :description => "MyText",
        :ancestry => "Ancestry"
      )
    ])
  end

  it "renders a list of categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "Wikipedia Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Ancestry".to_s, :count => 2
  end
end
