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