require 'puppeteer-ruby'

class DownloadDynamicHtml
  TIMEOUT = 10 # Timeout in seconds

  def initialize(url, wait_until_selector: nil)
    @url = url
    @wait_until_selector = wait_until_selector
  end

  def self.download(url, wait_until_selector: nil)
    new(url, wait_until_selector: wait_until_selector).download
  end

  def download
    browser = Puppeteer.launch(headless: true, args: ['--no-sandbox', '--disable-gpu'])
    page = browser.new_page

    page.goto(url, wait_until: 'networkidle0', timeout: TIMEOUT * 1000)

    content = page.content

    browser.close
    content
  end

  private

  attr_reader :url, :wait_until_selector
end

