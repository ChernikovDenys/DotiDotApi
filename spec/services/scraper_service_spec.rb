require 'rails_helper'

RSpec.describe ScraperService, type: :service do
  describe '#scrape' do
    let(:url) { 'https://example.com' }
    let(:fields) { { 'price' => '.price', 'meta' => ['keywords'] } }
    let(:html_content) { '<html><meta name="keywords" content="test keywords"><div class="price">1000</div></html>' }
    
    context 'when scrape' do
      before do
        allow(URI).to receive(:open).and_return(html_content)
      end

      it 'returns the scraped data' do
        service = ScraperService.new
        result = service.scrape(url, fields)

        expect(result['price']).to eq('1000')
        expect(result['meta']['keywords']).to eq('test keywords')
      end
    end

    context 'when cache' do 
      before do
        Rails.cache.clear
        allow(URI).to receive(:open).and_return(html_content)
      end

      before(:each) do
        Rails.cache.clear
      end      

      it 'the result to avoid multiple downloads' do
        service = ScraperService.new
    
        expect(Rails.cache).to receive(:fetch).with(url, {expires_in: 5.minutes}).once.and_call_original
        
        service.scrape(url, fields)
        expect(URI).not_to receive(:open)

        service.scrape(url, fields)
      end
    end
  end
end
