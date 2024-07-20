module Github
  class RetreiveDataFromHtml < ApplicationService
    HTML_SELECTORS = {
      page_title: 'head > title',
      stars_count: 'nav.js-sidenav-container-pjax a > span.Counter:nth-child(2)',
      followers_count: 'div.js-profile-editable-area a.Link--secondary > span:nth-child(2)',
      following_count: 'div.js-profile-editable-area a.Link--secondary > span:nth-child(1)',
      year_contributions_count: 'div.js-yearly-contributions > div > h2',
      profile_url: 'div.js-profile-editable-replace img.avatar',
      location: '//li[@itemprop="homeLocation"]//span[@class="p-label"]',
      organization_name: '//li[@itemprop="worksFor"]//span[@class="p-org"]/div'
    }

    DYNAMIC_COMPONENT_SELECTOR = 'div.js-yearly-contributions'

    def initialize(url:)
      @url = url
    end

    def call
      @html_content = DownloadDynamicHtml.download(url, wait_until_selector: DYNAMIC_COMPONENT_SELECTOR)

      return Failure(:not_found_profile) if not_found_profile?

      data = {
        stars_count:,
        followers_count:,
        following_count:,
        year_contributions_count:,
        profile_url:,
        location:,
        organization_name:
      }

      Success(data)
    end

    private

    attr_reader :url, :html_content

    def not_found_profile?
      document.css(HTML_SELECTORS[:page_title]).text.downcase.include?('page not found')
    end

    def stars_count
      document.css(HTML_SELECTORS[:stars_count]).first.text
    end

    def followers_count
      document.css(HTML_SELECTORS[:followers_count]).text
    end

    def following_count
      document.css(HTML_SELECTORS[:following_count]).text
    end

    def year_contributions_count
      value = document.css(HTML_SELECTORS[:year_contributions_count]).text
      match = value.match(/\d{1,3}(?:,\d{3})*/)

      return match[0].gsub(',', '') if match

      '0'
    end

    def profile_url
      document.css(HTML_SELECTORS[:profile_url]).first.attr('src')
    end

    def location
      document.xpath(HTML_SELECTORS[:location]).text
    end

    def organization_name
      document.xpath(HTML_SELECTORS[:organization_name]).text
    end

    def document
      @document ||= Nokogiri::HTML(html_content)
    end
  end
end
