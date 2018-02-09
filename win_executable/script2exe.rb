# THIS FILE IS THE COMBINATION OF ALL THE OTHER FILES, I USE TO EASILY COMPILE THE PROJECT TO .exe USING THE OCRA GEM.

# CONTENT FROM back.rb

require 'open-uri'
require 'nokogiri'
require 'openssl'

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
        filename = uri.gsub("https://nerdcast.jovemnerd.com.br/", "")
        begin
            f = open(uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
            IO.copy_stream(f, filename)
        ensure
            nMoreToGo(index, downloadLinks.length) if(downloadLinks.length - (index + 1) > 0) 
            f.close()
        end
    end

    bye

end

# CONTENT FROM ui.rb

def loadTitles
    puts "\nLoading application..."
    loadWebPage
    getPodcastsTitles
end

def showTitles(podcastTitles)
    podcastTitles.each_with_index do |title, index|
        puts "#{index + 1} - #{title}"
    end    
end

def getUserInput(numberOfPodcasts)
    input = nil
    firstTime = true

    while !isInputValid? input, numberOfPodcasts
        if firstTime
            firstTime = false
        else
            showErrorAndTryAgain
        end

        begin
            puts "\nPlease select all the podcasts you want to download, separating their index number like this: 1 2 6 10\n"
            input = gets.chomp.split(" ").uniq
        rescue => exception
            showErrorAndTryAgain
        end
    end

    getDownloadLinks input
end

def showErrorAndTryAgain
    puts "Whoops, seems like you missed something. Please try again."
end

def showErrorAndExit error
    puts "Whoops, seems like something went wrong, please report the following error if you believe that's a bug:"
    puts error
    puts "Press any key to leave."
    gets
    exit
end

def loadURIs
    puts "\nGetting the podcasts URIs...\n"
end

def loadDownloads
    puts "Hey, now we're dowloading your podcast(s) and that can take some time, so just sit down and relax, we'll tell you when we're done!\n"
end

def nMoreToGo index, totalLength
    puts "\nOnly #{totalLength - (index + 1)} more to go!"
end

def bye
    puts "Aaaand it's over! Check the downloads folder, hope to see you again soon, press any key to leave!\n\n"
    gets
    exit
end

def main
    podcastTitles = loadTitles

    puts "\n\nHi there, welcome to the ruby-on-cast, a very simple nerdcast downloader!\n\n"
    puts "Here's a list of all the avaiable nerdcasts to download today:\n\n"

    showTitles podcastTitles

    getUserInput podcastTitles.length
end

# CONTENT FROM validation.rb

def isInputValid?(input, numberOfPodcasts)
    begin
        input = input.uniq
        if input.nil?
            return false
        elsif input.length <= 0
            return false
        else
            input.each do |number|
                number = number.to_i
                if number <= 0 || number > numberOfPodcasts
                    return false
                end
            end
        end
    rescue => exception
        return false
    end

    true
end  

# CONTENT FROM init.rb

main