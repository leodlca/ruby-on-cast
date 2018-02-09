require './back'
require './validation'

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
    puts "Aaaand it's over! Check the downloads folder, hope to see you again soon, press any key to leave.\n\n"
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