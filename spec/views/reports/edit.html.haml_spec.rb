require 'spec_helper'

describe "reports/edit" do
  before(:each) do
    @report = assign(:report, stub_model(Report,
      :reportable => nil,
      :user => nil,
      :description => "MyText",
      :closed_by => nil
    ))
  end

  it "renders the edit report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", report_path(@report), "post" do
      assert_select "input#report_reportable[name=?]", "report[reportable]"
      assert_select "input#report_user[name=?]", "report[user]"
      assert_select "textarea#report_description[name=?]", "report[description]"
      assert_select "input#report_closed_by[name=?]", "report[closed_by]"
    end
  end
end
