class ScheduleController < ApplicationController
  before_filter :authenticate_user!
  def index
    @meetup_groups=get_meetup_groups
  end
  def schedule_meetup_event
    schedule_time=params['meetup_event_schedule']
    group_id=params['meetup_event_group']['meetup_group_id']
    name=params['meetup_event_name']
    desc=params['meetup_event_description']

    meetupToken=ConsumerToken.find_by_type('MeetupToken')
    meetupToken.client.delay({:run_at => schedule_time}).post('https://api.meetup.com/2/event',{:group_id=>group_id,:name=>name,:description=>desc,:time=>""})
    #delay({:run_at => schedule_time})

    redirect_to :action => :index and return
  end

  def schedule_tweet
    schedule_time=params['tweet_schedule']
    tweet=params['tweet']

    puts "#{schedule_time} #{tweet}"
    
    tweetToken=ConsumerToken.find_by_type('TwitterToken')
    consumer=OAuth::Consumer.new(OAUTH_CREDENTIALS[:twitter][:key],OAUTH_CREDENTIALS[:twitter][:secret],{:site=> "http://api.twitter.com", :scheme=>:header})
    token_hash = {:oauth_token => tweetToken.token, :oauth_token_secret=>tweetToken.secret} 
    
    access_token = OAuth::AccessToken.from_hash(consumer,token_hash)

    access_token.delay({:run_at => schedule_time}).post('https://api.twitter.com/1.1/statuses/update.json',{:status=>tweet})

    redirect_to :action => :index and return
  end

private
  def get_meetup_groups
    meetupToken=ConsumerToken.find_by_type('MeetupToken')
    q=meetupToken.client.get('https://api.meetup.com/2/groups?member_id=self&fields=self')
    c=JSON.parse q.body

    #return array of group names, ids and current members role
    return c['results'].map{|a| [a['name'],a['id'],a['self']['role']]}.select{|w| w[2]!=nil}
  end

end
