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
    meetupToken.client.delay({:run_at => schedule_time}).post('https://api.meetup.com/2/event',{:group_id=>group_id,:name=>name,:description=>desc})
    #delay({:run_at => schedule_time})

    redirect_to :action => :index and return
  end

private
  def get_meetup_groups
    meetupToken=ConsumerToken.find_by_type('MeetupToken')
    q=meetupToken.client.get('https://api.meetup.com/2/groups?member_id=self')
    c=JSON.parse q.body
    return c['results'].map{|a| [a['name'],a['id']]}
  end

end
