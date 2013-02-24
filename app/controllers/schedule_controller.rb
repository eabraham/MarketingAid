class ScheduleController < ApplicationController
  before_filter :authenticate_user!
  @@dateTimeFormat="%m-%d-%Y %H:%M"

  def index
    @meetup_groups=get_meetup_groups
    @meetup_groups_admin=get_meetup_groups(true)
 
    @has_meetup=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id).count>0

    job_data=Delayed::Job.all.map{|a| [a.payload_object.token,a.payload_object.object.consumer.site, a.run_at]}
    #job_runtime=Delayed::Job.all.reduce{|a,b| ({a.payload_object.token => a.run_at}).merge({b.payload_object.token => b.run_at})}
    @consumer_token_detail=ConsumerToken.joins('INNER JOIN users ON users.id=consumer_tokens.user_id').where(:token=>job_data.map{|a| a[0]}).where('users.id = ?',current_user.id)

    
  end
  def schedule_meetup_event
    schedule_time=buildTime(params['meetup_event_schedule_date'],params['meetup_event_schedule_time'],@@dateTimeFormat) 
    event_time=buildTime(params['meetup_event_date'],params['meetup_event_time'],@@dateTimeFormat)
    group_id=params['meetup_event_group']['meetup_group_id']
    name=params['meetup_event_name']
    desc=params['meetup_event_description']
    venue_id=params['meetup_event_venue_meetup_venue_id']

    meetupToken=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id)[0]
    meetupToken.client.delay({:run_at => schedule_time}).post('https://api.meetup.com/2/event',{:group_id=>group_id,:name=>name,:description=>desc,:time=>event_time.to_i*1000, :venue_id=>venue_id})

    redirect_to :action => :index and return
  end
  def schedule_meetup_comment
    schedule_time=buildTime(params['meetup_comment_schedule_date'],params['meetup_comment_schedule_time'],@@dateTimeFormat)
    event_id=params['meetup_event']['meetup_event_id']
    comment=params['meetup_event_comment']

    meetupToken=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id)[0]
    meetupToken.client.delay({:run_at => schedule_time}).post('https://api.meetup.com/2/event_comment',{:event_id=>event_id,:comment=>comment})

   redirect_to :action => :index and return 
  end
  def schedule_tweet
    
    schedule_time=buildTime(params['tweet_schedule_date'],params['tweet_schedule_time'],@@dateTimeFormat)
    tweet=params['tweet']

    tweetToken=ConsumerToken.where(:type=>'TwitterToken',:user_id=>current_user.id)[0]
    consumer=OAuth::Consumer.new(OAUTH_CREDENTIALS[:twitter][:key],OAUTH_CREDENTIALS[:twitter][:secret],{:site=> "http://api.twitter.com", :scheme=>:header})
    token_hash = {:oauth_token => tweetToken.token, :oauth_token_secret=>tweetToken.secret} 
    
    access_token = OAuth::AccessToken.from_hash(consumer,token_hash)

    access_token.delay({:run_at => schedule_time}).post('https://api.twitter.com/1.1/statuses/update.json',{:status=>tweet})

    redirect_to :action => :index and return
  end

  def get_group_venues
    group_id=params['group_id']

    meetupToken=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id)[0]
    q=meetupToken.client.get("https://api.meetup.com/2/venues?group_id=#{group_id}")
    c=JSON.parse q.body
    puts c['results'].count 

    render :json =>c['results'].map{|a| [a['id'],a['name'],a['address_1'],a['state'],a['city']]} 
  end
  def get_group_events
    group_id=params['group_id']
    meetupToken=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id)[0]
    q=meetupToken.client.get("https://api.meetup.com/2/events?member_id=self&group_id=#{group_id}")
    c=JSON.parse q.body

    render :json => c['results'].map{|a| [a['id'],a['name'],a['time']]}.sort_by{|d| d[2]}
  end

private
  def get_meetup_groups(isAdmin=false)
    meetupToken=ConsumerToken.where(:type=>'MeetupToken',:user_id=>current_user.id)[0]
    q=meetupToken.client.get('https://api.meetup.com/2/groups?member_id=self&fields=self')
    c=JSON.parse q.body

    #return array of group names, ids and current members role
    if isAdmin
      return c['results'].select{|a| a['self']['role']}.map{|b| [b['name'],b['id']]}.sort_by{|d| d[0]}
    else
      return c['results'].select{|a| a['self']}.map{|b| [b['name'],b['id']]}.sort_by{|d| d[0]}
    end
  end
private
  def buildTime(date,time,format)
    Time.strptime("#{date} #{time['(4i)']}:#{time['(5i)']}",format) 
  end

end
