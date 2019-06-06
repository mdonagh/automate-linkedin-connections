namespace :linkedin do
require 'webdrivers'
  desc "TODO"
  task post: :environment do
    session = Capybara::Session.new(:selenium_chrome_headless)
    link = get_link(session)
    puts link
    session.visit 'https://linkedin.com'
    puts 'filling in email'
    sleep_randomly
    screenshot(session)
    session.first('.nav__button-secondary').click
    session.fill_in 'session_key', :with => 'ADD EMAIL'
    sleep_randomly
    screenshot(session)
    puts 'filling in password'
    session.fill_in 'password', :with => 'ADD PASSWORD'
    screenshot(session)
    puts 'clicking sign in'
    screenshot(session)
    session.click_button('Sign in')
    sleep_randomly
    sleep_randomly
    puts 'opening share box'
    session.first('.share-box__open').click
    puts 'pasting link'
    screenshot(session)
    session.first('.mentions-texteditor__contenteditable').send_keys(link)
    sleep_randomly
    session.first('.mentions-texteditor__contenteditable').send_keys("\n")
    sleep_randomly
    puts 'posting link'
    session.click_button('Post')
    screenshot(session)
    puts 'adding connections'
    add_connections(session)
  end

  def add_connections(session)
    session.visit 'https://www.linkedin.com/mynetwork/'
    sleep_randomly
    begin
      retries ||= 0
      session.visit 'https://www.linkedin.com/mynetwork/'
      sleep_randomly
      click_connections(session)
      screenshot(session)
    rescue => e
      puts e.inspect
      retry if (retries += 1) < 3
    end
  end

  def click_connections(session)
    for i in 1..20 do
      puts "adding connection #{i}"
      session.first('.artdeco-button__text', :text => 'Connect').click
    end
  end

  def get_link(session)
    session.visit 'https://news.ycombinator.com/'
    links = session.all(:css, '.storylink')
    random_link = find_random_link(links)
    while(UsedLink.where(href: random_link).any?)
      random_link = find_random_link(links)
    end
    UsedLink.create(href: random_link)
    random_link
  end

def find_random_link(links)
    random_link_index = rand(0..links.length - 1)
    links[random_link_index][:href]
end

def screenshot(session)
  session.save_screenshot("#{Time.now.to_s("%B %d, %Y")}_screenshot.png")
end

# This is to hide the fact that a script is doing this instead of a human by putting in pauses of random length from 
def sleep_randomly
  random_sleep = rand(5...10) * rand()
  sleep(random_sleep)
end 

end
