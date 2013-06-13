# edit this file to contain credentials for the OAuth services you support.
# each entry needs a corresponding token model.
#
# eg. :twitter => TwitterToken, :hour_feed => HourFeedToken etc.
#
# OAUTH_CREDENTIALS={
#   :twitter=>{
#     :key=>"",
#     :secret=>"",
#     :client=>:twitter_gem, # :twitter_gem or :oauth_gem (defaults to :twitter_gem)
#     :expose => false, # expose client at /oauth_consumers/twitter/client see docs
#     :allow_login => true # Use :allow_login => true to allow user to login to account
#   },
#   :google=>{
#     :key=>"",
#     :secret=>"",
#     :expose => false, # expose client at /oauth_consumers/google/client see docs
#     :scope=>"" # see http://code.google.com/apis/gdata/faq.html#AuthScopes
#   },
#   :github=>{
#     :key => "",
#     :secret => "",
#     :expose => false, # expose client at /oauth_consumers/twitter/client see docs
#
#   },
#   :facebook=>{
#     :key => "",
#     :secret => ""
#   },
#   :agree2=>{
#     :key=>"",
#     :secret=>""
#   },
#   :fireeagle=>{
#     :key=>"",
#     :secret=>""
#   },
#   :oauth2_server => {
#      :key=>"",
#      :secret=>"",
#      :oauth_version => 2
#      :options=>{ # OAuth::Consumer options
#        :site=>"http://hourfeed.com" # Remember to add a site for a generic OAuth site
#      }
#   },
#   :hour_feed=>{
#     :key=>"",
#     :secret=>"",
#     :options=>{ # OAuth::Consumer options
#       :site=>"http://hourfeed.com" # Remember to add a site for a generic OAuth site
#     }
#   },
#   :nu_bux=>{
#     :key=>"",
#     :secret=>"",
#     :super_class=>"OpenTransactToken",  # if a OAuth service follows a particular standard
#                                         # with a token implementation you can set the superclass
#                                         # to use
#     :options=>{ # OAuth::Consumer options
#       :site=>"http://nubux.heroku.com"
#     }
#   }
# }
#
OAUTH_CREDENTIALS={
:twitter=>{
     :key=>"fLd7BkTymNZ9UCJtowfbrg",
     :secret=>"4synh85gGbZNNF4WDnxmSTcz8xlhPK3pU4jTgag7g",
     :client=>:twitter_gem, # :twitter_gem or :oauth_gem (defaults to :twitter_gem)
     :expose => false, # expose client at /oauth_consumers/twitter/client see docs
     :allow_login => true, # Use :allow_login => true to allow user to login to account
   },
:meetup=>{
     :key=>"l9rede3qbg68nn9cqbuc8it4hq",
     :secret=>"d5scii9c6q308h4vtu3opn3rft",
     :expose => false, # expose client at /oauth_consumers/google/client see docs
     :options =>{
       :site=> "http://www.meetup.com",
       :request_token_path=>"/oauth/request/",
       :access_token_path=>"/oauth/access/",
       :authorize_path=>"/authenticate/"
     }
   },
:facebook=>{
     :key => "443409775727621",
     :secret => "10442d4c66ddaf6d7d24f95d6e742e4d",
     :oauth_version => 2,
     :options=>{
       :site=>"https://graph.facebook.com",
       #:authorize_url => "https://www.facebook.com/dialog/oauth",
       :authorize_url => '/oauth/authorize',
       :token_url => '/oauth/access_token',
       #:request_token_path => "/oauth/request_token",
       #:access_token_path => '/oauth/access_token',
       :token_method=>:post,
       #:authorize_path => '/oauth/authorize',
       :token_params=> {:parse => :json},
       :scope => 'offline_access,email'
   }
}
} unless defined? OAUTH_CREDENTIALS

load 'oauth/models/consumers/service_loader.rb'
