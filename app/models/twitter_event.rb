class TwitterEvent < ActiveRecord::Base
  attr_accessible :send_datetime, :token_id, :tweet
end
