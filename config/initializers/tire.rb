Tire.configure do
  if Rails.env.development?
    logger STDERR, level: 'debug'
  end
end