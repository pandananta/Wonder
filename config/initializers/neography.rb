Neography.configure do |config|
  config.protocol           =  Rails.env == "production" ? ENV["NEO4J_PROTOCOL"] : "http://"
  config.server             = Rails.env == "production" ? ENV["NEO4J_SERVER"] : "localhost"
  config.port               = Rails.env == "production" ? ENV["NEO4J_PORT"] : 7474
  config.directory          = ""  # prefix this path with '/'
  config.cypher_path        = "/cypher"
  config.gremlin_path       = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file           = "neography.log"
  config.log_enabled        = false
  config.slow_log_threshold = 0    # time in ms for query logging
  config.max_threads        = 20
  config.authentication     = 'basic'  # 'basic' or 'digest'
  config.username           = ENV["NEO4J_USERNAME"]
  config.password           = ENV["NEO4J_PASSWORD"]
  config.parser             = MultiJsonParser
end