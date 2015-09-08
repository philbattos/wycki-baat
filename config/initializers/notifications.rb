ActiveSupport::Notifications.subscribe "text-upload.response" do |name, start, finish, id, payload|
  puts "NOTIFICATION NAME: #{name}"
  # puts "NOTIFICATION START: #{start}"
  # puts "NOTIFICATION FINISH: #{finish}"
  # puts "NOTIFICATION ID: #{id}"
  # puts "NOTIFICATION PAYLOAD: #{payload}"
  puts "NOTIFICATION RESPONSE: #{payload[:response]}"
end