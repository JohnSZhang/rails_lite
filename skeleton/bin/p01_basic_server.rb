require 'webrick'
root_path = File.path(".")
server = WEBrick::HTTPServer.new Port: 3000, DocumentRoot: root_path

server.mount_proc '/' do |request, response|
  response.content_type = "text/text"
  response.body = root_path
end

trap('INT') { server.shutdown }
server.start