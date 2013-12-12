Tire.configure do
  if Rails.env.development?
  #   url 'http://wallgig.net:9200'
    logger STDERR, level: 'debug'
  end
end