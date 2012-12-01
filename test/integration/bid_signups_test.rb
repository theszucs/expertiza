require 'test_helper'
require 'sign_up_sheet_controller'

class BidSignupsTest < ActionController::IntegrationTest
  fixtures :users, :roles, :teams, :assignments, :nodes, :system_settings, :content_pages, :permissions, :participants
  fixtures :roles_permissions, :controller_actions, :site_controllers, :menu_items, :bids, :sign_up_topics, :teams_users

  def setup
    @controller = SignUpSheetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @student1 = users(:student1)
    @student2 = users(:student1)
    @request.session[:user] = @student1

    @team = teams(:lottery_team1)
    @assignment = assignments(:lottery_assignment)
    @topic = sign_up_topics(:LotteryTopic3)
  end

  # Given I am on the sign up topics page
  # When I press bid
  # Then I should see the notice that my bid has submitted
  # And I should see the topic in my teams bids
  # And I should see a delete icon for that topic
  test "sign up for bid" do
    get :controller=>'sign_up_sheet', :action => :sign_up_topics, :id => @assignment.id
    assert_response :success
    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_nil @bid
    post  :controller=>'sign_up_sheet', :action => 'submit_bid', :id => :LotteryTopic3, :assignment_id => :lottery_assignment
    assert_redirected_to :action => :sign_up_topics, :id=>assignment_id
    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_not_nil @bid

    assert true
  end

  # Given I am on the sign up topics page
  # And my team has 3 bids
  # Then I should see the 3 topics my team has bid on
  test "check for 3 bids" do

    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_nil @bid
    post  :controller=>'sign_up_sheet', :action => 'submit_bid', :id => :LotteryTopic3, :assignment_id => :lottery_assignment
    assert_redirected_to :action => :sign_up_topics, :id=>@assignment.id
    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_not_nil @bid

    assert true
  end

  # Given I am on the sign up topics page
  # And my team has 3 bids
  # When I press bid
  # Then I should should see a notice that says my team has reached max bids
  # And I should see no change in bid topics
  test "stop 4 bids" do
    post :controller=>'sign_up_sheet', :action => :sign_up_topics, :id => @assignment.id
    assert_response :success
    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_nil @bid
    post  :controller=>'sign_up_sheet', :action => 'submit_bid', :id => :LotteryTopic3, :assignment_id => :lottery_assignment
    assert_redirected_to :action => :sign_up_topics, :id=>@assignment.id
    @bid = Bid.find_by_team_id_and_topic_id(@team.id, @topic.id)
    assert_not_nil @bid

    assert true
  end
end