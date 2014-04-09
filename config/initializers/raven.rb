# required by getsentry.com
require 'raven'

Raven.configure do |config|
    config.dsn = 'https://45d47ab6137849ffa3cfe9195488d1ad:b25e7b2d40dc483485606f126bbd6ff7@app.getsentry.com/17304'
end
