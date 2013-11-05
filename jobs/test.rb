SCHEDULER.every '5m', :first_in => '5s' do |job|
  send_event("test",
             {title: "Hi",
              body: "Something else"})
end
