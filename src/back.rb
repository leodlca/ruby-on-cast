require 'open-uri'
require 'nokogiri'
require 'openssl'
require 'progress_bar'

NERDCAST_URL = "https://jovemnerd.com.br/nerdcast/"

@rootPage

def loadWebPage
    begin
        @rootPage = Nokogiri::HTML(open(NERDCAST_URL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)
    rescue => exception
        showErrorAndExit exception
    end
end

def getPodcastsURIs
    loadWebPage
    @rootPage.css("h2.entry-card__content-title a").map { |podcast| podcast["href"] }.uniq
end

def getPodcastsTitles
    @rootPage.css("h2.entry-card__content-title a").map { |podcast| podcast.text }.uniq 
end

def getDownloadLinks userInput

    loadURIs

    downloadLinks = []
    podcastsURIs = getPodcastsURIs

    userInput.each do |index|
        begin
            document = Nokogiri::HTML(open(podcastsURIs[index.to_i-1], {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

            downloadLinks << document.css("div.entry-header-actions__download noscript").search('a')[0]['href']
        rescue => exception
            showErrorAndExit exception
        end
    end

    downloadPodcasts downloadLinks
end

def downloadPodcasts downloadLinks

    loadDownloads

    downloadLinks.each_with_index do |uri, index|
        last = 0
        bar = nil
        filename = uri.gsub("https://nerdcast.jovemnerd.com.br/", "")
        begin
            f = open(filename, 'wb') do |fo|
                fo.print open(uri,

                :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,

                :content_length_proc => lambda { |total|
                    bar = ProgressBar.new(total)
                },
                
                :progress_proc => lambda {|current|
                    bar.increment! (current - last)
                    last = current
                }).read
            end
        ensure
            nMoreToGo(index, downloadLinks.length) if(downloadLinks.length - (index + 1) > 0)
        end
    end

    bye
end