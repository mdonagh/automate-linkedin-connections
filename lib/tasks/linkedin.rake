namespace :linkedin do
require 'webdrivers'
  desc "TODO"
  task post: :environment do
    puts 'hello'
    session = Capybara::Session.new(:selenium_chrome_headless)
    link = get_link(session)
    login(session)
    while(true)
      share_link(session, link)
      puts 'adding connections'
      add_connections(session)
      delete_old_screenshots
      link = get_link(session)
      puts 'long sleep now...'
      sleep(1200)
      session.visit 'https://www.linkedin.com/'
      sleep_randomly
    end
  end

  def add_connections(session)
    session.visit 'https://www.linkedin.com/mynetwork/'
    sleep_randomly
    click_connections(session)
    screenshot(session)
  end

  def delete_old_screenshots
    Dir.glob("*.png"){|file|
    if Dir.glob("*.png").count > 30
      File.delete(file)
    end
  }
  end

  def login(session)
    session.visit 'https://linkedin.com'
    screenshot(session)
    puts 'clicking X button'
    begin
      # Capybara throws an exception if the element is not found
      session.first('.switcher-tabs__cancel-btn').click
    rescue Capybara::ElementNotFound
      puts "X button not there"
    end 
    puts 'filling in email'
    sleep_randomly
    screenshot(session)
    begin
      # Capybara throws an exception if the element is not found
      session.first('.nav__button-secondary').click
    rescue Capybara::ElementNotFound
      puts "nav button not there"
    end 
    session.fill_in 'session_key', :with => 'YOUR_EMAIL'
    sleep_randomly
    screenshot(session)
    puts 'filling in password'
    session.fill_in 'password', :with => 'YOUR_PASSWORD'
    screenshot(session)
    puts 'clicking sign in'
    screenshot(session)
    session.click_button('Sign in')
    sleep_randomly
    sleep_randomly
  end

  def share_link(session, link)
    puts 'opening share box'
    session.first('.share-box__open').click
    screenshot(session)
    puts "clicking content editable box"
    # class="share-box__text-editor mentions-texteditor ember-view"
    session.first('.share-box__text-editor').click
    sleep_randomly
    screenshot(session)
    session.first('.share-box__text-editor-container').click
    sleep_randomly
    screenshot(session)
    sleep_randomly
    screenshot(session)
    session.first('.mentions-texteditor__content').click
    puts "pasting link"
    session.first('.mentions-texteditor__contenteditable').send_keys("#{link}\n")
    screenshot(session)
    sleep_randomly
    sleep_randomly
    sleep_randomly
    # puts "pasting newline"
    # session.first('.mentions-texteditor__contenteditable').send_keys("\n")
    # screenshot(session)
    # sleep_randomly
    puts 'clicking post button'
    session.find('.share-actions__primary-action').click
    #session.find('button[data-control-name="share.post"]').click
    screenshot(session)
    sleep_randomly
    sleep_randomly
    screenshot(session)
  end

  def run_capybara_action(session)

  end

  def click_connections(session)
    for i in 1..20 do
      puts "adding connection #{i}"
      begin
        session.first('button[data-control-name="invite"]').click
        sleep_randomly
      rescue => e
        session.visit 'https://www.linkedin.com/mynetwork/'
        sleep_randomly
        sleep_randomly
        puts e.inspect
    end
      #session.first('.artdeco-button__text', :text => 'Connect').click
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
    puts random_link
    random_link
  end

def find_random_link(links)
    random_link_index = rand(0..links.length - 1)
    links[random_link_index][:href]
end

def screenshot(session)
  session.save_screenshot("#{Time.now.to_s("%B %d, %Y")}_screenshot.png")
end

# This is to hide the fact that a script is doing this instead of a human by putting in pauses of random length
def sleep_randomly
  random_sleep = rand(5...10) * rand()
  sleep(random_sleep)
end 

end
