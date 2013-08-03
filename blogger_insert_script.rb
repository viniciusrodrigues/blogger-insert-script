require "google/api_client"
require "launchy"

OAUTH_SCOPE          = 'https://www.googleapis.com/auth/blogger'

GOOGLE_CLIENT_KEY    = "YOUR_GOOGLE_CLIENT_KEY"
GOOGLE_CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET"
REDIRECT_URI         = "YOUR_GOOGLE_CLIENT_REDIRECT_URI"
BLOG_ID              = "YOUR_BLOG_ID"

client = Google::APIClient.new
blogger = client.discovered_api('blogger', 'v3')

client.authorization.client_id     = GOOGLE_CLIENT_KEY
client.authorization.client_secret = GOOGLE_CLIENT_SECRET
client.authorization.redirect_uri  = REDIRECT_URI
client.authorization.scope         = OAUTH_SCOPE

auth_uri = client.authorization.authorization_uri(access_type: :offline).to_s
Launchy.open auth_uri

puts "*" * 80
puts "Enter authorization code: "
puts "*" * 80

client.authorization.code = gets.chomp
client.authorization.fetch_access_token!

result = client.execute(
  api_method: blogger.posts.insert,
  headers:    { "Content-Type" => "application/json"    },
  parameters: { "blogId"       => BLOG_ID },
  body_object:
    {
      "title"   => "TITLE_FOR_YOUR_BLOG_POST",
      "labels"  => [ "LABELS_FOR_YOUR_BLOG_POST" ], # [ label1, label2, label3 ]
      "content" => "CONTENT_FOR_YOUR_BLOG_POST"
    }
  )

  puts "*" * 80
  puts result.response.body
  puts "*" * 80
end
