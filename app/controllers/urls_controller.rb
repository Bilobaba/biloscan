require 'watir'
require 'pry'
require 'diffy'
require 'nokogiri'
require 'open-uri'


def new_browser
  options = Selenium::WebDriver::Chrome::Options.new

  # make a directory for chrome if it doesn't already exist
  chrome_dir = File.join Dir.pwd, %w(tmp chrome)
  FileUtils.mkdir_p chrome_dir
  user_data_dir = "--user-data-dir=#{chrome_dir}"
  # add the option for user-data-dir
  options.add_argument user_data_dir

  # let Selenium know where to look for chrome if we have a hint from
  # heroku. chromedriver-helper & chrome seem to work out of the box on osx,
  # but not on heroku.
  if chrome_bin = ENV["GOOGLE_CHROME_BIN"]
    options.add_argument "no-sandbox"
    options.binary = chrome_bin
    # give a hint to here too
    Selenium::WebDriver::Chrome.driver_path = \
    "/app/vendor/bundle/bin/chromedriver"
  end

  # headless!
  # keyboard entry wont work until chromedriver 2.31 is released
  options.add_argument "window-size=1200x600"
  options.add_argument "headless"
  options.add_argument "disable-gpu"

  # make the browser
  Watir::Browser.new :chrome, options: options
end

class PlainTextExtractor < Nokogiri::XML::SAX::Document
  # This method is called whenever a comment occurs and
  # the comments text is passed in as string.
  def comment(string)
    puts string
  end
end

class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy, :scan, :copy]

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render :show, status: :created, location: @url }
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scan
    scan_url(@url)
    redirect_to @url
  end

  # copy the last scan to bilobaba references
  def copy
    @url.text_bilobaba = @url.last_scan_text
    @url.date_bilobaba = @url.last_scan_date
    @url.text_diff = @url.text_diff_html = @url.text_diff_html_left = @url.text_diff_html_right = ""
    @url.save
    redirect_to @url
  end

  def scan_all
    Url.all.each do |u|
      scan_url(u)
    end
    redirect_to urls_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:path, :text_bilobaba, :date_bilobaba)
    end

    def scan_url(url)

      browser = new_browser
      browser.goto url.path
      # logo_div = browser.div(id: "hplogo")
      # image = logo_div.img
      # puts "Google says: #{image.alt}"
# binding.pry
      # browser = Watir::Browser.new :phantomjs
      # doc = Nokogiri::HTML(open(url.path))
# binding.pry
      browser.goto(url.path)
# binding.pry
      url.last_scan_text = browser.text
      url.last_scan_date = DateTime.now
# binding.pry
      url.text_diff =  Diffy::SplitDiff.new(url.text_bilobaba, url.last_scan_text).right
      url.text_diff_html =  Diffy::Diff.new(url.text_bilobaba, url.last_scan_text).to_s(:html)


      url.text_diff_html_left = Diffy::SplitDiff.new(url.text_bilobaba, url.last_scan_text, :format => :html).left
      url.text_diff_html_right = Diffy::SplitDiff.new(url.text_bilobaba, url.last_scan_text, :format => :html).right
      url.save
      browser.close
# binding.pry
  end

end
