class ScheduleController < ApplicationController
  before_filter :authenticate_user!
  @@dateTimeFormat="%m-%d-%Y %H:%M"

  def index
    @meetup_groups=get_meetup_groups

    job_data=Delayed::Job.all.map{|a| [a.payload_object.token,a.payload_object.object.consumer.site, a.run_at]}
    job_runtime=Delayed::Job.all.reduce{|a,b| ({a.payload_object.token => a.run_at}).merge({b.payload_object.token => b.run_at})}
    @consumer_token_detail=ConsumerToken.joins('INNER JOIN users ON users.id=consumer_tokens.user_id').where(:token=>job_runtime.keys).where('users.id = ?',current_user.id)

    
  end
  def schedule_meetup_event
    schedule_time=buildTime(params['meetup_event_schedule_date'],params['meetup_event_schedule_time'],@@dateTimeFormat) 
    event_time=buildTime(params['meetup_event_date'],params['meetup_event_time'],@@dateTimeFormat)
    group_id=params['meetup_event_group']['meetup_group_id']
    name=params['meetup_event_name']
    desc=params['meetup_event_description']

    meetupToken=ConsumerToken.find_by_type('MeetupToken')
    meetupToken.client.delay({:run_at => schedule_time}).post('https://api.meetup.com/2/event',{:group_id=>group_id,:name=>name,:description=>desc,:time=>event_time.to_i/1000})

    redirect_to :action => :index and return
  end

  def schedule_tweet
    
    schedule_time=buildTime(params['tweet_schedule_date'],params['tweet_schedule_time'],@@dateTimeFormat)
    tweet=params['tweet']

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
private
  def buildTime(date,time,format)
    puts "#{date} #{time['(4i)']}:#{time['(5i)']}"
    Time.strptime("#{date} #{time['(4i)']}:#{time['(5i)']}",format) 
  end

end
