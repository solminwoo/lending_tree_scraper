class Scraper

  require 'nokogiri'
  require 'httparty'
  require 'byebug'

  def valid_url(url)
    if url.empty?
      return {status: false, message: "URL cannot be empty"}
    elsif !!! (url =~ /(lendingtree.com)/)
      return {status: false, message: "Sorry URL given is not avaiable for service"}
    #to handle input to be /reviews/personal/first-midwest-bank/52903183
    elsif !!! (url =~ /\/(reviews)\/[a-z]+\/[a-z.?=()-]+\/[0-9]+/)
      return {status: false, message: "Invalid URL is given. Please double check"}
    else
      return {status: true}
    end
  end
  
  def get_data(url, current_page)

    #Adding https://www for 1.HTTparty excepts url with http | https 2.www. for validation 
    if !!! (url.split("https://").last =~ /\A(www.)/)
      url = "https://www." + url.split("https://").last
    elsif !! (url =~ /(sortby)/)
      url = url.split("?sortby").first
    end

    url = url + "?sortby=MF9kZXNj&pid=#{current_page}"
    response = HTTParty.get( url )

    #checking current url is same with visited url (incase of redirected by invalid url)
    unless url == response.request.last_uri.to_s
      puts "Page was not found. Please double check"
      return {status: false, message: "Page was not found. Please double check"}
    end
    
    nokogiri_data = Nokogiri::HTML(response.body)
    company_reviews = nokogiri_data.css('div.mainReviews')
    any_reviews = !company_reviews&.empty? ? true : false
    return [ nokogiri_data, company_reviews, any_reviews ]
  end
  
  def scrap(url)
    puts "start scraping.."
    
    unless valid_url(url)[:status]
      puts valid_url(url)[:message]
      return valid_url(url)
    end
    
    #get all reviews by traveling all pages
    current_page = 1
    (nokogiri_data, company_reviews, any_reviews) = get_data(url, current_page)
    
    #early exit for case of error. 
    if nokogiri_data[:message]
      return nokogiri_data
    end

    lender = {
      company_name: nokogiri_data&.css('h1')&.text,
      recomendation_percent: nokogiri_data&.css('div.recommend-text')&.text&.split&.last,
      score: nokogiri_data&.css('p.total-reviews')&.text&.split&.first,
      number_of_reviews: nokogiri_data&.css('div.start-rating-reviews')&.text&.split&.first&.to_i,
      reviews: [],
    }

    while any_reviews
      company_reviews.each do |review|
        data = {
          review_title: review&.css('p.reviewTitle')&.text,
          review_text: review&.css('p.reviewText')&.text,
          customer_name: review&.css('p.consumerName')&.text&.split&.first,
          customer_review_date: review&.css('p.consumerReviewDate')&.text&.split('in ')&.last,
        }
        lender[:reviews] << data
      end
      
      current_page += 1
      (nokogiri_data, company_reviews, any_reviews) = get_data(url, current_page)
    end
    puts "scraping finished"
    return lender
  end
end

#a= Scraper.new
#3393 but acutal 3394
#a.scrap("https://lendingtree.com/reviews/personal/first-midwest-bank/52903183")

#506 but actual is 507
#a.scrap("https://www.lendingtree.com/reviews/mortgage/supreme-lending/42856463?sortby=MF9kZXNj&pid=20")

#1237 but actual is 1267
#a.scrap("https://www.lendingtree.com/reviews/mortgage/planet-home-lending/57728064")

#783
#a.scrap("https://www.lendingtree.com/reviews/mortgage/pacific-beneficial-mortgage-company/44396611")
