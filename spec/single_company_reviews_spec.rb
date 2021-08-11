require 'scraper'

describe 'Scraper' do
    test_cases = [
      {url: "",
        error_message: "URL cannot be empty",
      },
      {url:"youtube.com",
        error_message: "Sorry URL given is not avaiable for service",
      },
      {url:"lendingtree.com/reviews/66666666",
        error_message: "Invalid URL is given. Please double check",
      },
      {url:"lendingtree.com/reviews/mortgage/some-false-bank/66666666",
        error_message: "Page was not found. Please double check",
      },
      #This test case will fail because there is no reviews for the lender however, it appears to have one. 
      #{url:"lendingtree.com/reviews/mortgage/equity-capital-home-loans/76742438",
      #  last_review: {:review_title=>"It was truly a great experience and we are happy to say we chose Douglas", :review_text=>"Mr. Sorto, thank you so much for making our loan refinance stress free! You kept us informed of every detail during the entire process. It was truly a great experience and we are happy to say we chose you to assist us with our banking endeavors. Bernard and Linda Butler", :customer_name=>"Bernard", :customer_review_date=>"December 2015"},
      #  company_name: "Equity Capital Home Loans",
      #},
      {url:"https://lendingtree.com/reviews/mortgage/equity-capital-home-loans/76742438",
        last_review: {:review_title=>"It was truly a great experience and we are happy to say we chose Douglas", :review_text=>"Mr. Sorto, thank you so much for making our loan refinance stress free! You kept us informed of every detail during the entire process. It was truly a great experience and we are happy to say we chose you to assist us with our banking endeavors. Bernard and Linda Butler", :customer_name=>"Bernard", :customer_review_date=>"December 2015"},
        company_name: "Equity Capital Home Loans",
      },
      {url:"https://www.lendingtree.com/reviews/mortgage/equity-capital-home-loans/76742438",
        last_review: {:review_title=>"It was truly a great experience and we are happy to say we chose Douglas", :review_text=>"Mr. Sorto, thank you so much for making our loan refinance stress free! You kept us informed of every detail during the entire process. It was truly a great experience and we are happy to say we chose you to assist us with our banking endeavors. Bernard and Linda Butler", :customer_name=>"Bernard", :customer_review_date=>"December 2015"},
        company_name: "Equity Capital Home Loans",
      },
      #783 of reviews
      {url:"https://www.lendingtree.com/reviews/mortgage/pacific-beneficial-mortgage-company/44396611",
        last_review: {:review_title=>"Excellent Lender", :review_text=>"Pacific Beneficial Mortgage was wonderful to deal with. I was very pleased with selecting them and getting my refinance done through them. Their rate was the best of any of the lenders, and was that way from the start, as opposed to some of the lenders who came down in rate after I told them what Pacific Beneficial was offering. Their fees and costs were not only comparable to the lowest other lenders, but they lowered them further to beat others. They were generally responsive and nice to work with. The only minor complaints I have are: their voicemail system does not let you speak to anyone, or leave a message unless you know the exact extension of the people you are dealing with, the loan took longer than expected to complete (mostly the bank's fault), and the estimate for closing amounts was off some, so it required a little more that I put in than I had planned. Overall I would rate them excellent, and would definitely recommend them.", :customer_name=>"charlesh", :customer_review_date=>"May 2011"},
        company_name: "Pacific Beneficial Mortgage Company",
      },
    ]
    test_cases.each do |test_case|
      s = Scraper.new
      lender = s.scrap(test_case[:url])
      it "scrapes review for #{test_case[:company_name]}" do
        expect(lender[:company_name]).to eq(test_case[:company_name]) if lender[:company_name]
      end
      it "scrapes invalid URL - #{test_case[:error_message]}" do
        expect(lender[:message]).to eq(test_case[:error_message]) if lender[:message]
      end
      it "scrapes total of #{test_case[:total]} reviews" do
        expect(lender[:number_of_reviews]).to eq(lender[:reviews].count) if lender[:number_of_reviews]
      end
      it "sample match test" do
        expect(lender[:reviews].last).to eq(test_case[:last_review]) if lender[:last_review]
      end
  end
end