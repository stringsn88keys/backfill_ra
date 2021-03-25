require 'watir'
require 'csv'
require 'date'

browser = Watir::Browser.new

eval(File.read(".config"))
browser.goto 'https://runningahead.com'
browser.text_field(type: 'email').set EMAIL
browser.text_field(type: 'password').set PASSWORD
sleep 50; exit
browser.button(type: 'submit').click
browser.link(text: 'Training Log').click
browser.link(text: 'Workouts').click
browser.link(text: 'New Run Entry').click
CSV.
CSV.foreach('activities.csv', headers: true) do |row|
    next unless ['Run', 'Walk'].include? row['Activity Type']
    activity_date = DateTime.parse(row['Activity Date'])
    local = activity_date.to_time.localtime
    next unless DateTime.parse(row['Activity Date'])> DateTime.parse('05/06/2020')
    browser.link(text: 'New Run Entry').click
    date_entry = local.strftime('%m/%d/%Y')
    browser.text_field(id: 'ctl00_ctl00_ctl00_SiteContent_PageContent_TrainingLogContent_Date').set date_entry 
    browser.text_field(id: 'ctl00_ctl00_ctl00_SiteContent_PageContent_TrainingLogContent_Date').send_keys(:tab)
    browser.span(class:'TimeOfDay').click
    time_entry = local.strftime('%I:%M %p')
    browser.text_field(id: 'RADom_24').set local.strftime('%I')
    browser.text_field(id: 'RADom_25').set local.strftime('%M')
    if browser.span(class: 'AmPm').text != local.strftime('%p')
        browser.span(class: 'Down').click
    end
    distance = row['Distance']
    browser.text_field(id: 'ctl00_ctl00_ctl00_SiteContent_PageContent_TrainingLogContent_Distance').click
    browser.text_field(id: 'ctl00_ctl00_ctl00_SiteContent_PageContent_TrainingLogContent_Distance').set distance 
    # I added this column from the Strava export
    duration = row['Duration']
    browser.text_field(id: 'ctl00_ctl00_ctl00_SiteContent_PageContent_TrainingLogContent_Duration').set duration
    browser.button(type: 'submit').click
    sleep(1)
end