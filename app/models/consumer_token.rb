require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token

  # You can safely remove this callback if you don't allow login from any of your services
  before_create :create_user

  # Modify this with class_name etc to match your application
  belongs_to :user

  def get_meetup_groups
    #meetupToken=ConsumerToken.find_by_type('MeetupToken')
    q=self.client.get('https://api.meetup.com/2/groups?member_id=self')
    c=JSON.parse q.body
    return c['results'].map{|a| [a['name'],a['id']]}
  end
  def post_meetup_event(group_id,name,description)
    #meetupToken=ConsumerToken.find_by_type('MeetupToken') 
    result=self.client.post('https://api.meetup.com/2/groups',{:group_id=>group_id,:name=>name,:description=>description}) 
    puts "Results: #{result.code}"
    return result
  end

end
